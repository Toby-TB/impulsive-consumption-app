import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:impulsive_consumption/core/providers/app_providers.dart';
import 'package:impulsive_consumption/core/providers/preferences_provider.dart';
import 'package:impulsive_consumption/data/database/database.dart';
import 'package:impulsive_consumption/data/database/seed_loader.dart';
import 'package:impulsive_consumption/data/repositories/cart_repository.dart';
import 'package:impulsive_consumption/features/checkout/checkout_screen.dart';
import 'package:impulsive_consumption/features/orders/order_detail_screen.dart';
import 'package:impulsive_consumption/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    await seedIfEmpty(db, rootBundle);
    // 预置一件已勾选购物车商品
    await CartRepository(db).add(2, qty: 1);
  });

  tearDown(() async => db.close());

  Widget harness() {
    final router = GoRouter(
      initialLocation: '/checkout',
      routes: [
        GoRoute(
          path: '/checkout',
          builder: (context, state) => const CheckoutScreen(),
        ),
        GoRoute(
          path: '/order/:id',
          builder: (context, state) => OrderDetailScreen(
            orderId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          ),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('en'),
      ),
    );
  }

  testWidgets('full pay flow: tap pay -> order created -> success overlay',
      (tester) async {
    await tester.pumpWidget(harness());
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // 结算页渲染
    expect(find.textContaining('Pay Now'), findsOneWidget);

    // 点支付
    await tester.tap(find.textContaining('Pay Now'));

    // 分段推进：扣款事务 -> 游戏化结算 -> 成功动画(3.6s) -> 跳转
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 400));
    }

    // 订单已生成
    final orders = await db.select(db.orders).get();
    expect(orders, hasLength(1));

    // 购物车已清空
    expect(await db.select(db.cartItems).get(), isEmpty);

    // 余额已扣减（¥3599，含成就/升级奖励回流）
    final wallet = await db.select(db.wallets).getSingle();
    expect(wallet.balanceCents, greaterThan(600000));

    // 冲刷订单详情页的周期性物流定时器，避免 pending-timer 断言
    await tester.pump(const Duration(seconds: 6));
    // 卸载组件树（取消周期定时器）后再冲刷一帧
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
