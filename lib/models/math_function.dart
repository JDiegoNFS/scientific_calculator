import 'package:flutter/material.dart';
import '../services/expression_parser.dart';

class MathFunction {
  final String expression;
  final Color? color;
  final ExpressionParser _parser = ExpressionParser();

  MathFunction(this.expression, {this.color});

  double evaluate(double x) {
    // Replace 'x' with the value
    // Note: Simple substitution might be risky if x is negative, e.g. "x^2" -> "-2^2" which is -4 vs (-2)^2 = 4
    // Better to substitute with parenthesis: "(value)"
    String evalExpr = expression.replaceAll('x', '(${x.toString()})');
    return _parser.evaluate(evalExpr);
  }
}

// Just a placeholder for Color if dart:ui is not available in model only files, 
// strictly models shouldn't depend on Flutter UI, but for simplicity we Import Flutter material/ui
// or we can store color as int.
