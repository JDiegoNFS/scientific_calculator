import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/utils/stats_logic.dart';
import 'package:scientific_calculator/providers/calculator_provider.dart';

void main() {
  group('Statistics Logic', () {
    test('Mean', () {
      var s = StatsLogic([1, 2, 3, 4, 5]);
      expect(s.mean, 3.0);
    });

    test('Median Odd', () {
      var s = StatsLogic([1, 3, 2]);
      expect(s.median, 2.0);
    });

    test('Median Even', () {
      var s = StatsLogic([1, 2, 3, 4]);
      expect(s.median, 2.5);
    });

    test('Variance Sample', () {
      // 1, 2, 3. Mean=2.
      // (1-2)^2 + (2-2)^2 + (3-2)^2 = 1 + 0 + 1 = 2.
      // 2 / (3-1) = 1.
      var s = StatsLogic([1, 2, 3]);
      expect(s.sampleVariance, 1.0);
    });
  });

  group('Calculator Provider', () {
    test('Simple Addition', () {
      var p = CalculatorProvider();
      p.addToExpression('2+2');
      p.evaluate();
      expect(p.result, '4');
    });

    test('Scientific Function', () {
      var p = CalculatorProvider();
      p.addToExpression('sqrt(4)');
      p.evaluate();
      expect(p.result, '2');
    });
    
    test('Stats Data Adding', () {
      var p = CalculatorProvider();
      p.addStatData("10, 20, 30");
      expect(p.statsData.length, 3);
      expect(p.statsRef.mean, 20.0);
    });
  });
}
