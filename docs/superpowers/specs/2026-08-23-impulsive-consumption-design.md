# 「冲动消费 / Impulsive Consumption」设计文档

- 日期：2026-08-23
- 状态：已获用户批准
- 类型：全新跨平台应用（架构级）

## 1. 目标与定位

纯本地模拟购物 App，让用户体验完整"网购过程"：逛 → 加购 → 支付 → 物流 → 订单。
不涉及真实支付与网络请求（运行时零网络依赖），数据全部保存在设备本地。

| 项 | 决策 |
|---|---|
| 应用名 | 冲动消费 / Impulsive Consumption（随语言切换） |
| 项目名 | `impulsive_consumption`（org: com.tobytb） |
| 平台 | Windows / macOS / Android / iOS |
| Flutter | 3.47 stable · Dart 3.13 |
| 技术栈 | drift(SQLite) + Riverpod 3(codegen) + go_router |
| 语言 | en / zh-Hant / zh-Hans（flutter gen-l10n，三语全覆盖含商品数据） |
| 币种 | CNY ¥（基准）/ USD $ / HKD HK$，随地区切换，展示层换算 |

## 2. 货币模型

内部记账统一 **CNY 分**（整数），钱包、扣款、流水、订单金额全部以基准单位运算；
币种仅为展示层换算。模拟固定汇率：

| 地区 | 币种 | 汇率 |
|---|---|---|
| CN | CNY ¥ | 1（基准） |
| US | USD $ | 1 USD ≈ 7.20 CNY |
| HK | HKD HK$ | 1 HKD ≈ 0.926 CNY |

- 同一余额切地区按汇率重显（¥10,000 ↔ $1,388.89 ↔ HK$10,800）
- 充值快捷档位按所选币种定义，选中后折算为基准分入库
- 金额格式化用 intl 遵循各币种习惯

## 3. 多语言

- `.arb` 三套：`app_en` / `app_zh`（简）/ `app_zh_Hant`（繁），UI 禁止硬编码文案
- 商品数据三语：products.json 中名称/描述/品牌/标签/分类名均含三份
- `order_items` 保留价格/数量快照 + `productId` 外键；商品名展示时动态解析当前语言，
  切换语言后历史订单亦正确显示

## 4. 架构与项目结构

feature-first 分层：

```
lib/
├── main.dart / app.dart          # 入口、MaterialApp、主题、路由
├── core/
│   ├── theme/                    # Material 3 高饱和红橙主题，亮暗双套
│   ├── router/                   # go_router + 底部 5 Tab StatefulShellRoute
│   ├── utils/                    # 金额/时间格式化
│   └── widgets/                  # 通用组件
├── data/
│   ├── database/                 # drift 表定义 + AppDatabase + 种子导入
│   ├── repositories/             # 各实体仓库
│   └── assets/products.json      # 商品种子数据（随包分发）
└── features/
    ├── home/ catalog/            # 首页(轮播+金刚区+秒杀+瀑布流)、分类、搜索、详情
    ├── cart/ checkout/           # 购物车、结算、支付动画
    ├── orders/ wallet/           # 订单中心+物流模拟、钱包+充值+流水
    ├── wishlist/ profile/        # 心愿单、我的(签到)、设置(语言/地区/深色模式)
```

底部导航 5 Tab：首页 / 分类 / 购物车(badge) / 订单 / 我的。

## 5. 数据模型（drift 表）

- `categories`: id, slug, 名称×3语, emoji, sortOrder
- `products`: id, 名称/副标题/描述×3语, 品牌, 价格分, 原价分, categoryId, 图片路径,
  库存, 销量, 评分, 标签, isFlashSale
- `cart_items`: productId 唯一, quantity, selected(bool)
- `wallet`: 单行账户（余额分, 累充, 累支）; 初始余额 = 10000 元 = 1,000,000 分
- `wallet_transactions`: type(recharge/spend/refund/checkin), amount分(±), balanceAfter, refId, createdAt
- `orders`: 订单号, statusCode, totalAmount, discountAmount, payableAmount, couponId?, createdAt, paidAt
- `order_items`: orderId FK, productId FK, 数量, 单价快照分, （名称动态解析）
- `coupons`: title键, discountType(fixed/rate), value, minSpendCents, expiresAt, status
- `wishlist`: productId 唯一, addedAt
- `checkins`: dateKey(yyyy-MM-dd 唯一), rewardCents, streak

偏好（语言/地区币种/主题模式）存 shared_preferences。
首启检测 products 表为空 → 自动灌入种子数据 + 初始优惠券。

## 6. 关键流程

- **支付**：结算页选券（自动带出最优可用券）→ 余额校验 → 不足弹窗引导快捷充值 →
  成功播放自绘对勾+缩放动画（无第三方资源）→ 单事务原子完成
  扣款+写流水+生成订单+清除已勾选购物车项
- **物流模拟**：基于 paidAt 推演时间轴 —— 1min 商家发货/运输中 → 3min 派送中 → 6min 已签收；
  订单详情页定时刷新，无需后台任务
- **签到**：每日领 ¥1 起、连签递增第 7 天 ¥5 循环；入余额并记流水
- **搜索**：SQL LIKE 匹配名称/品牌/标签（当前语言字段），支持销量/价格排序
- **再次购买**：订单明细一键回填购物车

## 7. 商品数据与图片方案

- 规模约 **160 件 / 12 分类**，覆盖各品类热门款形态（旗舰手机、降噪耳机、空气炸锅、
  羽绒服、精华液、零食礼盒…），命名采用虚构但逼真的品牌型号规避商标风险
- 实施前经网络调研 2026 热销品形态再编写数据
- 图片：Unsplash/Pexels 等可自由商用图源按品类检索真实照片，脚本化下载后统一压至
  600×600 JPEG（包体增量约 8–15MB）；个别品类素材不足时允许同系列复用同图

## 8. 视觉

高饱和红橙渐变主色（促销冲动感），Material 3，亮暗双主题（跟随系统+手动切换），
中文/英文本地化排版适配。

## 9. 测试与验收

- drift 内存库单元测试：购物车合计、结算事务原子性、余额校验、优惠券门槛与最优选择、
  物流推进函数、签到连签奖励、汇率换算格式化
- Widget 冒烟测试核心链路（加购→badge 更新→结算成功→购物车清空→订单生成）
- `flutter analyze` 零告警；Windows debug 构建验证通过

## 10. 明确不做（YAGNI）

SKU 多规格、真实网络/支付、账号系统、客服 IM、评价晒图、web/linux 平台。
