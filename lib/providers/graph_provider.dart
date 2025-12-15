import 'package:flutter/material.dart';
import '../models/math_function.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/performance_monitor.dart';

class GraphProvider with ChangeNotifier {
  List<MathFunction> _functions = [];
  double _minX = -10;
  double _maxX = 10;
  double _minY = -10;
  double _maxY = 10;

  List<MathFunction> get functions => _functions;
  double get minX => _minX;
  double get maxX => _maxX;
  double get minY => _minY;
  double get maxY => _maxY;

  void addFunction(String expression, Color color) {
    _functions.add(MathFunction(expression, color: color));
    notifyListeners();
  }

  void removeFunction(int index) {
    if (index >= 0 && index < _functions.length) {
      _functions.removeAt(index);
      notifyListeners();
    }
  }

  void clearFunctions() {
    _functions.clear();
    notifyListeners();
  }

  void updateViewport({double? minX, double? maxX, double? minY, double? maxY}) {
    if (minX != null) _minX = minX;
    if (maxX != null) _maxX = maxX;
    if (minY != null) _minY = minY;
    if (maxY != null) _maxY = maxY;
    notifyListeners();
  }

  List<FlSpot> generatePoints(MathFunction func, {int points = 100}) {
    PerformanceMonitor().start('generatePoints', thresholdMs: 50);
    List<FlSpot> spots = [];
    double step = (_maxX - _minX) / points;
    
    for (double x = _minX; x <= _maxX; x += step) {
      try {
        double y = func.evaluate(x);
        if (y.isFinite) {
             spots.add(FlSpot(x, y));
        }
      } catch (e) {
        // Skip invalid points
      }
    }
    PerformanceMonitor().stop('generatePoints');
    return spots;
  }
}
