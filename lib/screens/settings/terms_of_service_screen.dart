import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/data/legal_texts.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final text = LegalTexts.getTermsOfService(locale);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: c.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.termsOfService,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              l10n.lastUpdatedDate,
              style: TextStyle(
                fontSize: 14,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: c.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _buildStyledText(text, isDark),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => launchUrl(
                Uri.parse('mailto:hareru.app@gmail.com'),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text('\u{2709}\u{FE0F}',
                        style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.contactUs,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: c.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'hareru.app@gmail.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 22,
                      color: c.textTertiary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledText(String text, bool isDark) {
    final lines = text.split('\n');
    final spans = <InlineSpan>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (i > 0) spans.add(const TextSpan(text: '\n'));

      if (_isSectionTitle(line)) {
        if (i > 0) spans.add(const TextSpan(text: '\n'));
        spans.add(TextSpan(
          text: line,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: HareruColors.primaryStart,
          ),
        ));
      } else if (_isMainTitle(line)) {
        spans.add(TextSpan(
          text: line,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: line,
          style: TextStyle(
            fontSize: 14,
            height: 1.7,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
        ));
      }
    }

    return Text.rich(TextSpan(children: spans));
  }

  bool _isSectionTitle(String line) {
    // Japanese: 第○条（...）
    if (RegExp(r'^第\d+条').hasMatch(line)) return true;
    // Korean: 제○조 (...)
    if (RegExp(r'^제\d+조').hasMatch(line)) return true;
    // English: Article N (...)
    if (RegExp(r'^Article \d+').hasMatch(line)) return true;
    return false;
  }

  bool _isMainTitle(String line) {
    return line == '利用規約' || line == '이용약관' || line == 'Terms of Service';
  }
}
