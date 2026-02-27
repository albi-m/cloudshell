/// Appearance settings section.
///
/// Theme mode, terminal theme, font family/size, cursor style,
/// ligatures, and language selection.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/terminal_themes.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/settings_provider.dart';
import '../custom_theme_editor_screen.dart';
import '../widgets/settings_section.dart';

/// Appearance section of the settings screen.
class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  static String themeModeLabel(ThemeMode mode, AppLocalizations l10n) =>
      switch (mode) {
        ThemeMode.dark => l10n.themeModeDark,
        ThemeMode.light => l10n.themeModeLight,
        ThemeMode.system => l10n.themeModeSystem,
      };

  static String fontDisplayName(String family) => switch (family) {
        'JetBrainsMono' => 'JetBrains Mono',
        'FiraCode' || 'Fira Code' => 'Fira Code',
        'SourceCodePro' || 'Source Code Pro' => 'Source Code Pro',
        'RobotoMono' || 'Roboto Mono' => 'Roboto Mono',
        'IBMPlexMono' || 'IBM Plex Mono' => 'IBM Plex Mono',
        'UbuntuMono' || 'Ubuntu Mono' => 'Ubuntu Mono',
        'AnonymousPro' || 'Anonymous Pro' => 'Anonymous Pro',
        'PTMono' || 'PT Mono' => 'PT Mono',
        _ => family,
      };

  static String cursorStyleLabel(String style, AppLocalizations l10n) =>
      switch (style) {
        'underline' => l10n.cursorStyleUnderline,
        'bar' => l10n.cursorStyleVerticalBar,
        _ => l10n.cursorStyleBlock,
      };

  static Map<String, String> supportedLanguages(AppLocalizations l10n) => {
        'system': l10n.languageSystem,
        'en': l10n.languageEnglish,
        'es': l10n.languageSpanish,
        'de': l10n.languageGerman,
        'fr': l10n.languageFrench,
        'ja': l10n.languageJapanese,
        'zh': l10n.languageChinese,
        'ko': l10n.languageKorean,
      };

  static String languageDisplayName(String code, AppLocalizations l10n) =>
      supportedLanguages(l10n)[code] ?? code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final terminalThemeId = ref.watch(terminalThemeIdProvider);
    final terminalFontSize = ref.watch(terminalFontSizeProvider);
    final terminalFontFamily = ref.watch(terminalFontFamilyProvider);
    final terminalCursorStyle = ref.watch(terminalCursorStyleProvider);
    final terminalLigatures = ref.watch(terminalLigaturesProvider);

    return SettingsSection(
      title: l10n.sectionAppearance,
      children: [
        SettingsTile(
          icon: LucideIcons.palette,
          title: l10n.settingThemeTitle,
          subtitle: themeModeLabel(themeMode, l10n),
          onTap: () => _showThemePicker(context, ref, themeMode),
        ),
        SettingsTile(
          icon: LucideIcons.monitor,
          title: l10n.settingTerminalThemeTitle,
          subtitle:
              ref.watch(allTerminalThemesProvider)[terminalThemeId]?.name ??
                  TerminalThemes.byId(terminalThemeId).name,
          onTap: () =>
              _showTerminalThemePicker(context, ref, terminalThemeId),
        ),
        SettingsTile(
          icon: LucideIcons.type,
          title: l10n.settingFontFamilyTitle,
          subtitle: fontDisplayName(terminalFontFamily),
          onTap: () =>
              _showFontFamilyPicker(context, ref, terminalFontFamily),
        ),
        SettingsTile(
          icon: LucideIcons.caseSensitive,
          title: l10n.settingFontSizeTitle,
          subtitle: l10n
              .settingFontSizeSuffix(terminalFontSize.toInt().toString()),
          onTap: () =>
              _showFontSizePicker(context, ref, terminalFontSize),
        ),
        SettingsTile(
          icon: LucideIcons.textCursorInput,
          title: l10n.settingCursorStyleTitle,
          subtitle: cursorStyleLabel(terminalCursorStyle, l10n),
          onTap: () => _showCursorStylePicker(
              context, ref, terminalCursorStyle),
        ),
        SettingsTile(
          icon: LucideIcons.link,
          title: l10n.settingFontLigaturesTitle,
          subtitle: terminalLigatures
              ? l10n.settingFontLigaturesEnabled
              : l10n.settingFontLigaturesDisabled,
          trailing: Switch(
            value: terminalLigatures,
            onChanged: (value) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .set(SettingsKeys.terminalLigatures, value.toString());
            },
          ),
        ),
        SettingsTile(
          icon: LucideIcons.languages,
          title: l10n.settingLanguageTitle,
          subtitle: languageDisplayName(
            ref.watch(settingProvider(SettingsKeys.language)).value ??
                'system',
            l10n,
          ),
          onTap: () => _showLanguagePicker(context, ref),
        ),
      ],
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = ref
            .read(settingProvider(SettingsKeys.language))
            .value ??
        'system';
    final languages = supportedLanguages(l10n);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingLanguageTitle, style: AppTypography.h2),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        content: RadioGroup<String>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .set(SettingsKeys.language, value);
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in languages.entries)
                RadioListTile<String>(
                  title: Text(entry.value),
                  value: entry.key,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(
      BuildContext context, WidgetRef ref, ThemeMode current) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.themePickerTitle, style: AppTypography.h2),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        content: RadioGroup<ThemeMode>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) {
              final modeStr = switch (value) {
                ThemeMode.dark => 'dark',
                ThemeMode.light => 'light',
                ThemeMode.system => 'system',
              };
              ref
                  .read(settingsNotifierProvider.notifier)
                  .set(SettingsKeys.themeMode, modeStr);
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final mode
                  in [ThemeMode.dark, ThemeMode.light, ThemeMode.system])
                RadioListTile<ThemeMode>(
                  title: Text(themeModeLabel(mode, l10n)),
                  value: mode,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showTerminalThemePicker(
      BuildContext context, WidgetRef ref, String currentId) {
    showDialog(
      context: context,
      builder: (_) => TerminalThemePickerDialog(
        currentId: currentId,
        onSelect: (id) {
          ref
              .read(settingsNotifierProvider.notifier)
              .set(SettingsKeys.terminalTheme, id);
        },
        onCreateCustom: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => const CustomThemeEditorScreen(),
            ),
          );
        },
        onEditCustom: (id) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => CustomThemeEditorScreen(existingThemeId: id),
            ),
          );
        },
        onDeleteCustom: (id) async {
          await ref
              .read(settingsNotifierProvider.notifier)
              .delete('custom_theme_$id');
          if (currentId == id) {
            await ref
                .read(settingsNotifierProvider.notifier)
                .set(SettingsKeys.terminalTheme, 'cloudshell_default');
          }
        },
      ),
    );
  }

  void _showFontSizePicker(
      BuildContext context, WidgetRef ref, double currentSize) {
    showDialog(
      context: context,
      builder: (_) => FontSizePickerDialog(
        currentSize: currentSize,
        onSave: (size) {
          ref
              .read(settingsNotifierProvider.notifier)
              .set(SettingsKeys.terminalFontSize, size.toString());
        },
      ),
    );
  }

  void _showFontFamilyPicker(
      BuildContext context, WidgetRef ref, String currentFamily) {
    showDialog(
      context: context,
      builder: (_) => FontFamilyPickerDialog(
        currentFamily: currentFamily,
        onSelect: (family) {
          ref
              .read(settingsNotifierProvider.notifier)
              .set(SettingsKeys.terminalFontFamily, family);
        },
      ),
    );
  }

  void _showCursorStylePicker(
      BuildContext context, WidgetRef ref, String currentStyle) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cursorStylePickerTitle, style: AppTypography.h2),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        content: RadioGroup<String>(
          groupValue: currentStyle,
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .set(SettingsKeys.terminalCursorStyle, value);
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in [
                ('block', l10n.cursorStyleBlock, '\u2588'),
                ('underline', l10n.cursorStyleUnderline, '_'),
                ('bar', l10n.cursorStyleVerticalBar, '\u2502'),
              ])
                RadioListTile<String>(
                  title: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text(
                          entry.$3,
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(entry.$2),
                    ],
                  ),
                  value: entry.$1,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Terminal Theme Picker Dialog
// ---------------------------------------------------------------------------

/// Dialog for selecting a terminal color theme.
class TerminalThemePickerDialog extends ConsumerWidget {
  const TerminalThemePickerDialog({
    super.key,
    required this.currentId,
    required this.onSelect,
    this.onCreateCustom,
    this.onEditCustom,
    this.onDeleteCustom,
  });

  final String currentId;
  final ValueChanged<String> onSelect;
  final VoidCallback? onCreateCustom;
  final ValueChanged<String>? onEditCustom;
  final ValueChanged<String>? onDeleteCustom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final customThemes = ref.watch(customTerminalThemesProvider);
    final builtInEntries = TerminalThemes.all.entries.toList();
    final customEntries = customThemes.entries.toList();

    return AlertDialog(
      title: Text(l10n.terminalThemePickerTitle, style: AppTypography.h2),
      contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
      content: SizedBox(
        width: 400,
        child: ListView(
          shrinkWrap: true,
          children: [
            if (customEntries.isNotEmpty) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  l10n.terminalThemeCustomThemesHeader,
                  style: AppTypography.overline.copyWith(
                    color: AppColors.accentPrimary,
                    fontSize: 10,
                  ),
                ),
              ),
              for (final entry in customEntries)
                _buildThemeRow(
                  context,
                  id: entry.key,
                  theme: entry.value,
                  isCustom: true,
                ),
              const Divider(height: 16, indent: 16, endIndent: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  l10n.terminalThemeBuiltInThemesHeader,
                  style: AppTypography.overline.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
            for (final entry in builtInEntries)
              _buildThemeRow(
                context,
                id: entry.key,
                theme: entry.value,
                isCustom: false,
              ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onCreateCustom?.call();
          },
          icon: const Icon(LucideIcons.plus, size: 16),
          label: Text(l10n.terminalThemeNewTheme),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  Widget _buildThemeRow(
    BuildContext context, {
    required String id,
    required TerminalTheme theme,
    required bool isCustom,
  }) {
    final l10n = AppLocalizations.of(context);
    final isSelected = id == currentId;

    return InkWell(
      onTap: () {
        onSelect(id);
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.accentPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Row(
          children: [
            ThemeSwatches(theme: theme),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                theme.name,
                style: AppTypography.body.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isCustom) ...[
              IconButton(
                icon: const Icon(LucideIcons.pencil, size: 14),
                tooltip: l10n.terminalThemeEditTooltip,
                onPressed: () {
                  Navigator.of(context).pop();
                  onEditCustom?.call(id);
                },
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2,
                    size: 14, color: AppColors.accentRed),
                tooltip: l10n.terminalThemeDeleteTooltip,
                onPressed: () {
                  onDeleteCustom?.call(id);
                  Navigator.of(context).pop();
                },
                visualDensity: VisualDensity.compact,
              ),
            ],
            if (isSelected)
              const Icon(LucideIcons.check,
                  size: 18, color: AppColors.accentPrimary),
          ],
        ),
      ),
    );
  }
}

/// Row of color swatches showing a theme's palette.
class ThemeSwatches extends StatelessWidget {
  const ThemeSwatches({super.key, required this.theme});

  final TerminalTheme theme;

  @override
  Widget build(BuildContext context) {
    final colors = [
      theme.background,
      theme.foreground,
      theme.red,
      theme.green,
      theme.blue,
      theme.cyan,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: colors
          .map((c) => Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(right: 2),
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Font Size Picker Dialog
// ---------------------------------------------------------------------------

/// Dialog for selecting terminal font size with a slider and preview.
class FontSizePickerDialog extends StatefulWidget {
  const FontSizePickerDialog({
    super.key,
    required this.currentSize,
    required this.onSave,
  });

  final double currentSize;
  final ValueChanged<double> onSave;

  @override
  State<FontSizePickerDialog> createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<FontSizePickerDialog> {
  late double _size;

  double get _defaultSize => PlatformUtils.isDesktop
      ? AppConstants.defaultTerminalFontSizeDesktop
      : AppConstants.defaultTerminalFontSizeMobile;

  @override
  void initState() {
    super.initState();
    _size = widget.currentSize;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.fontSizePickerTitle, style: AppTypography.h2),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgDeepest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l10n.fontSizePreviewText,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: _size,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(l10n.settingFontSizeSuffix(_size.toInt().toString()),
                  style: AppTypography.body
                      .copyWith(fontWeight: FontWeight.w600)),
              Expanded(
                child: Slider(
                  value: _size,
                  min: 10,
                  max: 24,
                  divisions: 14,
                  onChanged: (v) => setState(() => _size = v),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _size = _defaultSize);
          },
          child: Text(l10n.fontSizeReset),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(_size);
            Navigator.of(context).pop();
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Font Family Picker Dialog
// ---------------------------------------------------------------------------

/// Dialog for selecting a terminal font family.
class FontFamilyPickerDialog extends StatelessWidget {
  const FontFamilyPickerDialog({
    super.key,
    required this.currentFamily,
    required this.onSelect,
  });

  final String currentFamily;
  final ValueChanged<String> onSelect;

  TextStyle _fontStyle(String family) {
    return switch (family) {
      'JetBrainsMono' => const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 14,
        ),
      'Fira Code' => GoogleFonts.firaCode(fontSize: 14),
      'Source Code Pro' => GoogleFonts.sourceCodePro(fontSize: 14),
      'Roboto Mono' => GoogleFonts.robotoMono(fontSize: 14),
      'IBM Plex Mono' => GoogleFonts.ibmPlexMono(fontSize: 14),
      'Inconsolata' => GoogleFonts.inconsolata(fontSize: 14),
      'Ubuntu Mono' => GoogleFonts.ubuntuMono(fontSize: 14),
      'Cousine' => GoogleFonts.cousine(fontSize: 14),
      'Anonymous Pro' => GoogleFonts.anonymousPro(fontSize: 14),
      'PT Mono' => GoogleFonts.ptMono(fontSize: 14),
      _ => TextStyle(fontFamily: family, fontSize: 14),
    };
  }

  String _displayName(String family) => switch (family) {
        'JetBrainsMono' => 'JetBrains Mono',
        _ => family,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.fontFamilyPickerTitle, style: AppTypography.h2),
      contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
      content: SizedBox(
        width: 400,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: AppConstants.terminalFonts.length,
          itemBuilder: (context, index) {
            final family = AppConstants.terminalFonts[index];
            final isSelected = family == currentFamily;

            return InkWell(
              onTap: () {
                onSelect(family);
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: isSelected
                    ? BoxDecoration(
                        color:
                            AppColors.accentPrimary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _displayName(family),
                            style: AppTypography.body.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.fontFamilyPreviewText,
                            style: _fontStyle(family).copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(LucideIcons.check,
                          size: 18, color: AppColors.accentPrimary),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
