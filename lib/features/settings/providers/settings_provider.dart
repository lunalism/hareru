import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryItem {
  const CategoryItem({required this.emoji, required this.name});
  final String emoji;
  final String name;

  CategoryItem copyWith({String? emoji, String? name}) =>
      CategoryItem(emoji: emoji ?? this.emoji, name: name ?? this.name);
}

class SettingsState {
  const SettingsState({
    this.monthlyBudget = 200000,
    this.startDayOfWeek = '월요일',
    this.autoExcludeTransfer = true,
    this.appLockEnabled = false,
    this.themeMode = '시스템',
    this.reminderEnabled = false,
    this.reminderTime = const TimeOfDay(hour: 21, minute: 0),
    this.language = '한국어',
    this.categories = _defaultCategories,
  });

  final int monthlyBudget;
  final String startDayOfWeek;
  final bool autoExcludeTransfer;
  final bool appLockEnabled;
  final String themeMode;
  final bool reminderEnabled;
  final TimeOfDay reminderTime;
  final String language;
  final List<CategoryItem> categories;

  static const _defaultCategories = [
    CategoryItem(emoji: '🍱', name: '식비'),
    CategoryItem(emoji: '🚃', name: '교통'),
    CategoryItem(emoji: '🛒', name: '쇼핑'),
    CategoryItem(emoji: '☕', name: '카페'),
    CategoryItem(emoji: '🎮', name: '여가'),
    CategoryItem(emoji: '💊', name: '의료'),
    CategoryItem(emoji: '💳', name: '이체'),
    CategoryItem(emoji: '📎', name: '기타'),
  ];

  SettingsState copyWith({
    int? monthlyBudget,
    String? startDayOfWeek,
    bool? autoExcludeTransfer,
    bool? appLockEnabled,
    String? themeMode,
    bool? reminderEnabled,
    TimeOfDay? reminderTime,
    String? language,
    List<CategoryItem>? categories,
  }) {
    return SettingsState(
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      startDayOfWeek: startDayOfWeek ?? this.startDayOfWeek,
      autoExcludeTransfer: autoExcludeTransfer ?? this.autoExcludeTransfer,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      themeMode: themeMode ?? this.themeMode,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      language: language ?? this.language,
      categories: categories ?? this.categories,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void setBudget(int budget) =>
      state = state.copyWith(monthlyBudget: budget);

  void setStartDay(String day) =>
      state = state.copyWith(startDayOfWeek: day);

  void toggleAutoExcludeTransfer(bool value) =>
      state = state.copyWith(autoExcludeTransfer: value);

  void toggleAppLock(bool value) =>
      state = state.copyWith(appLockEnabled: value);

  void setThemeMode(String mode) =>
      state = state.copyWith(themeMode: mode);

  void toggleReminder(bool value) =>
      state = state.copyWith(reminderEnabled: value);

  void setReminderTime(TimeOfDay time) =>
      state = state.copyWith(reminderTime: time);

  void setLanguage(String lang) =>
      state = state.copyWith(language: lang);

  void reorderCategories(int oldIndex, int newIndex) {
    final list = List<CategoryItem>.from(state.categories);
    if (newIndex > oldIndex) newIndex--;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = state.copyWith(categories: list);
  }

  void addCategory(CategoryItem cat) {
    state = state.copyWith(categories: [...state.categories, cat]);
  }

  void removeCategory(int index) {
    final list = List<CategoryItem>.from(state.categories)..removeAt(index);
    state = state.copyWith(categories: list);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
