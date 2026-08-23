# 冲动消费 Impulsive Consumption 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 构建纯本地四端（Win/macOS/Android/iOS）模拟购物 App，完整覆盖 浏览→购物车→支付→订单→物流→签到 的购物闭环。

**Architecture:** feature-first 分层；drift(SQLite) 持久化 + Riverpod3(codegen) 状态管理 + go_router 声明式路由；金额统一 CNY 分整数记账，币种为展示层换算；三语 l10n 覆盖 UI 与商品数据。

**Tech Stack:** Flutter 3.47 · drift/drift_flutter/sqlite3_flutter_libs · flutter_riverpod3/riverpod_annotation/generator/lint · go_router · intl/gen-l10n · shared_preferences · flutter_staggered_grid_view

**Spec:** `docs/superpowers/specs/2026-08-23-impulsive-consumption-design.md`

## Global Constraints

- 运行时零网络请求；所有资源随包分发（assets）
- 金额一律 `int` CNY 分；汇率常量：USD=7.20, HKD=0.926（1 外币兑 CNY）
- 初始钱包余额 1,000,000 分（=¥10,000）
- 三语键集：en / zh / zh_Hant；UI 禁止硬编码文案；商品数据字段全三语
- 物流时间轴阈值（自 paidAt）：发货运输 60s / 派送 180s / 签收 360s
- 签到奖励：day1..7 = [100,150,200,250,300,400,500] 分循环，streak 断签归零重计
- `flutter analyze` 零 issue 为完成标准；每个 Task 结束必须 `git commit`
- 提交信息 conventional commits（feat/test/docs/chore…）

---

### Task 1: 依赖与 l10n 脚手架

**Files:** Modify `pubspec.yaml`; Create `l10n.yaml`, `lib/l10n/app_en.arb`, `app_zh.arb`, `app_zh_Hant.arb`, `lib/core/utils/money.dart`(占位下一任务实现)

- [x] Step 1 pubspec 添加依赖并 `flutter pub get`：
  deps: `flutter_riverpod riverpod_annotation drift drift_flutter sqlite3_flutter_libs go_router shared_preferences intl flutter_localizations(sdk) flutter_staggered_grid_view`
  dev: `build_runner drift_dev riverpod_generator riverpod_lint custom_lint flutter_lints`
- [x] Step 2 `l10n.yaml`: arb-dir lib/l10n, template app_en.arb, output-localization-file app_localizations.dart
- [x] Step 3 三个 arb 先放 `appTitle` 键验证管线；pubspec 加 `generate: true` 与 assets 声明占位
- [x] Step 4 验证 `flutter gen-l10n` 通过；Commit `chore: 依赖与l10n脚手架`

### Task 2: 金额与汇率工具（TDD）

**Files:** Create `lib/core/utils/money.dart`; Test `test/money_test.dart`

**Interfaces (Produces):**
```dart
enum FxCurrency { cny, usd, hkd } // cnyToCny=1, usd=1/7.20≈0.138888..., hkd=1/0.926
extension FxCurrencyX on FxCurrency {
  double get rateFromCny;            // 展示换算：displayCents = baseCents * rate
  String get symbol;                 // ¥ / $ / HK$
}
String formatMoney(int baseCents, {required FxCurrency cur, required Locale locale}); 
// 规则：CNY/HKD 两位小数；USD 两位小数；符号前置(HK$)；用 intl NumberFormat.currency
int parsePresetToBaseCents(double amount, FxCurrency cur); // 充值档位折基准分: (amount/rate*100).round()
```

- [x] Step 1 失败测试：¥12345分→"¥123.45"；100000分 USD→"$1,388.89"；HKD→"HK$10,800.00"(取整核对)；parsePreset(100, usd)=72000分? 否——100美元=100*7.2*100=72000分 ✓；边界 0/负数抛 ArgumentError
- [x] Step 2 跑测试确认编译失败 → 实现 → 全绿 → Commit `feat: 金额汇率工具`

### Task 3: 商品数据管线（调研→JSON→图片资产）

**Files:** Create `tool/build_product_data.md`(调研笔记), `assets/data/products.json`, `assets/images/products/p001.jpg…p160.jpg`, `tool/fetch_images.sh`; Modify `pubspec.yaml`(assets)

**JSON Schema（最终版，逐字段固定）：**
```json
{ "categories": [ {"id":1,"slug":"digital","emoji":"📱","sortOrder":1,
    "name":{"en":"Digital","zhHans":"数码家电","zhHant":"數碼家電"}} ],
  "products": [ {"id":1,"categoryId":1,"brand":"Nebula","model":"X5 Pro",
    "name":{"en":"Nebula X5 Pro Smartphone 512GB","zhHans":"星尘 X5 Pro 旗舰手机 512GB","zhHant":"星塵 X5 Pro 旗艦手機 512GB"},
    "subtitle":{...三语}, "description":{...三语},
    "priceCents":459900,"originalPriceCents":529900,"stock":328,"sales":15234,
    "rating":4.8,"tags":["flagship","5g"],"flashSale":true,
    "image":"assets/images/products/p001.jpg"} ] }
```

- [ ] Step 1 websearch 调研 2026 各品类热销品形态（手机/电脑/耳机/家电/服饰/美妆/食品/家居/运动/母婴/图书/宠物），记录典型价格带
- [ ] Step 2 编写 12 分类 + 约 160 商品的三语 JSON（虚构品牌，价格贴近真实带，销量/评分分布拟真，≥16 件 flashSale）
- [ ] Step 3 `tool/fetch_images.sh`：按品类从 Unsplash/Pexels 可商用图源抓取真实商品照，CDN 参数直出 640×640 q70 JPEG（`?w=640&h=640&fit=crop&q=70&fm=jpg`），curl 循环下载至 p{id}.jpg，校验每张 >3KB 且为 JPEG，失败重试并回退同品类备用图
- [ ] Step 4 pubspec 注册 assets；抽样目检 10 张图与品类匹配度
- [ ] Commit `feat: 三语商品数据与本地图片资产`

### Task 4: drift 数据库层 + 种子导入（TDD）

**Files:** Create `lib/data/database/tables.dart`, `database.dart`, `converters/localized_text.dart`, `seed/seed_loader.dart`; Test `test/database_test.dart`

**Interfaces (Produces):**
```dart
class LocalizedText { final String en, zhHans, zhHant; String of(Locale l); factory fromJson(Map) }
// 表：Categories,Products,CartItems(productIdx唯一,quantity,selected),
// Wallet(id==1,balanceCents,totalRechargeCents,totalSpentCents),
// WalletTransactions(type枚举recharge/spend/refund/checkin,amountCents可负,balanceAfterCents,refText,createdAt),
// Orders(orderNo,status枚举pendingShip/shipping/delivering/completed,totalAmountCents,discountCents,payableCents,couponId可空,createdAt,paidAt),
// OrderItems(orderId,productId,quantity,unitPriceSnapshotCents),
// Coupons(titleKey,fixedOffCents?,ratePercent?,minSpendCents,expiresAt,statusEnum available/used/expired),
// WishlistItems(productId唯一,createdAt), Checkins(dateKey唯一,rewardCents,streak)
@DriftDatabase(tables:[...]) class AppDatabase { AppDatabase(); AppDatabase.forTesting(QueryExecutor e); }
Future<void> seedIfEmpty(AppDatabase db, AssetBundle bundle);
// 种子：products.json 全量 + 钱包1行(1000000) + 优惠券3张(fixed 满300减30 / rate 95% 满100 / fixed 满1000减120，有效期首启+30天)
```

- [ ] Step 1 build_runner 生成；内存库测试：seedIfEmpty 幂等（二次调用不重复插入）；唯一约束冲突抛错；Commit `feat: drift库表与种子导入`

### Task 5: 仓库层 + 结算服务 + 物流推演（TDD）

**Files:** Create `lib/data/repositories/{product,cart,wallet,coupon,order,wishlist,checkin}_repository.dart`, `lib/data/services/checkout_service.dart`, `lib/data/services/logistics_calculator.dart`, `lib/core/providers/database_provider.dart`; Test `test/repositories_test.dart`, `test/checkout_test.dart`, `test/logistics_test.dart`

**Interfaces (Produces):**
```dart
// Riverpod providers（codegen @riverpod）：appDatabase, productRepository, cartRepository, walletRepository...
class ProductRepository { Stream watchHomeFeed(); watchByCategory(int); search(String q,{SortMode}); Stream<Product?> byId(int) }
class CartRepository { Stream<List<CartItemWithProduct>> watchDetailed(); Future add(int productId,int qty); setQty; toggleSelect; selectAll(bool); removeItem; removeSelected; Stream<int> watchCount(); Future<int> selectedTotalCents() }
class WalletRepository { Stream<Wallet> watchAccount(); Future recharge(int cents,String ref); Future spend(int cents,String ref); // 不足抛 InsufficientBalanceException
  Stream<List<WalletTransaction>> watchTransactions(); }
class CouponRepository { Stream<List<Coupon>> watchAvailable(); Coupon? bestFor(int totalCents,DateTime now); Future markUsed(int id); }
class CheckoutService { Future<int> checkout({required List<CartItemWithProduct> items, int? couponId});
  // 单事务：算总额→券门槛校验→spend扣款写流水→orders/order_items落库(快照单价)→删已购cart项→返回orderId }
class OrderRepository { Stream<List<OrderWithItems>> watchOrders(); Future<OrderWithItems?> byId(int); Future buyAgain(int orderId); Future advanceStatuses(); }
class LogisticsCalculator { static List<LogisticsStep> timeline(DateTime paidAt); static OrderStatus statusAt(DateTime paidAt, DateTime now); } // 纯函数
class CheckinRepository { Future<bool> isCheckedToday(); Future<int> checkIn(); /*返回奖励分*/ Stream<CheckinState> watchState(); }
```

测试断言要点：加购合并数量；结算后余额=旧额-实付、流水两条对账平；券未达门槛被拒；最优券自动选最大优惠；物流 0s=pendingShip/61s=shipping/181s=delivering/361s=completed；连签第7天奖励500且第8天回落100；buyAgain 合并不重复。
- [ ] 全绿后 Commit `feat: 仓库层/结算事务/物流推演(含单测)`

### Task 6: 主题 / 路由 / 设置偏好

**Files:** Create `lib/core/theme/app_theme.dart`, `lib/core/router/app_router.dart`, `lib/core/providers/preferences_provider.dart`; Modify `lib/main.dart`,`lib/app.dart`

**Interfaces (Produces):** `themeModeProvider(SystemMode/light/dark)`, `localeProvider(en/zh/zhHant 默认跟随系统)`, `regionProvider(cn/us/hk)` —— 均持久化 shared_preferences；路由：ShellRoute 五分支 `/home /category /cart /orders /profile` + `/product/:id /checkout /order/:id /wallet /wishlist /settings`；`MoneyText` 通用组件读取 regionProvider 自动换算显示。
- [ ] 手动冒烟：底部五 tab 导航、主题即时切换；Commit `feat: 主题路由与偏好体系`

### Task 7: 商品浏览 UI

**Files:** Create `lib/features/home/{home_screen,banner_carousel,flash_sale_row}.dart`, `catalog/{category_screen,search_screen,product_detail_screen,widgets/product_card}.dart` 及对应 `*_providers.dart`

- [ ] 首页：搜索栏入口(跳搜索页)、自动轮播 Banner(PageView+Timer, 用分类色渐变+文案卡)、金刚区 12 分类、限时秒杀横滑(倒计时到当日 24 点)、猜你喜欢瀑布流(staggered, 上拉加载更多=重复数据追加)
- [ ] 分类页：左侧竖排分类 rail + 右侧 Grid，切换动画
- [ ] 搜索页：防抖 300ms、排序 chips(综合/销量/价格↑↓)、空态插画
- [ ] 详情页：大图 Hero、价格区(现价+划线价+销量/评分)、标签 chips、描述展开、底部栏(心愿❤切换/加入购物车/立即购买)，加购成功 SnackBar+角标跳动
- [ ] Widget 测试：详情页渲染、加购后角标计数变化；Commit `feat: 商品浏览全链路UI`

### Task 8: 购物车 UI

**Files:** Create `lib/features/cart/cart_screen.dart`, `cart_providers.dart`

- [ ] 列表项：缩略图/名称(当前语言)/单价(MoneyText)/步进器改量/滑删/勾选框；底栏：全选、合计(仅勾选件)、去结算按钮(无勾选禁用)、清空入口(确认弹窗)；库存上限钳制步进器
- [ ] Widget 测试：改量合计联动、删除项消失；Commit `feat: 购物车UI`

### Task 9: 钱包 UI

**Files:** Create `lib/features/wallet/{wallet_screen,recharge_sheet,transaction_list,wallet_providers}.dart`

- [ ] 余额卡(当前币种展示+累充累支小字)、充值 BottomSheet(按地区三档预设+自定义输入，确认后折基准分入账)、流水列表(类型图标±色、金额、余额快照、时间分组)；复用组件 `InsufficientBalanceDialog`（去充值按钮）
- [ ] Widget 测试：充值后余额更新；Commit `feat: 钱包与充值`

### Task 10: 结算支付 UI + 成功动画

**Files:** Create `lib/features/checkout/{checkout_screen,coupon_picker_sheet,checkout_providers,payment_success_overlay}.dart`

- [ ] 页面：模拟收货地址卡、商品清单摘要、优惠券行(点击开 Sheet：可用/不可用分区，默认选最优)、金额明细三行(总价/优惠/实付)、支付按钮(余额不足时弹引导充值)
- [ ] `PaymentSuccessOverlay`：OverlayEntry + AnimationController，CustomPainter 对勾描边(Tween<Path>) + 圆环扩散 + 20 粒子随机迸发，1.6s 后导航订单详情
- [ ] Widget/集成测试：走通 加购→结算(mock 余额充足)→订单生成+购物车清空+余额减少；Commit `feat: 结算支付与成功动画`

### Task 11: 订单中心 UI

**Files:** Create `lib/features/orders/{orders_screen,order_detail_screen,order_providers,widgets/logistics_timeline}.dart`

- [ ] 列表：状态 Tab(全部/待发货/运输中/派送中/签收)、卡片含状态chip+商品行预览+实付；详情：`LogisticsTimeline`(基于 paidAt 实时推演，Timer.periodic 5s 刷新，步骤打点渐亮动画)、金额明细、所用券、再次购买按钮(buyAgain 后跳购物车)
- [ ] 测试：timeline 渲染节点随时间推进；Commit `feat: 订单中心与物流模拟`

### Task 12: 心愿单 / 我的 / 签到 / 设置

**Files:** Create `lib/features/wishlist/wishlist_screen.dart`, `lib/features/profile/{profile_screen,checkin_card,checkin_sheet}.dart`, `lib/features/settings/settings_screen.dart`

- [ ] 我的页：头像卡(昵称“冲冲”)+余额快捷条+签到七日条(今日高亮/已领灰勾，点击弹领取动画 Sheet)+菜单(我的订单/钱包/心愿单/设置/关于)；设置页三组单选：语言/地区币种/深色模式，改动即存即生效；关于页含免责声明“本应用为纯本地模拟，不涉及真实交易”
- [ ] 测试：签到后按钮置灰+余额+当日奖励；语言切换后关键文案变化；Commit `feat: 心愿单/我的/签到/设置`

### Task 13: 收尾验收

- [ ] `flutter analyze` 修复至零 issue
- [ ] `flutter test` 全绿
- [ ] `flutter build windows --debug`(或 linux 下可用的目标构建) 验证打包通过
- [ ] README.md：功能清单/技术栈/运行方式/截图位/免责声明
- [ ] 最终 Commit `chore: 收尾验收` 并汇总交付说明
