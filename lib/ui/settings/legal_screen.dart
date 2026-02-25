/// Reusable screen for displaying legal documents.
///
/// Loads markdown content from an asset file and renders it
/// with basic formatting (headings, paragraphs, bullets).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

/// Full-screen legal document viewer.
///
/// Loads a markdown file from assets and renders it with basic
/// formatting. Used for Privacy Policy and Terms of Service.
class LegalScreen extends StatefulWidget {
  const LegalScreen({
    super.key,
    required this.title,
    required this.assetPath,
  });

  final String title;
  final String assetPath;

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  String? _content;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final content = await rootBundle.loadString(widget.assetPath);
      if (mounted) setState(() => _content = content);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() => _error = l10n.legalScreenLoadError);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _error != null
          ? Center(child: Text(_error!, style: AppTypography.body))
          : _content == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: _buildMarkdown(theme),
                    ),
                  ),
                ),
    );
  }

  Widget _buildMarkdown(ThemeData theme) {
    final lines = _content!.split('\n');
    final widgets = <Widget>[];
    var i = 0;

    while (i < lines.length) {
      final line = lines[i];

      if (line.startsWith('# ')) {
        // H1
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            line.substring(2),
            style: AppTypography.h1,
          ),
        ));
      } else if (line.startsWith('## ')) {
        // H2
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            line.substring(3),
            style: AppTypography.h2,
          ),
        ));
      } else if (line.startsWith('**') && line.endsWith('**')) {
        // Bold standalone line
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Text(
            line.substring(2, line.length - 2),
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ));
      } else if (line.startsWith('- **')) {
        // Bold list item
        final content = line.substring(2);
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('\u2022  '),
              Expanded(child: _buildRichText(content, theme)),
            ],
          ),
        ));
      } else if (line.startsWith('- ')) {
        // List item
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('\u2022  '),
              Expanded(
                child: Text(line.substring(2), style: AppTypography.body),
              ),
            ],
          ),
        ));
      } else if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
      } else {
        // Regular paragraph
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2),
          child: _buildRichText(line, theme),
        ));
      }

      i++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  /// Renders inline **bold** formatting within a line.
  Widget _buildRichText(String text, ThemeData theme) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    var lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: AppTypography.body,
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: AppTypography.body,
      ));
    }

    if (spans.isEmpty) {
      return Text(text, style: AppTypography.body);
    }

    return RichText(text: TextSpan(children: spans));
  }
}
