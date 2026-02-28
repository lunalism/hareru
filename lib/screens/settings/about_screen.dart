import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/screens/settings/privacy_policy_screen.dart';
import 'package:hareru/screens/settings/terms_of_service_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _appVersion = info.version);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;

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
          l10n.aboutApp,
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
          children: [
            const SizedBox(height: 32),

            // Logo
            SvgPicture.asset(
              isDark
                  ? 'assets/icon/hareru-symbol-white.svg'
                  : 'assets/icon/hareru-symbol-color.svg',
              width: 64,
              height: 64,
            ),
            const SizedBox(height: 16),

            // App name
            Text(
              'Hareru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),

            // Version
            Text(
              '${l10n.version} $_appVersion',
              style: TextStyle(
                fontSize: 14,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Catchphrase
            Text(
              l10n.appCatchphrase,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Links card
            Container(
              decoration: BoxDecoration(
                color: c.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _linkRow(
                    emoji: '\u{1F4C4}',
                    label: l10n.termsOfService,
                    isDark: isDark,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const TermsOfServiceScreen(),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    indent: 54,
                    color: c.divider,
                  ),
                  _linkRow(
                    emoji: '\u{1F512}',
                    label: l10n.privacyPolicy,
                    isDark: isDark,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    indent: 54,
                    color: c.divider,
                  ),
                  _linkRow(
                    emoji: '\u{2709}\u{FE0F}',
                    label: l10n.contactUs,
                    isDark: isDark,
                    onTap: () => launchUrl(
                      Uri.parse('mailto:hareru.app@gmail.com'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Copyright
            Text(
              l10n.copyright,
              style: TextStyle(
                fontSize: 12,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _linkRow({
    required String emoji,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? HareruColors.darkTextPrimary
                      : HareruColors.lightTextPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
