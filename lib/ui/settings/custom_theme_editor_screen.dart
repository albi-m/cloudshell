/// Custom terminal theme editor screen.
///
/// Allows users to create and edit custom terminal color themes
/// with a live terminal preview showing all 20 ANSI colors.
/// Themes are persisted as JSON in the settings database.
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/terminal_themes.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

/// Screen for creating or editing a custom terminal theme.
///
/// Pass [existingThemeId] to edit an existing custom theme,
/// or [baseThemeId] to start from a built-in theme's colors.
class CustomThemeEditorScreen extends ConsumerStatefulWidget {
  const CustomThemeEditorScreen({
    super.key,
    this.existingThemeId,
    this.baseThemeId,
  });

  /// If editing an existing custom theme, its ID (e.g. 'custom_my_theme').
  final String? existingThemeId;

  /// If creating new, the built-in theme ID to copy colors from.
  final String? baseThemeId;

  @override
  ConsumerState<CustomThemeEditorScreen> createState() =>
      _CustomThemeEditorScreenState();
}

class _CustomThemeEditorScreenState
    extends ConsumerState<CustomThemeEditorScreen> {
  final _nameController = TextEditingController();
  late Map<String, Color> _colors;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initColors();
  }

  void _initColors() {
    // Load from existing custom theme or base theme
    TerminalTheme? base;

    if (widget.existingThemeId != null) {
      // Editing existing custom theme — load from settings
      final customThemes = ref.read(customTerminalThemesProvider);
      base = customThemes[widget.existingThemeId];
      final name = widget.existingThemeId!.replaceFirst('custom_', '');
      _nameController.text = name;
    }

    base ??= TerminalThemes.byId(widget.baseThemeId ?? 'cloudshell_default');

    _colors = _themeToMap(base);
  }

  Map<String, Color> _themeToMap(TerminalTheme theme) => {
        'background': theme.background,
        'foreground': theme.foreground,
        'cursor': theme.cursor,
        'selection': theme.selection,
        'black': theme.black,
        'red': theme.red,
        'green': theme.green,
        'yellow': theme.yellow,
        'blue': theme.blue,
        'magenta': theme.magenta,
        'cyan': theme.cyan,
        'white': theme.white,
        'brightBlack': theme.brightBlack,
        'brightRed': theme.brightRed,
        'brightGreen': theme.brightGreen,
        'brightYellow': theme.brightYellow,
        'brightBlue': theme.brightBlue,
        'brightMagenta': theme.brightMagenta,
        'brightCyan': theme.brightCyan,
        'brightWhite': theme.brightWhite,
      };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.customThemeNameRequired)),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final themeId = widget.existingThemeId ?? 'custom_${_sanitizeId(name)}';

      // Serialize colors to JSON
      final colorMap = <String, String>{};
      for (final entry in _colors.entries) {
        colorMap[entry.key] = _colorToHex(entry.value);
      }

      final json = jsonEncode({
        'name': name,
        'colors': colorMap,
      });

      // If renaming (existing ID differs from new name-based ID), delete old
      if (widget.existingThemeId != null && themeId != widget.existingThemeId) {
        await ref
            .read(settingsNotifierProvider.notifier)
            .delete('custom_theme_${widget.existingThemeId}');
      }

      await ref
          .read(settingsNotifierProvider.notifier)
          .set('custom_theme_$themeId', json);

      // Also set this as the active theme
      await ref
          .read(settingsNotifierProvider.notifier)
          .set(SettingsKeys.terminalTheme, themeId);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e, stackTrace) {
      ErrorHandler.handle(e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.userMessage(e)),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _sanitizeId(String name) =>
      name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');

  String _colorToHex(Color c) =>
      '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2, 8).toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isEditing = widget.existingThemeId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? l10n.customThemeEditTitle : l10n.customThemeNewTitle,
          style: AppTypography.h2,
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(LucideIcons.save, size: 16),
              label: Text(l10n.customThemeSave),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return _buildWideLayout(theme);
          }
          return _buildNarrowLayout(theme);
        },
      ),
    );
  }

  Widget _buildWideLayout(ThemeData theme) {
    return Row(
      children: [
        // Left: color editors
        Expanded(
          flex: 3,
          child: _buildColorEditors(theme),
        ),
        // Right: preview
        Expanded(
          flex: 2,
          child: _buildPreview(),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(ThemeData theme) {
    return Column(
      children: [
        // Preview (compact)
        SizedBox(height: 160, child: _buildPreview()),
        // Color editors
        Expanded(child: _buildColorEditors(theme)),
      ],
    );
  }

  Widget _buildColorEditors(ThemeData theme) {
    final l10n = AppLocalizations.of(context);

    /// Color field labels using l10n.
    final chromeFields = [
      ('background', l10n.colorBackground),
      ('foreground', l10n.colorForeground),
      ('cursor', l10n.colorCursor),
      ('selection', l10n.colorSelection),
    ];

    final normalFields = [
      ('black', l10n.colorBlack),
      ('red', l10n.colorRed),
      ('green', l10n.colorGreen),
      ('yellow', l10n.colorYellow),
      ('blue', l10n.colorBlue),
      ('magenta', l10n.colorMagenta),
      ('cyan', l10n.colorCyan),
      ('white', l10n.colorWhite),
    ];

    final brightFields = [
      ('brightBlack', l10n.colorBrightBlack),
      ('brightRed', l10n.colorBrightRed),
      ('brightGreen', l10n.colorBrightGreen),
      ('brightYellow', l10n.colorBrightYellow),
      ('brightBlue', l10n.colorBrightBlue),
      ('brightMagenta', l10n.colorBrightMagenta),
      ('brightCyan', l10n.colorBrightCyan),
      ('brightWhite', l10n.colorBrightWhite),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Theme name
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.customThemeNameLabel,
            hintText: l10n.customThemeNameHint,
            prefixIcon: const Icon(LucideIcons.paintbrush, size: 18),
          ),
        ),
        const SizedBox(height: 24),

        // Chrome colors
        _sectionHeader(l10n.customThemeSectionTerminalChrome),
        const SizedBox(height: 8),
        _buildColorGrid(chromeFields),
        const SizedBox(height: 20),

        // Normal ANSI colors
        _sectionHeader(l10n.customThemeSectionNormalColors),
        const SizedBox(height: 8),
        _buildColorGrid(normalFields),
        const SizedBox(height: 20),

        // Bright ANSI colors
        _sectionHeader(l10n.customThemeSectionBrightColors),
        const SizedBox(height: 8),
        _buildColorGrid(brightFields),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.overline.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildColorGrid(List<(String, String)> fields) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: fields.map((field) {
        final (key, label) = field;
        return _ColorEditTile(
          label: label,
          color: _colors[key]!,
          onColorChanged: (c) => setState(() => _colors[key] = c),
        );
      }).toList(),
    );
  }

  Widget _buildPreview() {
    final l10n = AppLocalizations.of(context);
    final bg = _colors['background']!;
    final fg = _colors['foreground']!;
    final cursor = _colors['cursor']!;
    final selection = _colors['selection']!;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title bar
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Fake traffic lights
                for (final c in [
                  const Color(0xFFFF5F57),
                  const Color(0xFFFFBD2E),
                  const Color(0xFF28C840),
                ])
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.customThemePreviewTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: fg.withValues(alpha: 0.6),
                      fontSize: 11,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                ),
                const SizedBox(width: 52), // Balance traffic lights
              ],
            ),
          ),
          // Terminal content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  height: 1.6,
                  color: fg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Prompt
                    _previewLine([
                      TextSpan(
                          text: 'user',
                          style: TextStyle(color: _colors['green'])),
                      TextSpan(text: '@', style: TextStyle(color: fg)),
                      TextSpan(
                          text: 'server',
                          style: TextStyle(color: _colors['blue'])),
                      TextSpan(
                          text: ':',
                          style: TextStyle(color: fg)),
                      TextSpan(
                          text: '~',
                          style: TextStyle(color: _colors['cyan'])),
                      TextSpan(
                          text: '\$ ',
                          style: TextStyle(color: fg)),
                      TextSpan(
                          text: 'ls -la',
                          style: TextStyle(color: _colors['white'])),
                    ]),
                    // ls output
                    _previewLine([
                      TextSpan(
                          text: 'drwxr-xr-x  ',
                          style: TextStyle(color: _colors['white'])),
                      TextSpan(
                          text: 'src/',
                          style: TextStyle(
                            color: _colors['blue'],
                            fontWeight: FontWeight.bold,
                          )),
                    ]),
                    _previewLine([
                      TextSpan(
                          text: '-rw-r--r--  ',
                          style: TextStyle(color: _colors['white'])),
                      TextSpan(
                          text: 'README.md',
                          style: TextStyle(color: _colors['green'])),
                    ]),
                    _previewLine([
                      TextSpan(
                          text: '-rwxr-xr-x  ',
                          style: TextStyle(color: _colors['white'])),
                      TextSpan(
                          text: 'deploy.sh',
                          style: TextStyle(color: _colors['red'])),
                    ]),
                    _previewLine([
                      TextSpan(
                          text: '-rw-r--r--  ',
                          style: TextStyle(color: _colors['white'])),
                      TextSpan(
                          text: 'config.yaml',
                          style: TextStyle(color: _colors['yellow'])),
                    ]),
                    const SizedBox(height: 4),
                    // Git status
                    _previewLine([
                      TextSpan(
                          text: '\$ ',
                          style: TextStyle(color: fg)),
                      TextSpan(
                          text: 'git status',
                          style: TextStyle(color: _colors['white'])),
                    ]),
                    _previewLine([
                      TextSpan(
                          text: 'On branch ',
                          style: TextStyle(color: fg)),
                      TextSpan(
                          text: 'main',
                          style: TextStyle(color: _colors['magenta'])),
                    ]),
                    _previewLine([
                      TextSpan(
                          text: 'Changes not staged:',
                          style: TextStyle(color: _colors['yellow'])),
                    ]),
                    _previewLine([
                      TextSpan(
                          text: '  modified: ',
                          style: TextStyle(color: _colors['red'])),
                      TextSpan(
                          text: 'app.dart',
                          style: TextStyle(color: fg)),
                    ]),
                    const SizedBox(height: 4),
                    // Cursor line
                    Row(
                      children: [
                        Text('\$ ',
                            style: TextStyle(
                                color: fg,
                                fontFamily: 'JetBrainsMono',
                                fontSize: 12)),
                        Container(
                          width: 8,
                          height: 16,
                          color: cursor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Selection preview
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: selection.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        l10n.customThemePreviewSelectedText,
                        style: TextStyle(
                            color: fg,
                            fontFamily: 'JetBrainsMono',
                            fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Color palette strip
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        for (final key in [
                          'black', 'red', 'green', 'yellow',
                          'blue', 'magenta', 'cyan', 'white',
                          'brightBlack', 'brightRed', 'brightGreen',
                          'brightYellow',
                          'brightBlue', 'brightMagenta', 'brightCyan',
                          'brightWhite',
                        ])
                          Container(
                            width: 24,
                            height: 14,
                            decoration: BoxDecoration(
                              color: _colors[key],
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewLine(List<TextSpan> spans) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 12,
          height: 1.6,
          color: _colors['foreground'],
        ),
        children: spans,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Color Edit Tile
// ---------------------------------------------------------------------------

/// A compact color editor tile showing a swatch, label, and hex value.
///
/// Tapping opens a hex color input dialog.
class _ColorEditTile extends StatelessWidget {
  const _ColorEditTile({
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hex =
        '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2, 8).toUpperCase()}';

    return InkWell(
      onTap: () => _showColorPicker(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 170,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            // Color swatch
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    hex,
                    style: AppTypography.code(fontSize: 10).copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _HexColorPickerDialog(
        initialColor: color,
        label: label,
        onColorSelected: onColorChanged,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hex Color Picker Dialog
// ---------------------------------------------------------------------------

class _HexColorPickerDialog extends StatefulWidget {
  const _HexColorPickerDialog({
    required this.initialColor,
    required this.label,
    required this.onColorSelected,
  });

  final Color initialColor;
  final String label;
  final ValueChanged<Color> onColorSelected;

  @override
  State<_HexColorPickerDialog> createState() => _HexColorPickerDialogState();
}

class _HexColorPickerDialogState extends State<_HexColorPickerDialog> {
  late final TextEditingController _hexController;
  late Color _currentColor;
  late double _hue;
  late double _saturation;
  late double _brightness;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
    final hex = _currentColor.toARGB32()
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2, 8)
        .toUpperCase();
    _hexController = TextEditingController(text: hex);

    final hsv = HSVColor.fromColor(_currentColor);
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _brightness = hsv.value;
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  void _updateFromHex(String hex) {
    final cleaned = hex.replaceAll('#', '').trim();
    if (cleaned.length == 6) {
      final value = int.tryParse(cleaned, radix: 16);
      if (value != null) {
        final color = Color(0xFF000000 | value);
        final hsv = HSVColor.fromColor(color);
        setState(() {
          _currentColor = color;
          _hue = hsv.hue;
          _saturation = hsv.saturation;
          _brightness = hsv.value;
          _error = null;
        });
        return;
      }
    }
    setState(() => _error = AppLocalizations.of(context).hexColorInvalid);
  }

  void _updateFromHSV() {
    final color = HSVColor.fromAHSV(1.0, _hue, _saturation, _brightness)
        .toColor();
    final hex = color.toARGB32()
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2, 8)
        .toUpperCase();
    setState(() {
      _currentColor = color;
      _hexController.text = hex;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(widget.label, style: AppTypography.h2),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Large color preview
            Container(
              height: 64,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hex input
            TextField(
              controller: _hexController,
              decoration: InputDecoration(
                labelText: l10n.hexColorLabel,
                prefixText: '#',
                errorText: _error,
                suffixIcon: IconButton(
                  icon: const Icon(LucideIcons.clipboard, size: 16),
                  tooltip: l10n.hexColorPasteTooltip,
                  onPressed: () async {
                    final data = await Clipboard.getData('text/plain');
                    if (data?.text != null) {
                      _hexController.text =
                          data!.text!.replaceAll('#', '').trim();
                      _updateFromHex(_hexController.text);
                    }
                  },
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f]')),
                LengthLimitingTextInputFormatter(6),
              ],
              onChanged: _updateFromHex,
            ),
            const SizedBox(height: 16),

            // Hue slider
            _SliderRow(
              label: l10n.sliderHue,
              value: _hue,
              max: 360,
              gradient: LinearGradient(
                colors: List.generate(
                  7,
                  (i) => HSVColor.fromAHSV(1.0, i * 60, 1.0, 1.0).toColor(),
                ),
              ),
              onChanged: (v) {
                _hue = v;
                _updateFromHSV();
              },
            ),
            const SizedBox(height: 8),

            // Saturation slider
            _SliderRow(
              label: l10n.sliderSaturation,
              value: _saturation,
              max: 1,
              gradient: LinearGradient(
                colors: [
                  HSVColor.fromAHSV(1.0, _hue, 0, _brightness).toColor(),
                  HSVColor.fromAHSV(1.0, _hue, 1, _brightness).toColor(),
                ],
              ),
              onChanged: (v) {
                _saturation = v;
                _updateFromHSV();
              },
            ),
            const SizedBox(height: 8),

            // Brightness slider
            _SliderRow(
              label: l10n.sliderBrightness,
              value: _brightness,
              max: 1,
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  HSVColor.fromAHSV(1.0, _hue, _saturation, 1.0).toColor(),
                ],
              ),
              onChanged: (v) {
                _brightness = v;
                _updateFromHSV();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _error == null
              ? () {
                  widget.onColorSelected(_currentColor);
                  Navigator.of(context).pop();
                }
              : null,
          child: Text(l10n.hexColorApply),
        ),
      ],
    );
  }
}

/// A labeled slider with a gradient track for color picking.
class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.max,
    required this.gradient,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double max;
  final Gradient gradient;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 18,
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 10,
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              trackShape: _GradientTrackShape(gradient: gradient),
            ),
            child: Slider(
              value: value,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            max > 1
                ? value.toInt().toString()
                : (value * 100).toInt().toString(),
            style: AppTypography.caption.copyWith(fontSize: 10),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

/// Custom slider track shape that renders a gradient.
class _GradientTrackShape extends SliderTrackShape {
  const _GradientTrackShape({required this.gradient});

  final Gradient gradient;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 4;
    final trackLeft = offset.dx + 7;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width - 14;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(5));
    final paint = Paint()
      ..shader = gradient.createShader(rect);
    context.canvas.drawRRect(rrect, paint);

    // Border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;
    context.canvas.drawRRect(rrect, borderPaint);
  }
}
