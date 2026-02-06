import 'package:flutter/material.dart';
import '../../core/constants/typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hareru'),
      ),
      body: const Center(
        child: Text(
          'Hareru',
          style: AppTypography.headlineLarge,
        ),
      ),
    );
  }
}
