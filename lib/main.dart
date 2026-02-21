import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/app.dart';
import 'package:hareru/core/services/notification_service.dart';
import 'package:hareru/core/services/widget_data_service.dart';
import 'package:hareru/models/category.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  await NotificationService.init();
  await WidgetDataService.init();

  runApp(
    const ProviderScope(
      child: HareruApp(),
    ),
  );
}
