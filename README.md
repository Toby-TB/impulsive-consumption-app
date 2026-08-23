# 冲动消费 · Impulsive Consumption

一款**纯本地**的模拟购物 App —— 完整还原「逛 → 加购 → 支付 → 物流 → 订单」的网购闭环，
不涉及任何真实支付与网络请求，所有数据仅保存在设备本地。

> A purely local mock shopping app. No real payments, no network requests — all data stays on your device.

## 功能 Features

| 模块 | 说明 |
|---|---|
| 🛍️ 商品浏览 | 首页轮播 / 12 分类金刚区 / 限时秒杀（倒计时）/ 猜你喜欢瀑布流 |
| 🔍 搜索 | 300ms 防抖、三语+标签全文匹配、销量/价格排序 |
| 📄 商品详情 | 大图 Hero、划线价与折扣、标签、库存销量评分、收藏 |
| 🛒 购物车 | 勾选结算、数量步进（库存钳制）、滑删、全选、清空 |
| 💰 钱包 | 初始 ¥10,000、模拟充值（三币种档位）、余额流水明细 |
| 🎫 优惠券 | 满300减30 / 满100打95折 / 满1000减120，自动带出最优券 |
| 💳 结算支付 | 余额校验 → 不足引导充值 → 支付成功自绘动画（对勾描边+粒子） |
| 📦 订单中心 | 状态筛选、明细快照、**物流时间轴实时推演**（发货→运输→派送→签收）、再次购买 |
| ❤️ 心愿单 | 收藏/取消、一键加购 |
| ✅ 每日签到 | 连签 7 天递增奖励（¥1→¥5 循环），直接入余额 |
| 🌍 三语三币 | English / 繁體中文 / 简体中文；CNY ¥ / USD $ / HKD HK$ 随地区切换（模拟固定汇率，展示层换算） |
| 🌓 深色模式 | 跟随系统 + 手动切换 |

## 技术栈 Tech Stack

- **Flutter 3.47 stable** · Dart 3.13（Windows / macOS / Android / iOS）
- **drift (SQLite)** 持久化 —— 订单/明细/钱包流水等关系型建模，金额一律整数分（CNY 基准）
- **Riverpod 3** 状态管理 · **go_router** 声明式路由（五 Tab StatefulShellRoute）
- **flutter gen-l10n** 三语国际化（UI 与商品数据全量三语）
- 真实商品照片 152 张（Wikimedia Commons 可商用图源，随包分发，约 8.6MB）

## 运行 Run

```bash
flutter pub get
flutter run -d windows   # 或 macos / android / ios
```

## 测试 Test

```bash
flutter test          # 41 项单测/组件测试
flutter analyze       # 零告警
```

## 结构 Structure

```
lib/
├── core/          # 主题/路由/偏好/金额汇率/通用组件
├── data/          # drift 表定义、仓库层、结算服务、物流推演、种子数据
├── features/      # home/catalog/cart/checkout/orders/wallet/wishlist/profile/settings
└── l10n/          # en · zh · zh_Hant arb 文案
```

## 免责声明 Disclaimer

本应用为纯本地模拟购物体验，商品与品牌均为虚构，不涉及任何真实交易与网络请求。
This app is a local simulation for UX demonstration only. All products and brands are fictional.
