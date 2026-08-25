import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/juice/juice_fx.dart';
import 'core/providers/app_providers.dart';
import 'core/providers/preferences_provider.dart';
import 'data/database/database.dart';
import 'data/database/seed_loader.dart';

Future<void> main() {
  final result = runZonedGuarded<Future<void>>(
    _bootstrap,
    (error, stack) {
      developer.log('Uncaught startup error: $error', error: error, stackTrace: stack);
      // 启动期任何未捕获错误直接渲染到屏幕，避免静默白屏
      WidgetsFlutterBinding.ensureInitialized();
      runApp(_ErrorScreen(error: error, stack: stack));
    },
  );
  return result ?? Future<void>.value();
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // GitHub Pages 子路径托管：必须用 hash 路由，否则刷新/直达 404 → 白屏
    setUrlStrategy(const HashUrlStrategy());
  } else {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  unawaited(JuiceFX.warmUp());

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

/// 启动错误可视化页（白屏排查用）。
class _ErrorScreen extends StatelessWidget {
  final Object error;
  final StackTrace stack;

  const _ErrorScreen({required this.error, required this.stack});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFF3F0),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: SelectableText(
                '启动失败 / Startup error\n\n$error\n\n$stack',
                style: const TextStyle(
                    fontSize: 12, fontFamily: 'monospace', height: 1.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
