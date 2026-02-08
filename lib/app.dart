import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/home_screen.dart';
import 'features/input/input_screen.dart';
import 'features/input/pages/receipt_scan_page.dart';
import 'features/input/pages/scan_result_screen.dart';
import 'features/input/widgets/input_method_sheet.dart';
import 'features/report/presentation/report_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/splash/splash_screen.dart';
import 'shared/widgets/bottom_nav_bar.dart';

/// Listenable that fires when Firebase auth state changes,
/// so GoRouter re-evaluates its redirect.
class _AuthNotifier extends ChangeNotifier {
  late final StreamSubscription<User?> _sub;

  _AuthNotifier() {
    _sub = FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthNotifier();
  ref.onDispose(() => authNotifier.dispose());

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final location = state.uri.path;
      // Don't redirect while on splash
      if (location == '/splash') return null;

      final box = Hive.box('settings');
      final hasSeenLogin = box.get('hasSeenLogin', defaultValue: false) as bool;

      // If user hasn't seen login and is not on login screen → go to login
      if (!hasSeenLogin && location != '/login') {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => _ScaffoldWithNav(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/report',
            builder: (context, state) => const ReportScreen(),
          ),
          GoRoute(
            path: '/input',
            builder: (context, state) =>
                const _PlaceholderScreen(key: ValueKey('input')),
          ),
          GoRoute(
            path: '/dictionary',
            builder: (context, state) =>
                const _PlaceholderScreen(key: ValueKey('dictionary')),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      // Routes outside ShellRoute (no bottom nav)
      GoRoute(
        path: '/input/manual',
        builder: (context, state) => const InputScreen(),
      ),
      GoRoute(
        path: '/input/receipt',
        builder: (context, state) => const ReceiptScanPage(),
      ),
      GoRoute(
        path: '/input/receipt/result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ScanResultScreen(
            imagePath: extra['imagePath'] as String,
            amount: extra['amount'] as int?,
            storeName: extra['storeName'] as String?,
            date: extra['date'] as String?,
            rawText: extra['rawText'] as String,
            confidence: extra['confidence'] as double,
            suggestedCategoryKey: extra['suggestedCategoryKey'] as String?,
            suggestedCategoryEmoji: extra['suggestedCategoryEmoji'] as String?,
            categoryConfidence: (extra['categoryConfidence'] as num?)?.toDouble() ?? 0.0,
            categoryMatchReason: extra['categoryMatchReason'] as String?,
          );
        },
      ),
    ],
  );
});

class HareruApp extends ConsumerWidget {
  const HareruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Hareru',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.flutterThemeMode,
      locale: settings.flutterLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'),
        Locale('ja'),
        Locale('en'),
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _ScaffoldWithNav extends StatelessWidget {
  const _ScaffoldWithNav({required this.child});

  final Widget child;

  static const _paths = ['/', '/report', '/input', '/dictionary', '/settings'];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _paths.indexOf(location).clamp(0, 4);

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            // "+" button: show input method bottom sheet
            InputMethodSheet.show(context);
          } else {
            context.go(_paths[index]);
          }
        },
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({super.key});

  String _getTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final key = (this.key as ValueKey).value as String;
    switch (key) {
      case 'report':
        return l10n.report;
      case 'input':
        return l10n.input;
      case 'dictionary':
        return l10n.dictionary;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _getTitle(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(title),
      ),
      body: Center(child: Text(title)),
    );
  }
}
