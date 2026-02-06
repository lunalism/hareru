import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'shared/widgets/bottom_nav_bar.dart';

final _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => _ScaffoldWithNav(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/report',
          builder: (context, state) => const _PlaceholderScreen(title: 'レポート'),
        ),
        GoRoute(
          path: '/input',
          builder: (context, state) => const _PlaceholderScreen(title: '入力'),
        ),
        GoRoute(
          path: '/dictionary',
          builder: (context, state) => const _PlaceholderScreen(title: '辞書'),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const _PlaceholderScreen(title: '設定'),
        ),
      ],
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
      routerConfig: _router,
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
        onTap: (index) => context.go(_paths[index]),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(title),
      ),
      body: Center(child: Text(title)),
    );
  }
}
