import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _enabledKey = 'reminder_enabled';
const _timeKey = 'reminder_time';

class ReminderState {
  final bool enabled;
  final String time;

  const ReminderState({this.enabled = false, this.time = '21:00'});

  ReminderState copyWith({bool? enabled, String? time}) {
    return ReminderState(
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
    );
  }
}

class ReminderNotifier extends StateNotifier<ReminderState> {
  ReminderNotifier() : super(const ReminderState()) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    final enabled = box.get(_enabledKey, defaultValue: false) as bool;
    final time = box.get(_timeKey, defaultValue: '21:00') as String;
    state = ReminderState(enabled: enabled, time: time);
  }

  Future<void> setEnabled(bool enabled) async {
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.put(_enabledKey, enabled);
    state = state.copyWith(enabled: enabled);
  }

  Future<void> setTime(String time) async {
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.put(_timeKey, time);
    state = state.copyWith(time: time);
  }
}

final reminderProvider =
    StateNotifierProvider<ReminderNotifier, ReminderState>(
  (ref) => ReminderNotifier(),
);
