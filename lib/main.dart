import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/app.dart';
import 'package:hareru/core/services/hive_encryption_service.dart';
import 'package:hareru/core/services/notification_service.dart';
import 'package:hareru/core/services/revenue_cat_service.dart';
import 'package:hareru/core/services/widget_data_service.dart';
import 'package:hareru/core/supabase/supabase_config.dart';
import 'package:hareru/models/category.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  await HiveEncryptionService.init();
  await NotificationService.init();
  await WidgetDataService.init();
  await RevenueCatService.init();

  runApp(
    const ProviderScope(
      child: HareruApp(),
    ),
  );
}

final supabase = Supabase.instance.client;
