import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/core/theme/app_theme.dart';
import 'package:hareru/screens/splash_screen.dart';

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Home'),
        ),
      ),
    ),
  ],
);

class HareruApp extends StatelessWidget {
  const HareruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hareru',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}
