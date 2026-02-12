import 'package:flutter/material.dart';
import 'package:hareru/l10n/app_localizations.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Text(l10n.dictionaryTab),
      ),
    );
  }
}
