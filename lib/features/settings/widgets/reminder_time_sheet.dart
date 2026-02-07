import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import '../../../core/theme/custom_colors.dart';

class ReminderTimeSheet extends StatefulWidget {
  const ReminderTimeSheet({super.key, required this.current});

  final TimeOfDay current;

  @override
  State<ReminderTimeSheet> createState() => _ReminderTimeSheetState();
}

class _ReminderTimeSheetState extends State<ReminderTimeSheet> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = DateTime(2024, 1, 1, widget.current.hour, widget.current.minute);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: custom.nightLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.notificationTime,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: _selected,
              use24hFormat: true,
              onDateTimeChanged: (dt) => _selected = dt,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  TimeOfDay(hour: _selected.hour, minute: _selected.minute),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.save,
                style: const TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
