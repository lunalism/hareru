import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const contactEmail = 'hareru.info11@gmail.com';

void showContactSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final l10n = AppLocalizations.of(context)!;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _ContactSheet(isDark: isDark, l10n: l10n),
  );
}

class _ContactSheet extends StatelessWidget {
  const _ContactSheet({required this.isDark, required this.l10n});

  final bool isDark;
  final AppLocalizations l10n;

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: contactEmail));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.contactCopied)),
      );
    }
  }

  Future<void> _openMail(BuildContext context) async {
    final locale = Localizations.localeOf(context).languageCode;
    final info = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;

    final body = l10n.contactBody(
      info.version,
      iosInfo.systemVersion,
      iosInfo.utsname.machine,
      locale,
    );

    final uri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      queryParameters: {
        'subject': l10n.contactSubject,
        'body': body,
      },
    );

    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.contactFallback)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? const Color(0xFFF0ECE7) : const Color(0xFF1A1A1A);
    final textSecondary = const Color(0xFF8A8A8A);
    final cardBg =
        isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F0EB);
    final outlineBorder =
        isDark ? const Color(0xFF4A4A4A) : const Color(0xFFE5E0DB);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E0DB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text('\u{2709}\u{FE0F}', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            l10n.contactUs,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.contactDesc,
            style: TextStyle(fontSize: 14, color: textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _copyEmail(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                contactEmail,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      side: BorderSide(color: outlineBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _copyEmail(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '\u{1F4CB}',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.contactCopy,
                          style: TextStyle(
                            fontSize: 14,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE8453C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _openMail(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '\u{2709}\u{FE0F}',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.contactOpenMail,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
