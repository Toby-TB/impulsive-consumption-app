// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Impulsive Consumption';

  @override
  String get navHome => 'Home';

  @override
  String get navCategory => 'Categories';

  @override
  String get navCart => 'Cart';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProfile => 'Me';

  @override
  String get searchHint => 'Search products';

  @override
  String get flashSale => 'Flash Sale';

  @override
  String get guessYouLike => 'Picked for You';

  @override
  String soldCount(int count) {
    return '$count sold';
  }

  @override
  String stockLeft(int count) {
    return '$count in stock';
  }

  @override
  String onlyLeft(int count) {
    return 'Only $count left';
  }

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get productDescription => 'Description';

  @override
  String get emptyResult => 'No matching products';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptySubtitle => 'Go browse and treat yourself~';

  @override
  String get goShopping => 'Browse';

  @override
  String get selectAll => 'Select All';

  @override
  String get total => 'Total';

  @override
  String checkoutWithCount(int count) {
    return 'Checkout ($count)';
  }

  @override
  String get clearCart => 'Clear Cart';

  @override
  String get clearCartConfirm => 'Clear all items from your cart?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'OK';

  @override
  String get delete => 'Delete';

  @override
  String get itemRemoved => 'Removed';

  @override
  String get cleared => 'Cart cleared';

  @override
  String maxPerItem(int count) {
    return 'Max $count';
  }

  @override
  String get walletTitle => 'My Wallet';

  @override
  String get balance => 'Balance';

  @override
  String get totalRecharged => 'Recharged';

  @override
  String get totalSpent => 'Spent';

  @override
  String get recharge => 'Recharge';

  @override
  String get customAmount => 'Custom amount';

  @override
  String get rechargeSuccess => 'Recharged successfully';

  @override
  String get transactions => 'Transactions';

  @override
  String get txRecharge => 'Top-up';

  @override
  String get txSpend => 'Purchase';

  @override
  String get txCheckin => 'Check-in reward';

  @override
  String txBalanceAfter(String amount) {
    return 'Balance $amount';
  }

  @override
  String get insufficientTitle => 'Insufficient balance';

  @override
  String insufficientMsg(String balance, String missing) {
    return 'Your balance is $balance, but you need $missing more.';
  }

  @override
  String get goRecharge => 'Recharge Now';

  @override
  String get paymentSuccess => 'Payment Successful!';

  @override
  String get payNow => 'Pay Now';

  @override
  String get checkoutTitle => 'Confirm Order';

  @override
  String get recipientLabel => 'Recipient';

  @override
  String get recipientName => 'Chongchong';

  @override
  String get addressPhone => '138****8888';

  @override
  String get addressDetail =>
      'No.1 Xingfu Road, Building 2, Room 888, Happiness Community';

  @override
  String get coupon => 'Coupons';

  @override
  String get noCoupon => 'No coupon';

  @override
  String get couponAvailable => 'Available';

  @override
  String get couponUnavailable => 'Unavailable';

  @override
  String couponThreshold(String amount) {
    return 'Over $amount';
  }

  @override
  String savedAmount(String amount) {
    return 'Saved $amount';
  }

  @override
  String get itemsTotal => 'Items total';

  @override
  String get discount => 'Discount';

  @override
  String get payable => 'Payable';

  @override
  String get ordersTitle => 'My Orders';

  @override
  String get statusAll => 'All';

  @override
  String get orderStatusPendingShip => 'To Ship';

  @override
  String get orderStatusShipping => 'Shipping';

  @override
  String get orderStatusDelivering => 'Out for Delivery';

  @override
  String get orderStatusCompleted => 'Delivered';

  @override
  String get orderNoLabel => 'Order No.';

  @override
  String get buyAgain => 'Buy Again';

  @override
  String get logistics => 'Logistics';

  @override
  String get stepPlaced => 'Order placed';

  @override
  String get stepShipped => 'Seller shipped';

  @override
  String get stepTransit => 'Package in transit';

  @override
  String get stepDeliver => 'Courier delivering';

  @override
  String get stepSigned => 'Signed & delivered';

  @override
  String get orderEmptyTitle => 'No orders yet';

  @override
  String get orderEmptyAction => 'Start Shopping';

  @override
  String get wishlistTitle => 'Wishlist';

  @override
  String get wishlistEmpty => 'Your wishlist is empty';

  @override
  String get checkin => 'Daily Check-in';

  @override
  String get checkinNow => 'Check In';

  @override
  String get checkedToday => 'Checked in today';

  @override
  String checkinDay(int n) {
    return 'D$n';
  }

  @override
  String streakDays(int count) {
    return '$count-day streak';
  }

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get regionCurrency => 'Region & Currency';

  @override
  String get themeMode => 'Dark Mode';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get about => 'About';

  @override
  String get aboutDisclaimer =>
      'This app is a purely local shopping simulation. It involves no real transactions and performs no network requests. All data stays on your device.';

  @override
  String get versionLabel => 'Version';

  @override
  String get sortBest => 'Best Match';

  @override
  String get sortSales => 'Top Sales';

  @override
  String get sortPriceAsc => 'Price: Low to High';

  @override
  String get sortPriceDesc => 'Price: High to Low';

  @override
  String get banner1Title => 'Felt the urge today?';

  @override
  String get banner1Sub => 'Thousands of deals up to 50% off';

  @override
  String get banner2Title => 'Newcomer Gift Pack';

  @override
  String get banner2Sub => 'Big coupons waiting for you';

  @override
  String get banner3Title => 'City-wide Flash Delivery';

  @override
  String get banner3Sub => '\"Delivered\" in as fast as 6 minutes';

  @override
  String get langEn => 'English';

  @override
  String get langZhHant => '繁體中文';

  @override
  String get langZhHans => '简体中文';

  @override
  String get regionCN => 'Mainland China · CNY ¥';

  @override
  String get regionUS => 'United States · USD \$';

  @override
  String get regionHK => 'Hong Kong · HKD HK\$';

  @override
  String get couponNewcomer => 'Newcomer Coupon';

  @override
  String get couponOff30Over300 => '¥30 off over ¥300';

  @override
  String get couponOff120Over1000 => '¥120 off over ¥1000';

  @override
  String get coupon95 => '5% off over ¥100';
}
