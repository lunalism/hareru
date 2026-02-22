import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/core/providers/dark_mode_provider.dart';
import 'package:hareru/core/providers/locale_provider.dart';
import 'package:hareru/core/theme/app_theme.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/screens/main_screen.dart';
import 'package:hareru/screens/onboarding_screen.dart';
import 'package:hareru/screens/splash_screen.dart';

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) {
        final tab = int.tryParse(
              state.uri.queryParameters['tab'] ?? '',
            ) ??
            0;
        return MainScreen(initialTab: tab);
      },
    ),
    // Deep link route: hareru://report -> report tab (index 1)
    GoRoute(
      path: '/report',
      redirect: (context, state) => '/main?tab=1',
    ),
  ],
);

class HareruApp extends ConsumerWidget {
  const HareruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(darkModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hareru',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
        Locale('ko'),
        Locale('en'),
      ],
      routerConfig: _router,
    );
  }
}
