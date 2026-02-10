import 'package:flutter/material.dart';
import 'package:hareru/core/constants/typography.dart';
import 'package:hareru/core/theme/app_theme.dart';

class HareruApp extends StatelessWidget {
  const HareruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hareru',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ハレル', style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              Text('Hareru', style: AppTypography.displayLarge),
              const SizedBox(height: 8),
              Text('¥156,780', style: AppTypography.displayLarge),
              const SizedBox(height: 16),
              Text('今月の支出', style: AppTypography.titleMedium),
              const SizedBox(height: 4),
              Text('本文テキスト Body Large', style: AppTypography.bodyLarge),
              const SizedBox(height: 4),
              Text('일반 본문 Body Medium', style: AppTypography.bodyMedium),
              const SizedBox(height: 4),
              Text('2025年2月10日 補助テキスト', style: AppTypography.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
