import 'package:flutter/material.dart';
import '../services/data_persistence_service.dart';
import '../models/calculation_entry.dart';
import '../services/expression_parser.dart'; // Import custom parser
import '../services/error_handler.dart';
import '../services/performance_monitor.dart';
import '../utils/stats_logic.dart';

enum CalculatorMode { basic, scientific, statistics, matrix, graphing, converter }

class CalculatorProvider with ChangeNotifier {
  final ExpressionParser _parser = ExpressionParser(); // Use custom service
  
  String _expression = '';
  String _result = '0';
  List<double> _statsData = [];
  // For bivariate statistics (Regression)
  List<double> _statsDataX = [];
  List<double> _statsDataY = [];
  
  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.radians; // Default
  
  // Getters
  String get expression => _expression;
  String get result => _result;
  List<double> get statsData => _statsData;
  List<double> get statsDataX => _statsDataX;
  List<double> get statsDataY => _statsDataY;
  
  CalculatorMode get mode => _mode;
  AngleMode get angleMode => _angleMode;
  StatsLogic get statsRef => StatsLogic(_statsData);

  void setMode(CalculatorMode newMode) {
    _mode = newMode;
    notifyListeners();
  }

  void setAngleMode(AngleMode newMode) {
    _angleMode = newMode;
    notifyListeners();
  }

  bool _isCalculated = false; // Flag to track if result was just calculated

  void addToExpression(String value) {
    if (_isCalculated) {
      // Determine if the new input is an operator
      bool isOperator = ['+', '-', '*', '/', '^', '%', 'mod'].contains(value);
      
      if (isOperator) {
        // If operator, chain the result: "40" + "+"
        // Ensure we don't chain "Error" or invalid states
        if (_result != 'Error') {
          _expression = _result + value;
        } else {
           _expression = ''; // Start fresh if error
        }
      } else {
        // If number or function, start fresh: "2"
        _expression = value;
      }
      _isCalculated = false;
    } else {
      _expression += value;
    }
    notifyListeners();
  }
  
  void addFunction(String function) {
    if (_isCalculated) {
      // Functions always start fresh or wrap? 
      // Usually "sin(" starts fresh, unless logic is "sin(Ans)".
      // For simplicity, let's start fresh or append to empty.
      _expression = '$function(';
      _isCalculated = false;
    } else {
      _expression += '$function(';
    }
    notifyListeners();
  }

  void deleteLast() {
    if (_isCalculated) {
      // If we just calculated and press delete, usually we clear everything 
      // or start editing the result? Let's clear for simplicity.
      _expression = '';
      _result = '0';
      _isCalculated = false;
    } else if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
    }
    notifyListeners();
  }

  void clearHelper() {
    _expression = '';
    _result = '0';
    // Do not clear stats data here, usually separate clear for that
    notifyListeners();
  }

  void evaluate() {
    if (_expression.isEmpty) return;

    PerformanceMonitor().start('evaluate_expression');
    try {
      double eval = _parser.evaluate(_expression, angleMode: _angleMode);
      
      // Formatting
      _result = eval.toString();
      if (_result.endsWith(".0")) {
        _result = _result.substring(0, _result.length - 2);
      }
      _isCalculated = true; // Mark as calculated
      
    } catch (e) {
      _result = "Error";
      _isCalculated = true; // Mark as calculated even on error
    }
    PerformanceMonitor().stop('evaluate_expression');
    notifyListeners();
  }

  // Statistics specific methods
  void addStatData(String input) {
    // Attempt to parse one or multiple numbers
    // e.g. "5" or "5, 6, 7"
    try {
      if (input.contains(',')) {
        var parts = input.split(',');
        for (var p in parts) {
          _statsData.add(double.parse(p.trim()));
        }
      } else {
        _statsData.add(double.parse(input.trim()));
      }
      notifyListeners();
    } catch (e) {
      // ignore invalid input for now
    }
  }

  void removeStatDataAt(int index) {
    if (index >= 0 && index < _statsData.length) {
      _statsData.removeAt(index);
      notifyListeners();
    }
  }

  void clearStats() {
    _statsData.clear();
    _statsDataX.clear();
    _statsDataY.clear();
    notifyListeners();
  }

  // Bivariate Data Methods
  void addBivariateData(double x, double y) {
    _statsDataX.add(x);
    _statsDataY.add(y);
    notifyListeners();
  }
  
  void removeBivariateDataAt(int index) {
     if (index >= 0 && index < _statsDataX.length) {
       _statsDataX.removeAt(index);
       _statsDataY.removeAt(index);
       notifyListeners();
     }
  }
}
