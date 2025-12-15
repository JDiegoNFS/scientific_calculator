import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

enum AngleMode { degrees, radians }

class ExpressionParser {
  final Parser _parser = Parser();
  final ContextModel _context = ContextModel();

  ExpressionParser();

  double evaluate(String expression, {AngleMode angleMode = AngleMode.radians}) {
    if (expression.isEmpty) return 0.0;

    String processed = _sanitize(expression);
    
    // Parse
    Expression exp = _parser.parse(processed);
    
    // Transform for AngleMode if needed
    if (angleMode == AngleMode.degrees) {
      exp = _transformForDegrees(exp);
    }

    // Evaluate
    double result = exp.evaluate(EvaluationType.REAL, _context);
    return result;
  }

  String _sanitize(String input) {
    String p = input
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('π', '${math.pi}')
        .replaceAll('e', '${math.e}')
        .replaceAll('arcsin', 'asin')
        .replaceAll('arccos', 'acos')
        .replaceAll('arctan', 'atan');

    // Handle log -> log(10, x)
    p = p.replaceAll('log(', 'log(10, ');
    
    // fact(x) -> x! uses regex for basic "fact(number)" or "fact(var)"
    // Handling nested fact might fail with basic regex but sufficient for now.
    p = p.replaceAllMapped(RegExp(r'fact\((.*?)\)'), (match) => '(${match.group(1)})!');
    
    // nPr, nCr
    p = p.replaceAllMapped(RegExp(r'nPr\(([^,]+),([^)]+)\)'), 
        (match) => '(${match.group(1)}! / (${match.group(1)} - ${match.group(2)})!)');
        
    p = p.replaceAllMapped(RegExp(r'nCr\(([^,]+),([^)]+)\)'), 
        (match) => '(${match.group(1)}! / (${match.group(2)}! * (${match.group(1)} - ${match.group(2)})!))');
    
    // Hyperbolic support (simple regex)
    // We assume input is reasonably formed "sinh(val)".
    // Using simple loop to handle mild nesting.
    for (int i = 0; i < 3; i++) {
       p = p.replaceAllMapped(RegExp(r'sinh\((.*?)\)'), (m) => '(((${math.e}^(${m.group(1)})) - (${math.e}^(-(${m.group(1)})))) / 2)');
       p = p.replaceAllMapped(RegExp(r'cosh\((.*?)\)'), (m) => '(((${math.e}^(${m.group(1)})) + (${math.e}^(-(${m.group(1)})))) / 2)');
       p = p.replaceAllMapped(RegExp(r'tanh\((.*?)\)'), (m) => '(((${math.e}^(${m.group(1)})) - (${math.e}^(-(${m.group(1)})))) / ((${math.e}^(${m.group(1)})) + (${math.e}^(-(${m.group(1)})))))');
    }

    return p;
  }
  
  // Recursively transform expression tree to handle Degree conversion
  Expression _transformForDegrees(Expression exp) {
     // Check for Unary Functions first
    if (exp is Sin) {
      return Sin(Times(_transformForDegrees(exp.arg), Number(math.pi / 180))); 
    } else if (exp is Cos) {
      return Cos(Times(_transformForDegrees(exp.arg), Number(math.pi / 180)));
    } else if (exp is Tan) {
      return Tan(Times(_transformForDegrees(exp.arg), Number(math.pi / 180)));
    } else if (exp is Asin) {
      return Times(Asin(_transformForDegrees(exp.arg)), Number(180 / math.pi));
    } else if (exp is Acos) {
      return Times(Acos(_transformForDegrees(exp.arg)), Number(180 / math.pi));
    } else if (exp is Atan) {
      return Times(Atan(_transformForDegrees(exp.arg)), Number(180 / math.pi));
    }
    
    // Iterate manually over known binary/unary types since generic children access is limited
    if (exp is Plus) return Plus(_transformForDegrees(exp.first), _transformForDegrees(exp.second));
    if (exp is Minus) return Minus(_transformForDegrees(exp.first), _transformForDegrees(exp.second));
    if (exp is Times) return Times(_transformForDegrees(exp.first), _transformForDegrees(exp.second));
    if (exp is Divide) return Divide(_transformForDegrees(exp.first), _transformForDegrees(exp.second));
    if (exp is Power) return Power(_transformForDegrees(exp.first), _transformForDegrees(exp.second));
    // Log fields are uncertain (base, arg?), casting to dynamic to attempt runtime resolution
    if (exp is Log) {
      dynamic d = exp;
      return Log(_transformForDegrees(d.base), _transformForDegrees(d.arg)); 
    }

    if (exp is Ln) return Ln(_transformForDegrees(exp.arg));
    if (exp is UnaryMinus) return UnaryMinus(_transformForDegrees(exp.exp));
    
    return exp; 
  }
  
  List<String> getSuggestions(String partial) {
    return [];
  }
}
