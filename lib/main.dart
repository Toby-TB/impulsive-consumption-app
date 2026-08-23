import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers/app_providers.dart';
import 'core/providers/preferences_provider.dart';
import 'data/database/database.dart';
import 'data/database/seed_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 初始化偏好存储
  final prefs = await SharedPreferences.getInstance();

  // 数据库：首启灌入种子数据
  final db = AppDatabase();
  await seedIfEmpty(db, rootBundle);

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const ImpulsiveApp(),
    ),
  );
}
