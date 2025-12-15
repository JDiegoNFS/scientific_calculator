import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/utils/regression_logic.dart';
import 'dart:math';

void main() {
  group('Advanced Statistics Property Tests', () {
    
    // **Feature: Stats, Property 16: Statistical Calculation Accuracy (Regression)**
    test('Property 16: Linear Regression Accuracy', () {
      // y = 2x + 1
      List<double> x = [1, 2, 3, 4, 5];
      List<double> y = [3, 5, 7, 9, 11];
      
      var reg = RegressionLogic(x, y);
      expect(reg.slope, closeTo(2.0, 1e-9));
      expect(reg.intercept, closeTo(1.0, 1e-9));
      expect(reg.rSquared, closeTo(1.0, 1e-9));
      
      // y = -x
      x = [1, 2, 3];
      y = [-1, -2, -3];
      reg = RegressionLogic(x, y);
      expect(reg.slope, closeTo(-1.0, 1e-9));
    });

    test('Regression with Noise', () {
      // y = x + noise
      // R2 should be < 1 but > 0
      List<double> x = [1, 2, 3, 4, 5];
      List<double> y = [1.1, 1.9, 3.1, 3.9, 5.0];
      
      var reg = RegressionLogic(x, y);
      expect(reg.slope, closeTo(1.0, 0.1));
      expect(reg.rSquared, inInclusiveRange(0.9, 1.0));
    });

    // **Feature: Stats, Property 18: Probability Distribution Properties**
    test('Property 18: Normal Distribution PDF', () {
       // Peak at mean
       double mean = 0;
       double std = 1;
       double peak = ProbabilityDistributions.normalPDF(mean, mean, std);
       double side = ProbabilityDistributions.normalPDF(mean + 1, mean, std);
       
       expect(peak, greaterThan(side));
       expect(side, closeTo(peak * exp(-0.5), 1e-9)); // e^(-0.5) rule for 1 std dev
    });
  });
}
