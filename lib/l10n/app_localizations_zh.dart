// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '冲动消费';

  @override
  String get navHome => '首页';

  @override
  String get navCategory => '分类';

  @override
  String get navCart => '购物车';

  @override
  String get navOrders => '订单';

  @override
  String get navProfile => '我的';

  @override
  String get searchHint => '搜索商品';

  @override
  String get flashSale => '限时秒杀';

  @override
  String get guessYouLike => '猜你喜欢';

  @override
  String soldCount(int count) {
    return '已售 $count';
  }

  @override
  String stockLeft(int count) {
    return '库存 $count';
  }

  @override
  String onlyLeft(int count) {
    return '仅剩 $count 件';
  }

  @override
  String get addToCart => '加入购物车';

  @override
  String get buyNow => '立即购买';

  @override
  String get addedToCart => '已加入购物车';

  @override
  String get productDescription => '商品描述';

  @override
  String get emptyResult => '没有找到相关商品';

  @override
  String get cartEmptyTitle => '购物车空空如也';

  @override
  String get cartEmptySubtitle => '去逛逛，种草一番～';

  @override
  String get goShopping => '去逛逛';

  @override
  String get selectAll => '全选';

  @override
  String get total => '合计';

  @override
  String checkoutWithCount(int count) {
    return '去结算 ($count)';
  }

  @override
  String get clearCart => '清空购物车';

  @override
  String get clearCartConfirm => '确定要清空购物车吗？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get delete => '删除';

  @override
  String get itemRemoved => '已删除';

  @override
  String get cleared => '购物车已清空';

  @override
  String maxPerItem(int count) {
    return '最多 $count';
  }

  @override
  String get walletTitle => '我的钱包';

  @override
  String get balance => '余额';

  @override
  String get totalRecharged => '累计充值';

  @override
  String get totalSpent => '累计消费';

  @override
  String get recharge => '充值';

  @override
  String get customAmount => '自定义金额';

  @override
  String get rechargeSuccess => '充值成功';

  @override
  String get transactions => '余额明细';

  @override
  String get txRecharge => '充值';

  @override
  String get txSpend => '消费';

  @override
  String get txCheckin => '签到奖励';

  @override
  String txBalanceAfter(String amount) {
    return '结余 $amount';
  }

  @override
  String get insufficientTitle => '余额不足';

  @override
  String insufficientMsg(String balance, String missing) {
    return '当前余额 $balance，还差 $missing，快去充值吧！';
  }

  @override
  String get goRecharge => '去充值';

  @override
  String get paymentSuccess => '支付成功！';

  @override
  String get payNow => '立即支付';

  @override
  String get checkoutTitle => '确认订单';

  @override
  String get recipientLabel => '收货人';

  @override
  String get recipientName => '冲冲';

  @override
  String get addressPhone => '138****8888';

  @override
  String get addressDetail => '幸福小区 2 栋 888 室（示例路 1 号）';

  @override
  String get coupon => '优惠券';

  @override
  String get noCoupon => '不使用优惠券';

  @override
  String get couponAvailable => '可用优惠券';

  @override
  String get couponUnavailable => '不可用';

  @override
  String couponThreshold(String amount) {
    return '满 $amount 可用';
  }

  @override
  String savedAmount(String amount) {
    return '已优惠 $amount';
  }

  @override
  String get itemsTotal => '商品总额';

  @override
  String get discount => '优惠';

  @override
  String get payable => '实付款';

  @override
  String get ordersTitle => '我的订单';

  @override
  String get statusAll => '全部';

  @override
  String get orderStatusPendingShip => '待发货';

  @override
  String get orderStatusShipping => '运输中';

  @override
  String get orderStatusDelivering => '派送中';

  @override
  String get orderStatusCompleted => '已签收';

  @override
  String get orderNoLabel => '订单号';

  @override
  String get buyAgain => '再次购买';

  @override
  String get logistics => '物流信息';

  @override
  String get stepPlaced => '订单已提交';

  @override
  String get stepShipped => '商家已发货';

  @override
  String get stepTransit => '包裹运输中';

  @override
  String get stepDeliver => '快递员派送中';

  @override
  String get stepSigned => '已签收';

  @override
  String get orderEmptyTitle => '暂无相关订单';

  @override
  String get orderEmptyAction => '去下一单';

  @override
  String get wishlistTitle => '心愿单';

  @override
  String get wishlistEmpty => '心愿单还是空的';

  @override
  String get checkin => '每日签到';

  @override
  String get checkinNow => '签到';

  @override
  String get checkedToday => '今日已签到';

  @override
  String checkinDay(int n) {
    return '第$n天';
  }

  @override
  String streakDays(int count) {
    return '连签 $count 天';
  }

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get regionCurrency => '地区与货币';

  @override
  String get themeMode => '深色模式';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get about => '关于';

  @override
  String get aboutDisclaimer => '本应用为纯本地模拟购物体验，不涉及任何真实交易与网络请求，所有数据仅保存在你的设备上。';

  @override
  String get versionLabel => '版本';

  @override
  String get sortBest => '综合';

  @override
  String get sortSales => '销量';

  @override
  String get sortPriceAsc => '价格从低到高';

  @override
  String get sortPriceDesc => '价格从高到低';

  @override
  String get banner1Title => '今天，你冲动了吗？';

  @override
  String get banner1Sub => '万件好物低至5折';

  @override
  String get banner2Title => '新人专享礼包';

  @override
  String get banner2Sub => '大额优惠券等你领';

  @override
  String get banner3Title => '全城闪送';

  @override
  String get banner3Sub => '最快 6 分钟“签收”到家';

  @override
  String get langEn => 'English';

  @override
  String get langZhHant => '繁體中文';

  @override
  String get langZhHans => '简体中文';

  @override
  String get regionCN => '中国大陆 · CNY ¥';

  @override
  String get regionUS => '美国 · USD \$';

  @override
  String get regionHK => '中国香港 · HKD HK\$';

  @override
  String get couponNewcomer => '新人专享券';

  @override
  String get couponOff30Over300 => '满300减30';

  @override
  String get couponOff120Over1000 => '满1000减120';

  @override
  String get coupon95 => '满100打95折';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '衝動消費';

  @override
  String get navHome => '首頁';

  @override
  String get navCategory => '分類';

  @override
  String get navCart => '購物車';

  @override
  String get navOrders => '訂單';

  @override
  String get navProfile => '我的';

  @override
  String get searchHint => '搜尋商品';

  @override
  String get flashSale => '限時秒殺';

  @override
  String get guessYouLike => '猜你喜歡';

  @override
  String soldCount(int count) {
    return '已售 $count';
  }

  @override
  String stockLeft(int count) {
    return '庫存 $count';
  }

  @override
  String onlyLeft(int count) {
    return '僅剩 $count 件';
  }

  @override
  String get addToCart => '加入購物車';

  @override
  String get buyNow => '立即購買';

  @override
  String get addedToCart => '已加入購物車';

  @override
  String get productDescription => '商品描述';

  @override
  String get emptyResult => '沒有找到相關商品';

  @override
  String get cartEmptyTitle => '購物車空空如也';

  @override
  String get cartEmptySubtitle => '去逛逛，種草一番～';

  @override
  String get goShopping => '去逛逛';

  @override
  String get selectAll => '全選';

  @override
  String get total => '合計';

  @override
  String checkoutWithCount(int count) {
    return '去結算 ($count)';
  }

  @override
  String get clearCart => '清空購物車';

  @override
  String get clearCartConfirm => '確定要清空購物車嗎？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確定';

  @override
  String get delete => '刪除';

  @override
  String get itemRemoved => '已刪除';

  @override
  String get cleared => '購物車已清空';

  @override
  String maxPerItem(int count) {
    return '最多 $count';
  }

  @override
  String get walletTitle => '我的錢包';

  @override
  String get balance => '餘額';

  @override
  String get totalRecharged => '累計儲值';

  @override
  String get totalSpent => '累計消費';

  @override
  String get recharge => '儲值';

  @override
  String get customAmount => '自訂金額';

  @override
  String get rechargeSuccess => '儲值成功';

  @override
  String get transactions => '餘額明細';

  @override
  String get txRecharge => '儲值';

  @override
  String get txSpend => '消費';

  @override
  String get txCheckin => '簽到獎勵';

  @override
  String txBalanceAfter(String amount) {
    return '結餘 $amount';
  }

  @override
  String get insufficientTitle => '餘額不足';

  @override
  String insufficientMsg(String balance, String missing) {
    return '目前餘額 $balance，還差 $missing，快去儲值吧！';
  }

  @override
  String get goRecharge => '去儲值';

  @override
  String get paymentSuccess => '付款成功！';

  @override
  String get payNow => '立即付款';

  @override
  String get checkoutTitle => '確認訂單';

  @override
  String get recipientLabel => '收件人';

  @override
  String get recipientName => '沖沖';

  @override
  String get addressPhone => '138****8888';

  @override
  String get addressDetail => '幸福社區 2 棟 888 室（範例路 1 號）';

  @override
  String get coupon => '優惠券';

  @override
  String get noCoupon => '不使用優惠券';

  @override
  String get couponAvailable => '可用優惠券';

  @override
  String get couponUnavailable => '不可用';

  @override
  String couponThreshold(String amount) {
    return '滿 $amount 可用';
  }

  @override
  String savedAmount(String amount) {
    return '已折抵 $amount';
  }

  @override
  String get itemsTotal => '商品總額';

  @override
  String get discount => '優惠';

  @override
  String get payable => '實付款';

  @override
  String get ordersTitle => '我的訂單';

  @override
  String get statusAll => '全部';

  @override
  String get orderStatusPendingShip => '待出貨';

  @override
  String get orderStatusShipping => '運送中';

  @override
  String get orderStatusDelivering => '配送中';

  @override
  String get orderStatusCompleted => '已簽收';

  @override
  String get orderNoLabel => '訂單編號';

  @override
  String get buyAgain => '再次購買';

  @override
  String get logistics => '物流資訊';

  @override
  String get stepPlaced => '訂單已送出';

  @override
  String get stepShipped => '賣家已出貨';

  @override
  String get stepTransit => '包裹運送中';

  @override
  String get stepDeliver => '配送員派送中';

  @override
  String get stepSigned => '已簽收';

  @override
  String get orderEmptyTitle => '尚無相關訂單';

  @override
  String get orderEmptyAction => '再去逛逛';

  @override
  String get wishlistTitle => '願望清單';

  @override
  String get wishlistEmpty => '願望清單還是空的';

  @override
  String get checkin => '每日簽到';

  @override
  String get checkinNow => '簽到';

  @override
  String get checkedToday => '今日已簽到';

  @override
  String checkinDay(int n) {
    return '第$n天';
  }

  @override
  String streakDays(int count) {
    return '連續簽到 $count 天';
  }

  @override
  String get settings => '設定';

  @override
  String get language => '語言';

  @override
  String get regionCurrency => '地區與貨幣';

  @override
  String get themeMode => '深色模式';

  @override
  String get themeSystem => '跟隨系統';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get about => '關於';

  @override
  String get aboutDisclaimer => '本應用為純本機模擬購物體驗，不涉及任何真實交易與網路請求，所有資料僅保存在你的裝置上。';

  @override
  String get versionLabel => '版本';

  @override
  String get sortBest => '綜合';

  @override
  String get sortSales => '銷量';

  @override
  String get sortPriceAsc => '價格由低到高';

  @override
  String get sortPriceDesc => '價格由高到低';

  @override
  String get banner1Title => '今天，你衝動了嗎？';

  @override
  String get banner1Sub => '萬件好物低至5折';

  @override
  String get banner2Title => '新人專屬禮包';

  @override
  String get banner2Sub => '大額優惠券等你領';

  @override
  String get banner3Title => '全城閃送';

  @override
  String get banner3Sub => '最快 6 分鐘「簽收」到家';

  @override
  String get langEn => 'English';

  @override
  String get langZhHant => '繁體中文';

  @override
  String get langZhHans => '简体中文';

  @override
  String get regionCN => '中國大陸 · CNY ¥';

  @override
  String get regionUS => '美國 · USD \$';

  @override
  String get regionHK => '香港 · HKD HK\$';

  @override
  String get couponNewcomer => '新人專屬券';

  @override
  String get couponOff30Over300 => '滿300折30';

  @override
  String get couponOff120Over1000 => '滿1000折120';

  @override
  String get coupon95 => '滿100享95折';
}
