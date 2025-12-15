import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/services/expression_parser.dart';
import 'dart:math';

void main() {
  group('Advanced Math Parser Property Tests', () {
    late ExpressionParser parser;

    setUp(() {
      parser = ExpressionParser();
    });

    // **Feature: calculator-production-ready, Property 1: Trigonometric Identity Preservation**
    test('Property 1: Trigonometric Identity Preservation', () {
        for (int i = 0; i < 100; i++) {
        double angle = Random().nextDouble() * 2 * pi;
        
        // Test in Radians
        double sinVal = parser.evaluate('sin($angle)', angleMode: AngleMode.radians);
        double cosVal = parser.evaluate('cos($angle)', angleMode: AngleMode.radians);
        
        expect(sinVal * sinVal + cosVal * cosVal, closeTo(1.0, 1e-9), 
               reason: 'Failed for angle $angle (Rad)');
        
        // Test in Degrees
        double angleDeg = angle * 180 / pi;
        double sinDeg = parser.evaluate('sin($angleDeg)', angleMode: AngleMode.degrees);
        double cosDeg = parser.evaluate('cos($angleDeg)', angleMode: AngleMode.degrees);
        
        expect(sinDeg * sinDeg + cosDeg * cosDeg, closeTo(1.0, 1e-9),
               reason: 'Failed for angle $angleDeg (Deg)');
      }
    });

    // **Feature: calculator-production-ready, Property 2: Hyperbolic Function Identities**
    test('Property 2: Hyperbolic Function Identities', () {
      for (int i = 0; i < 100; i++) {
        double x = (Random().nextDouble() - 0.5) * 10; // -5 to 5
        
        // cosh^2 - sinh^2 = 1
        double coshVal = parser.evaluate('cosh($x)');
        double sinhVal = parser.evaluate('sinh($x)');
        
        expect(coshVal * coshVal - sinhVal * sinhVal, closeTo(1.0, 1e-9),
               reason: 'Failed for x=$x');
      }
    });

    // **Feature: calculator-production-ready, Property 3: Angle Conversion (Validation)**
    test('Property 3: Angle Conversion/Mode Verification', () {
      // Verify sin(90 deg) == sin(pi/2 rad) == 1
      expect(parser.evaluate('sin(90)', angleMode: AngleMode.degrees), closeTo(1.0, 1e-9));
      expect(parser.evaluate('sin(${pi/2})', angleMode: AngleMode.radians), closeTo(1.0, 1e-9));
      
      // Verify consistency: sin(x deg) == sin(x * pi/180 rad)
      for (int i = 0; i < 50; i++) {
        double deg = Random().nextDouble() * 360;
        double rad = deg * pi / 180;
        
        double valDeg = parser.evaluate('sin($deg)', angleMode: AngleMode.degrees);
        double valRad = parser.evaluate('sin($rad)', angleMode: AngleMode.radians);
        
        expect(valDeg, closeTo(valRad, 1e-9));
      }
    });

    // **Feature: calculator-production-ready, Property 4: Factorial Mathematical Properties**
    test('Property 4: Factorial Mathematical Properties', () {
      // n! = n * (n-1)!
      // Test for small integers 1 to 10
      for (int n = 2; n <= 10; n++) {
        double factN = parser.evaluate('fact($n)');
        double factPrev = parser.evaluate('fact(${n-1})');
        
        expect(factN, closeTo(n * factPrev, 1e-9));
      }
      
      // 0! = 1
      expect(parser.evaluate('fact(0)'), closeTo(1.0, 1e-9));
    });

    // **Feature: calculator-production-ready, Property 5: Logarithm Properties**
    test('Property 5: Logarithm Properties', () {
      // log(a*b) = log(a) + log(b) (Base 10)
      for (int i = 0; i < 50; i++) {
        double a = Random().nextDouble() * 100 + 1;
        double b = Random().nextDouble() * 100 + 1;
        
        double logAB = parser.evaluate('log(${a * b})');
        double logA = parser.evaluate('log($a)');
        double logB = parser.evaluate('log($b)');
        
        expect(logAB, closeTo(logA + logB, 1e-9), reason: 'log($a*$b)');
      }
      
      // ln(e) = 1
      expect(parser.evaluate('ln(e)'), closeTo(1.0, 1e-9));
    });
  });
}
