import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptScanPage extends StatelessWidget {
  const ReceiptScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.receiptScanTitle,
          style: const TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.receiptScanTitle,
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.receiptScanComingSoon,
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => _openCamera(context),
                icon: const Icon(Icons.camera_alt_rounded, size: 20),
                label: Text(
                  l10n.receiptScan,
                  style: const TextStyle(
                    fontFamily: 'PretendardJP',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final picker = ImagePicker();
      await picker.pickImage(source: ImageSource.camera);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.receiptScanComingSoon,
              style: const TextStyle(fontFamily: 'PretendardJP'),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.receiptScanComingSoon,
              style: const TextStyle(fontFamily: 'PretendardJP'),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
