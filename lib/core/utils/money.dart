import 'package:intl/intl.dart';

/// 应用内三种展示币种。内部记账统一为 CNY 分（int）。
enum FxCurrency { cny, usd, hkd }

extension FxCurrencyX on FxCurrency {
  /// 1 单位该币种 = rateToCny × 1 CNY（模拟固定汇率）。
  double get rateToCny => switch (this) {
        FxCurrency.cny => 1.0,
        FxCurrency.usd => 7.20,
        FxCurrency.hkd => 0.926,
      };

  String get symbol => switch (this) {
        FxCurrency.cny => '¥',
        FxCurrency.usd => r'$',
        FxCurrency.hkd => r'HK$',
      };

  /// 把基准 CNY 分换算为该币种的“元/美元”主单位浮点值（保留两位小数）。
  double displayMajorUnit(int baseCents) {
    final raw = baseCents / 100.0 / rateToCny;
    return (raw * 100).roundToDouble() / 100;
  }
}

String formatMoney(int baseCents, {required FxCurrency cur, String? locale}) {
  final value = cur.displayMajorUnit(baseCents);
  final formatter = NumberFormat.currency(
    symbol: cur.symbol,
    decimalDigits: 2,
    locale: (locale == null || locale.isEmpty) ? null : locale,
  );
  return formatter.format(value);
}

/// 将所选币种下的充值档位金额折算为基准 CNY 分。
int parsePresetToBaseCents(double amount, FxCurrency cur) {
  if (amount <= 0) {
    throw ArgumentError.value(amount, 'amount', 'must be positive');
  }
  return (amount * cur.rateToCny * 100).round();
}
