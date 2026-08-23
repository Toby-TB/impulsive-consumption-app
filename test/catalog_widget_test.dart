import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/core/providers/app_providers.dart';
import 'package:impulsive_consumption/core/providers/preferences_provider.dart';
import 'package:impulsive_consumption/data/database/database.dart';
import 'package:impulsive_consumption/data/database/seed_loader.dart';
import 'package:impulsive_consumption/features/catalog/screens/product_detail_screen.dart';
import 'package:impulsive_consumption/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    await seedIfEmpty(db, rootBundle);
  });

  tearDown(() async => db.close());

  Future<Widget> wrap(Widget child) async {
    final prefs = await SharedPreferences.getInstance();
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('en'),
        home: child,
      ),
    );
  }

  testWidgets('detail renders product info', (tester) async {
    await tester.pumpWidget(await wrap(const ProductDetailScreen(productId: 1)));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // 英文默认语言下商品名可见
    expect(find.textContaining('X5 Pro'), findsWidgets);

    // 价格与描述区渲染
    expect(find.textContaining('Description'), findsOneWidget);
    expect(find.textContaining('¥'), findsWidgets);

    // 在测试体内先卸载 widget 树：drift 在流取消时会调度 0ms 定时器，
    // 若留到框架 teardown 阶段会触发 pending-timer 断言
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
