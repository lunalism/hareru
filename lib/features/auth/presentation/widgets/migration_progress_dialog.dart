import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/services/migration_service.dart';

Future<void> showMigrationDialog(BuildContext context, WidgetRef ref) async {
  final migrationService = ref.read(migrationServiceProvider);

  // Skip if already migrated or no data to migrate
  if (migrationService.hasMigrated) return;

  final l10n = AppLocalizations.of(context)!;

  // Ask user if they want to sync
  final shouldSync = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(
        l10n.migrationPrompt,
        style: const TextStyle(
          fontFamily: 'PretendardJP',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            l10n.migrationLater,
            style: const TextStyle(fontFamily: 'PretendardJP'),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            l10n.migrationSync,
            style: const TextStyle(fontFamily: 'PretendardJP'),
          ),
        ),
      ],
    ),
  );

  if (shouldSync != true || !context.mounted) return;

  // Show progress dialog
  int syncedCount = 0;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              l10n.migrationInProgress,
              style: const TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  try {
    await migrationService.migrateAll(
      onProgress: (message) {
        // Parse count if available
        final countMatch = RegExp(r'(\d+)').firstMatch(message);
        if (countMatch != null) {
          syncedCount = int.tryParse(countMatch.group(1)!) ?? syncedCount;
        }
      },
    );
  } catch (_) {
    // Migration failed silently — user can retry later
  }

  if (!context.mounted) return;

  // Dismiss progress dialog
  Navigator.pop(context);

  // Show completion
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        syncedCount > 0
            ? l10n.migrationCount(syncedCount)
            : l10n.migrationComplete,
        style: const TextStyle(
          fontFamily: 'PretendardJP',
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    ),
  );
}
