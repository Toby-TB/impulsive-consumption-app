import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/data/database/tables.dart';
import 'package:impulsive_consumption/data/services/logistics_calculator.dart';

void main() {
  final paid = DateTime(2026, 8, 23, 12, 0, 0);

  OrderStatus at(int seconds) =>
      LogisticsCalculator.statusAt(paid, paid.add(Duration(seconds: seconds)));

  group('statusAt thresholds', () {
    test('before ship window is pendingShip', () {
      expect(at(0), OrderStatus.pendingShip);
      expect(at(59), OrderStatus.pendingShip);
    });

    test('shipping starts at 60s', () {
      expect(at(60), OrderStatus.shipping);
      expect(at(179), OrderStatus.shipping);
    });

    test('delivering starts at 180s', () {
      expect(at(180), OrderStatus.delivering);
      expect(at(359), OrderStatus.delivering);
    });

    test('completed at 360s', () {
      expect(at(360), OrderStatus.completed);
      expect(at(3600), OrderStatus.completed);
    });
  });

  group('timeline', () {
    test('only placed reached right after payment', () {
      final steps = LogisticsCalculator.timeline(paid, paid);
      expect(steps[0].reached, isTrue); // 下单节点即时点亮
      expect(steps.skip(1).map((s) => s.reached), everyElement(isFalse));
      expect(steps.first.labelKey, 'stepPlaced');
      expect(steps.length, 5);
    });

    test('steps light up progressively', () {
      final steps = LogisticsCalculator.timeline(paid, paid.add(const Duration(seconds: 200)));
      expect(steps[0].reached, isTrue); // placed
      expect(steps[1].reached, isTrue); // shipped @60s
      expect(steps[2].reached, isTrue); // transit @90s
      expect(steps[3].reached, isTrue); // delivering @180s
      expect(steps[4].reached, isFalse); // signed @360s

      final done = LogisticsCalculator.timeline(paid, paid.add(const Duration(minutes: 10)));
      expect(done.map((s) => s.reached), everyElement(isTrue));
    });
  });
}
