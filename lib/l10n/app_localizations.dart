import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Impulsive Consumption'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCategory.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategory;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get navProfile;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchHint;

  /// No description provided for @flashSale.
  ///
  /// In en, this message translates to:
  /// **'Flash Sale'**
  String get flashSale;

  /// No description provided for @guessYouLike.
  ///
  /// In en, this message translates to:
  /// **'Picked for You'**
  String get guessYouLike;

  /// No description provided for @soldCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sold'**
  String soldCount(int count);

  /// No description provided for @stockLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} in stock'**
  String stockLeft(int count);

  /// No description provided for @onlyLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {count} left'**
  String onlyLeft(int count);

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescription;

  /// No description provided for @emptyResult.
  ///
  /// In en, this message translates to:
  /// **'No matching products'**
  String get emptyResult;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Go browse and treat yourself~'**
  String get cartEmptySubtitle;

  /// No description provided for @goShopping.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get goShopping;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkoutWithCount.
  ///
  /// In en, this message translates to:
  /// **'Checkout ({count})'**
  String checkoutWithCount(int count);

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clearCart;

  /// No description provided for @clearCartConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear all items from your cart?'**
  String get clearCartConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @itemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get itemRemoved;

  /// No description provided for @cleared.
  ///
  /// In en, this message translates to:
  /// **'Cart cleared'**
  String get cleared;

  /// No description provided for @maxPerItem.
  ///
  /// In en, this message translates to:
  /// **'Max {count}'**
  String maxPerItem(int count);

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get walletTitle;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @totalRecharged.
  ///
  /// In en, this message translates to:
  /// **'Recharged'**
  String get totalRecharged;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get totalSpent;

  /// No description provided for @recharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get recharge;

  /// No description provided for @customAmount.
  ///
  /// In en, this message translates to:
  /// **'Custom amount'**
  String get customAmount;

  /// No description provided for @rechargeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recharged successfully'**
  String get rechargeSuccess;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @txRecharge.
  ///
  /// In en, this message translates to:
  /// **'Top-up'**
  String get txRecharge;

  /// No description provided for @txSpend.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get txSpend;

  /// No description provided for @txCheckin.
  ///
  /// In en, this message translates to:
  /// **'Check-in reward'**
  String get txCheckin;

  /// No description provided for @txBalanceAfter.
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}'**
  String txBalanceAfter(String amount);

  /// No description provided for @insufficientTitle.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get insufficientTitle;

  /// No description provided for @insufficientMsg.
  ///
  /// In en, this message translates to:
  /// **'Your balance is {balance}, but you need {missing} more.'**
  String insufficientMsg(String balance, String missing);

  /// No description provided for @goRecharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge Now'**
  String get goRecharge;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccess;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get checkoutTitle;

  /// No description provided for @recipientLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipientLabel;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Chongchong'**
  String get recipientName;

  /// No description provided for @addressPhone.
  ///
  /// In en, this message translates to:
  /// **'138****8888'**
  String get addressPhone;

  /// No description provided for @addressDetail.
  ///
  /// In en, this message translates to:
  /// **'No.1 Xingfu Road, Building 2, Room 888, Happiness Community'**
  String get addressDetail;

  /// No description provided for @coupon.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get coupon;

  /// No description provided for @noCoupon.
  ///
  /// In en, this message translates to:
  /// **'No coupon'**
  String get noCoupon;

  /// No description provided for @couponAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get couponAvailable;

  /// No description provided for @couponUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get couponUnavailable;

  /// No description provided for @couponThreshold.
  ///
  /// In en, this message translates to:
  /// **'Over {amount}'**
  String couponThreshold(String amount);

  /// No description provided for @savedAmount.
  ///
  /// In en, this message translates to:
  /// **'Saved {amount}'**
  String savedAmount(String amount);

  /// No description provided for @itemsTotal.
  ///
  /// In en, this message translates to:
  /// **'Items total'**
  String get itemsTotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @payable.
  ///
  /// In en, this message translates to:
  /// **'Payable'**
  String get payable;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get ordersTitle;

  /// No description provided for @statusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get statusAll;

  /// No description provided for @orderStatusPendingShip.
  ///
  /// In en, this message translates to:
  /// **'To Ship'**
  String get orderStatusPendingShip;

  /// No description provided for @orderStatusShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get orderStatusShipping;

  /// No description provided for @orderStatusDelivering.
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get orderStatusDelivering;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusCompleted;

  /// No description provided for @orderNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Order No.'**
  String get orderNoLabel;

  /// No description provided for @buyAgain.
  ///
  /// In en, this message translates to:
  /// **'Buy Again'**
  String get buyAgain;

  /// No description provided for @logistics.
  ///
  /// In en, this message translates to:
  /// **'Logistics'**
  String get logistics;

  /// No description provided for @stepPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order placed'**
  String get stepPlaced;

  /// No description provided for @stepShipped.
  ///
  /// In en, this message translates to:
  /// **'Seller shipped'**
  String get stepShipped;

  /// No description provided for @stepTransit.
  ///
  /// In en, this message translates to:
  /// **'Package in transit'**
  String get stepTransit;

  /// No description provided for @stepDeliver.
  ///
  /// In en, this message translates to:
  /// **'Courier delivering'**
  String get stepDeliver;

  /// No description provided for @stepSigned.
  ///
  /// In en, this message translates to:
  /// **'Signed & delivered'**
  String get stepSigned;

  /// No description provided for @orderEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get orderEmptyTitle;

  /// No description provided for @orderEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get orderEmptyAction;

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistTitle;

  /// No description provided for @wishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmpty;

  /// No description provided for @checkin.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in'**
  String get checkin;

  /// No description provided for @checkinNow.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkinNow;

  /// No description provided for @checkedToday.
  ///
  /// In en, this message translates to:
  /// **'Checked in today'**
  String get checkedToday;

  /// No description provided for @checkinDay.
  ///
  /// In en, this message translates to:
  /// **'D{n}'**
  String checkinDay(int n);

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak'**
  String streakDays(int count);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @regionCurrency.
  ///
  /// In en, this message translates to:
  /// **'Region & Currency'**
  String get regionCurrency;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This app is a purely local shopping simulation. It involves no real transactions and performs no network requests. All data stays on your device.'**
  String get aboutDisclaimer;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @sortBest.
  ///
  /// In en, this message translates to:
  /// **'Best Match'**
  String get sortBest;

  /// No description provided for @sortSales.
  ///
  /// In en, this message translates to:
  /// **'Top Sales'**
  String get sortSales;

  /// No description provided for @sortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceDesc;

  /// No description provided for @banner1Title.
  ///
  /// In en, this message translates to:
  /// **'Felt the urge today?'**
  String get banner1Title;

  /// No description provided for @banner1Sub.
  ///
  /// In en, this message translates to:
  /// **'Thousands of deals up to 50% off'**
  String get banner1Sub;

  /// No description provided for @banner2Title.
  ///
  /// In en, this message translates to:
  /// **'Newcomer Gift Pack'**
  String get banner2Title;

  /// No description provided for @banner2Sub.
  ///
  /// In en, this message translates to:
  /// **'Big coupons waiting for you'**
  String get banner2Sub;

  /// No description provided for @banner3Title.
  ///
  /// In en, this message translates to:
  /// **'City-wide Flash Delivery'**
  String get banner3Title;

  /// No description provided for @banner3Sub.
  ///
  /// In en, this message translates to:
  /// **'\"Delivered\" in as fast as 6 minutes'**
  String get banner3Sub;

  /// No description provided for @langEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEn;

  /// No description provided for @langZhHant.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get langZhHant;

  /// No description provided for @langZhHans.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get langZhHans;

  /// No description provided for @regionCN.
  ///
  /// In en, this message translates to:
  /// **'Mainland China · CNY ¥'**
  String get regionCN;

  /// No description provided for @regionUS.
  ///
  /// In en, this message translates to:
  /// **'United States · USD \$'**
  String get regionUS;

  /// No description provided for @regionHK.
  ///
  /// In en, this message translates to:
  /// **'Hong Kong · HKD HK\$'**
  String get regionHK;

  /// No description provided for @couponNewcomer.
  ///
  /// In en, this message translates to:
  /// **'Newcomer Coupon'**
  String get couponNewcomer;

  /// No description provided for @couponOff30Over300.
  ///
  /// In en, this message translates to:
  /// **'¥30 off over ¥300'**
  String get couponOff30Over300;

  /// No description provided for @couponOff120Over1000.
  ///
  /// In en, this message translates to:
  /// **'¥120 off over ¥1000'**
  String get couponOff120Over1000;

  /// No description provided for @coupon95.
  ///
  /// In en, this message translates to:
  /// **'5% off over ¥100'**
  String get coupon95;

  /// No description provided for @levelBadge.
  ///
  /// In en, this message translates to:
  /// **'Lv.{n}'**
  String levelBadge(int n);

  /// No description provided for @expLabel.
  ///
  /// In en, this message translates to:
  /// **'EXP'**
  String get expLabel;

  /// No description provided for @impulseLabel.
  ///
  /// In en, this message translates to:
  /// **'Impulse'**
  String get impulseLabel;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement unlocked!'**
  String get achievementUnlocked;

  /// No description provided for @levelUp.
  ///
  /// In en, this message translates to:
  /// **'Level Up!'**
  String get levelUp;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @rewardFormat.
  ///
  /// In en, this message translates to:
  /// **'+{amount}'**
  String rewardFormat(String amount);

  /// No description provided for @paymentXpGain.
  ///
  /// In en, this message translates to:
  /// **'+{n} EXP'**
  String paymentXpGain(int n);

  /// No description provided for @paymentImpulseGain.
  ///
  /// In en, this message translates to:
  /// **'+{n} Impulse'**
  String paymentImpulseGain(int n);

  /// No description provided for @paymentContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get paymentContinue;

  /// No description provided for @levelUpReward.
  ///
  /// In en, this message translates to:
  /// **'Lv.{n} reward +{amount}'**
  String levelUpReward(int n, Object amount);

  /// No description provided for @titleRestrained.
  ///
  /// In en, this message translates to:
  /// **'Rookie'**
  String get titleRestrained;

  /// No description provided for @titlePotential.
  ///
  /// In en, this message translates to:
  /// **'Rising Star'**
  String get titlePotential;

  /// No description provided for @titleNoviceSplurger.
  ///
  /// In en, this message translates to:
  /// **'Splurge Rookie'**
  String get titleNoviceSplurger;

  /// No description provided for @titleSplurger.
  ///
  /// In en, this message translates to:
  /// **'Splurge Master'**
  String get titleSplurger;

  /// No description provided for @titleSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver Splurger'**
  String get titleSilver;

  /// No description provided for @titleGold.
  ///
  /// In en, this message translates to:
  /// **'Gold Splurger'**
  String get titleGold;

  /// No description provided for @titleGod.
  ///
  /// In en, this message translates to:
  /// **'Impulse God'**
  String get titleGod;

  /// No description provided for @achFirstOrder.
  ///
  /// In en, this message translates to:
  /// **'First Order'**
  String get achFirstOrder;

  /// No description provided for @achFirstOrderDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your first order'**
  String get achFirstOrderDesc;

  /// No description provided for @achOrders5.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get achOrders5;

  /// No description provided for @achOrders5Desc.
  ///
  /// In en, this message translates to:
  /// **'Complete 5 orders'**
  String get achOrders5Desc;

  /// No description provided for @achSpend1k.
  ///
  /// In en, this message translates to:
  /// **'¥1K Club'**
  String get achSpend1k;

  /// No description provided for @achSpend1kDesc.
  ///
  /// In en, this message translates to:
  /// **'Spend over ¥1,000 in total'**
  String get achSpend1kDesc;

  /// No description provided for @achSpend10k.
  ///
  /// In en, this message translates to:
  /// **'¥10K Whale'**
  String get achSpend10k;

  /// No description provided for @achSpend10kDesc.
  ///
  /// In en, this message translates to:
  /// **'Spend over ¥10,000 in total'**
  String get achSpend10kDesc;

  /// No description provided for @achBigSpender.
  ///
  /// In en, this message translates to:
  /// **'Big Spender'**
  String get achBigSpender;

  /// No description provided for @achBigSpenderDesc.
  ///
  /// In en, this message translates to:
  /// **'A single order over ¥5,000'**
  String get achBigSpenderDesc;

  /// No description provided for @achCart10.
  ///
  /// In en, this message translates to:
  /// **'Cart Hoarder'**
  String get achCart10;

  /// No description provided for @achCart10Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 10 items in cart at once'**
  String get achCart10Desc;

  /// No description provided for @achWishlist5.
  ///
  /// In en, this message translates to:
  /// **'Curator'**
  String get achWishlist5;

  /// No description provided for @achWishlist5Desc.
  ///
  /// In en, this message translates to:
  /// **'Wishlist 5 products'**
  String get achWishlist5Desc;

  /// No description provided for @achStreak3.
  ///
  /// In en, this message translates to:
  /// **'3-Day Streak'**
  String get achStreak3;

  /// No description provided for @achStreak3Desc.
  ///
  /// In en, this message translates to:
  /// **'Check in 3 days in a row'**
  String get achStreak3Desc;

  /// No description provided for @achStreak7.
  ///
  /// In en, this message translates to:
  /// **'7-Day Streak'**
  String get achStreak7;

  /// No description provided for @achStreak7Desc.
  ///
  /// In en, this message translates to:
  /// **'Check in 7 days in a row'**
  String get achStreak7Desc;

  /// No description provided for @achLevel5.
  ///
  /// In en, this message translates to:
  /// **'Level 5'**
  String get achLevel5;

  /// No description provided for @achLevel5Desc.
  ///
  /// In en, this message translates to:
  /// **'Reach level 5'**
  String get achLevel5Desc;

  /// No description provided for @addressTitle.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get addressTitle;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'New Address'**
  String get addAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @regionLabel.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get regionLabel;

  /// No description provided for @detailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get detailAddressLabel;

  /// No description provided for @setDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get setDefault;

  /// No description provided for @defaultAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultAddressLabel;

  /// No description provided for @deleteAddressConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this address?'**
  String get deleteAddressConfirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodLabel;

  /// No description provided for @payBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get payBalance;

  /// No description provided for @payCod.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get payCod;

  /// No description provided for @payCodNote.
  ///
  /// In en, this message translates to:
  /// **'Charged on delivery'**
  String get payCodNote;

  /// No description provided for @payInstallment.
  ///
  /// In en, this message translates to:
  /// **'3 installments, 0% interest'**
  String get payInstallment;

  /// No description provided for @payInstallmentNote.
  ///
  /// In en, this message translates to:
  /// **'First {amount}, rest shown in order'**
  String payInstallmentNote(String amount);

  /// No description provided for @buyerMessage.
  ///
  /// In en, this message translates to:
  /// **'Buyer Note'**
  String get buyerMessage;

  /// No description provided for @remarkHint.
  ///
  /// In en, this message translates to:
  /// **'Optional, leave a note for seller'**
  String get remarkHint;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please add a shipping address first'**
  String get addressRequired;

  /// No description provided for @installmentProgress.
  ///
  /// In en, this message translates to:
  /// **'Installment · paid {paid}/3'**
  String installmentProgress(int paid);

  /// No description provided for @codNote.
  ///
  /// In en, this message translates to:
  /// **'COD · charged when signed'**
  String get codNote;

  /// No description provided for @chargeHint.
  ///
  /// In en, this message translates to:
  /// **'Spend {amount} more to unlock coupon'**
  String chargeHint(String amount);

  /// No description provided for @chargeFull.
  ///
  /// In en, this message translates to:
  /// **'Coupon threshold reached!'**
  String get chargeFull;

  /// No description provided for @critActive.
  ///
  /// In en, this message translates to:
  /// **'CRIT! Coupon ×2'**
  String get critActive;

  /// No description provided for @gachaTitle.
  ///
  /// In en, this message translates to:
  /// **'Lucky Box'**
  String get gachaTitle;

  /// No description provided for @gachaOpen.
  ///
  /// In en, this message translates to:
  /// **'Open ({cost} coins)'**
  String gachaOpen(Object cost);

  /// No description provided for @gachaNeedCoins.
  ///
  /// In en, this message translates to:
  /// **'Need {amount} more coins'**
  String gachaNeedCoins(int amount);

  /// No description provided for @gachaPity.
  ///
  /// In en, this message translates to:
  /// **'Guaranteed in {n}'**
  String gachaPity(int n);

  /// No description provided for @coinsLabel.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get coinsLabel;

  /// No description provided for @exchangeCoins.
  ///
  /// In en, this message translates to:
  /// **'Exchange 1000 → ¥10'**
  String get exchangeCoins;

  /// No description provided for @exchangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exchanged!'**
  String get exchangeSuccess;

  /// No description provided for @coinEarned.
  ///
  /// In en, this message translates to:
  /// **'+{n} coins'**
  String coinEarned(int n);

  /// No description provided for @notEnoughCoins.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins'**
  String get notEnoughCoins;

  /// No description provided for @banner4Title.
  ///
  /// In en, this message translates to:
  /// **'Lucky Box Open!'**
  String get banner4Title;

  /// No description provided for @banner4Sub.
  ///
  /// In en, this message translates to:
  /// **'Spend coins, win big red packets'**
  String get banner4Sub;

  /// No description provided for @prizeCoins150.
  ///
  /// In en, this message translates to:
  /// **'150 Coins'**
  String get prizeCoins150;

  /// No description provided for @prizeCoins400.
  ///
  /// In en, this message translates to:
  /// **'400 Coins'**
  String get prizeCoins400;

  /// No description provided for @prizeCoins2000.
  ///
  /// In en, this message translates to:
  /// **'2,000 Coins'**
  String get prizeCoins2000;

  /// No description provided for @prizeCredit1.
  ///
  /// In en, this message translates to:
  /// **'¥1 Red Packet'**
  String get prizeCredit1;

  /// No description provided for @prizeCredit20.
  ///
  /// In en, this message translates to:
  /// **'¥20 Red Packet'**
  String get prizeCredit20;

  /// No description provided for @prizeCredit50.
  ///
  /// In en, this message translates to:
  /// **'¥50 Mega Red Packet'**
  String get prizeCredit50;

  /// No description provided for @prizeCoupon.
  ///
  /// In en, this message translates to:
  /// **'¥10 off ¥50 Coupon'**
  String get prizeCoupon;

  /// No description provided for @rarityN.
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get rarityN;

  /// No description provided for @rarityR.
  ///
  /// In en, this message translates to:
  /// **'R'**
  String get rarityR;

  /// No description provided for @raritySR.
  ///
  /// In en, this message translates to:
  /// **'SR'**
  String get raritySR;

  /// No description provided for @raritySSR.
  ///
  /// In en, this message translates to:
  /// **'SSR'**
  String get raritySSR;

  /// No description provided for @tapToSkip.
  ///
  /// In en, this message translates to:
  /// **'Tap to skip'**
  String get tapToSkip;

  /// No description provided for @sfxLabel.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get sfxLabel;

  /// No description provided for @sfxDesc.
  ///
  /// In en, this message translates to:
  /// **'Coin, combo and level-up sounds'**
  String get sfxDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
