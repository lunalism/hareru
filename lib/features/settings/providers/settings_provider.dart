import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../shared/services/firestore_service.dart';

class CategoryItem {
  const CategoryItem({
    required this.emoji,
    required this.name,
    this.localeKey,
    this.isDefault = false,
  });
  final String emoji;
  final String name;
  final String? localeKey;
  final bool isDefault;

  String getDisplayName(BuildContext context) {
    if (isDefault && localeKey != null) {
      final l10n = AppLocalizations.of(context)!;
      switch (localeKey) {
        case 'food':
          return l10n.categoryFood;
        case 'transport':
          return l10n.categoryTransport;
        case 'shopping':
          return l10n.categoryShopping;
        case 'cafe':
          return l10n.categoryCafe;
        case 'entertainment':
          return l10n.categoryEntertainment;
        case 'medical':
          return l10n.categoryMedical;
        case 'transfer':
          return l10n.categoryTransfer;
        case 'other':
          return l10n.categoryOther;
        case 'salary':
          return l10n.categorySalary;
        case 'allowance':
          return l10n.categoryAllowance;
        case 'sidejob':
          return l10n.categorySidejob;
        case 'investment':
          return l10n.categoryInvestment;
      }
    }
    return name;
  }

  CategoryItem copyWith({String? emoji, String? name}) =>
      CategoryItem(
        emoji: emoji ?? this.emoji,
        name: name ?? this.name,
        localeKey: localeKey,
        isDefault: isDefault,
      );
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
    this.language = '시스템',
    this.categories = _defaultCategories,
    this.subscriptionTier = 'free',
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
  final String subscriptionTier;

  static const _defaultCategories = [
    CategoryItem(emoji: '🍱', name: '식비', localeKey: 'food', isDefault: true),
    CategoryItem(emoji: '🚃', name: '교통', localeKey: 'transport', isDefault: true),
    CategoryItem(emoji: '🛒', name: '쇼핑', localeKey: 'shopping', isDefault: true),
    CategoryItem(emoji: '☕', name: '카페', localeKey: 'cafe', isDefault: true),
    CategoryItem(emoji: '🎮', name: '여가', localeKey: 'entertainment', isDefault: true),
    CategoryItem(emoji: '💊', name: '의료', localeKey: 'medical', isDefault: true),
    CategoryItem(emoji: '💳', name: '이체', localeKey: 'transfer', isDefault: true),
    CategoryItem(emoji: '📎', name: '기타', localeKey: 'other', isDefault: true),
  ];

  ThemeMode get flutterThemeMode {
    switch (themeMode) {
      case '라이트':
        return ThemeMode.light;
      case '다크':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Locale? get flutterLocale {
    switch (language) {
      case '한국어':
        return const Locale('ko');
      case '日本語':
        return const Locale('ja');
      case 'English':
        return const Locale('en');
      default:
        return null; // system locale
    }
  }

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
    String? subscriptionTier,
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
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    final box = Hive.box('settings');
    return SettingsState(
      monthlyBudget: box.get('monthlyBudget', defaultValue: 200000),
      startDayOfWeek: box.get('startDayOfWeek', defaultValue: '월요일'),
      autoExcludeTransfer: box.get('autoExcludeTransfer', defaultValue: true),
      appLockEnabled: box.get('appLockEnabled', defaultValue: false),
      themeMode: box.get('themeMode', defaultValue: '시스템'),
      reminderEnabled: box.get('reminderEnabled', defaultValue: false),
      reminderTime: TimeOfDay(
        hour: box.get('reminderHour', defaultValue: 21),
        minute: box.get('reminderMinute', defaultValue: 0),
      ),
      language: box.get('language', defaultValue: '시스템'),
      subscriptionTier: box.get('subscriptionTier', defaultValue: 'free'),
    );
  }

  Box get _box => Hive.box('settings');

  void _syncToFirestore(Map<String, dynamic> data) {
    if (FirebaseAuth.instance.currentUser == null) return;
    ref.read(firestoreServiceProvider).saveSettings(data);
  }

  void setBudget(int budget) {
    state = state.copyWith(monthlyBudget: budget);
    _box.put('monthlyBudget', budget);
    _syncToFirestore({'monthlyBudget': budget});
  }

  void setStartDay(String day) {
    state = state.copyWith(startDayOfWeek: day);
    _box.put('startDayOfWeek', day);
    _syncToFirestore({'startDayOfWeek': day});
  }

  void toggleAutoExcludeTransfer(bool value) {
    state = state.copyWith(autoExcludeTransfer: value);
    _box.put('autoExcludeTransfer', value);
    _syncToFirestore({'autoExcludeTransfer': value});
  }

  void toggleAppLock(bool value) {
    state = state.copyWith(appLockEnabled: value);
    _box.put('appLockEnabled', value);
    _syncToFirestore({'appLockEnabled': value});
  }

  void setThemeMode(String mode) {
    state = state.copyWith(themeMode: mode);
    _box.put('themeMode', mode);
    _syncToFirestore({'themeMode': mode});
  }

  void toggleReminder(bool value) {
    state = state.copyWith(reminderEnabled: value);
    _box.put('reminderEnabled', value);
    _syncToFirestore({'reminderEnabled': value});
  }

  void setReminderTime(TimeOfDay time) {
    state = state.copyWith(reminderTime: time);
    _box.put('reminderHour', time.hour);
    _box.put('reminderMinute', time.minute);
    _syncToFirestore({'reminderHour': time.hour, 'reminderMinute': time.minute});
  }

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
    _box.put('language', lang);
    _syncToFirestore({'language': lang});
  }

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
