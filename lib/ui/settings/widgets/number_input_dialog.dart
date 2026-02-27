/// Number input dialog for settings values.
///
/// Shared by connection and notification sections.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/settings_provider.dart';

/// Shows a number input dialog and saves the result to settings.
void showNumberInput(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String key,
  required int current,
  required int min,
  required int max,
}) {
  showDialog(
    context: context,
    builder: (_) => NumberInputDialog(
      title: title,
      current: current,
      min: min,
      max: max,
      onSave: (value) {
        ref
            .read(settingsNotifierProvider.notifier)
            .set(key, value.toString());
      },
    ),
  );
}

/// Dialog for entering a numeric value within a range.
class NumberInputDialog extends StatefulWidget {
  const NumberInputDialog({
    super.key,
    required this.title,
    required this.current,
    required this.min,
    required this.max,
    required this.onSave,
  });

  final String title;
  final int current;
  final int min;
  final int max;
  final ValueChanged<int> onSave;

  @override
  State<NumberInputDialog> createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<NumberInputDialog> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.current}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validate() {
    final l10n = AppLocalizations.of(context);
    final val = int.tryParse(_controller.text);
    if (val == null) {
      setState(() => _error = l10n.numberInputInvalidNumber);
    } else if (val < widget.min || val > widget.max) {
      setState(
          () => _error = l10n.numberInputRangeError(widget.min.toString(), widget.max.toString()));
    } else {
      setState(() => _error = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title, style: AppTypography.h2),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          errorText: _error,
          hintText: '${widget.current}',
        ),
        onChanged: (_) => _validate(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            _validate();
            if (_error != null) return;
            final val = int.parse(_controller.text);
            widget.onSave(val);
            Navigator.of(context).pop();
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
