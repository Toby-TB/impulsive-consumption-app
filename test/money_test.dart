import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/core/utils/money.dart';

void main() {
  group('formatMoney', () {
    test('CNY keeps two decimals', () {
      expect(formatMoney(12345, cur: FxCurrency.cny), '¥123.45');
      expect(formatMoney(0, cur: FxCurrency.cny), '¥0.00');
    });

    test('converts CNY base cents to USD', () {
      // 1,000,000分 = ¥10,000 -> /7.20 = $1,388.888... -> $1,388.89
      expect(formatMoney(1000000, cur: FxCurrency.usd), r'$1,388.89');
    });

    test('converts CNY base cents to HKD', () {
      // ¥10,000 / 0.926 = 10,799.1356... -> HK$10,799.14
      expect(formatMoney(1000000, cur: FxCurrency.hkd), 'HK\$10,799.14');
    });

    test('supports negative amounts for spend records', () {
      expect(formatMoney(-50000, cur: FxCurrency.cny), '-¥500.00');
    });
  });

  group('parsePresetToBaseCents', () {
    test('converts preset in selected currency into CNY cents', () {
      expect(parsePresetToBaseCents(100, FxCurrency.usd), 72000);
      expect(parsePresetToBaseCents(50, FxCurrency.cny), 5000);
      expect(parsePresetToBaseCents(200, FxCurrency.hkd), (200 * 0.926 * 100).round());
    });

    test('rejects non-positive amounts', () {
      expect(() => parsePresetToBaseCents(0, FxCurrency.cny), throwsArgumentError);
      expect(() => parsePresetToBaseCents(-5, FxCurrency.usd), throwsArgumentError);
    });
  });

  group('conversion helpers', () {
    test('displayMajorUnit converts base cents to currency major units', () {
      expect(FxCurrency.usd.displayMajorUnit(1000000), closeTo(1388.89, 0.001));
      expect(FxCurrency.cny.displayMajorUnit(1000000), 10000.0);
    });
  });
}
