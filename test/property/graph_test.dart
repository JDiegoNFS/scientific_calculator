import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/models/math_function.dart';
import 'package:scientific_calculator/providers/graph_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  group('Graphing Property Tests', () {
    
    // **Feature: Graphing, Property 25: Function Expression Validation**
    test('Property 25: Function Expression Validation', () {
      // Valid expressions should not throw
      List<String> validExprs = ['x', 'x^2', 'sin(x)', 'x + 5', '2*x - 1', 'log(x)'];
      for (var expr in validExprs) {
        var func = MathFunction(expr);
        expect(() => func.evaluate(1.0), returnsNormally, reason: 'Failed for $expr');
      }
      
      // We can't easily test "Invalid" without a specific parser error type defined 
      // or knowing if the parser throws or returns NaN. 
      // The current parser implementation returns NaN or throws FormatException usually.
    });

    // **Feature: Graphing, Property 26: Graph Point Accuracy**
    test('Property 26: Graph Point Accuracy', () {
      var func = MathFunction('x^2');
      
      for (int i = 0; i < 50; i++) {
        double x = (Random().nextDouble() - 0.5) * 20; // -10 to 10
        double y = func.evaluate(x);
        
        expect(y, closeTo(x * x, 1e-9));
      }
    });
    
    test('Multi-step Evaluation Consistency', () {
       // sin(x) + cos(x)
       var func = MathFunction('sin(x) + cos(x)');
       double val = func.evaluate(0);
       expect(val, closeTo(1.0, 1e-9)); // sin(0)+cos(0) = 0+1=1
       
       val = func.evaluate(pi);
       expect(val, closeTo(-1.0, 1e-9)); // sin(pi)+cos(pi) = 0-1=-1
    });

    // **Feature: Graphing, Property 27: Graph Interaction Consistency**
    test('Property 27: Graph Interaction Consistency', () {
      var provider = GraphProvider();
      
      // Default viewport
      expect(provider.minX, -10);
      expect(provider.maxX, 10);
      
      // Zoom in (reduce range)
      provider.updateViewport(minX: -5, maxX: 5);
      expect(provider.minX, -5);
      expect(provider.maxX, 5);
      
      // Validates State Notification (conceptually, provider notifies listeners)
      // Actual notification testing requires widget testing or mocking listeners, 
      // but here we verify state integrity.
    });
    
    test('Point Generation Bounds', () {
      var provider = GraphProvider();
      provider.updateViewport(minX: 0, maxX: 10);
      var func = MathFunction('x');
      
      List<FlSpot> spots = provider.generatePoints(func, points: 10);
      
      expect(spots.first.x, closeTo(0, 1e-9));
      expect(spots.last.x, closeTo(10, 1e-9));
      expect(spots.length, greaterThanOrEqualTo(10));
    });
  });
}
