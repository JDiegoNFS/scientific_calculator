import 'package:flutter/foundation.dart';

enum ErrorType {
  math,
  syntax,
  system,
  input,
}

class ErrorHandler {
  static String handle(dynamic error, [StackTrace? stack]) {
    debugPrint('Error caught: $error');
    if (stack != null) debugPrint(stack.toString());

    String msg = error.toString();

    if (msg.contains('Division by zero') || msg.contains('Infinity')) {
      return 'Math Error: Cannot divide by zero';
    }
    
    if (msg.contains('Parser Error') || msg.contains('FormatException')) {
      return 'Syntax Error: Check your expression';
    }

    if (msg.contains('Invalid argument')) {
      return 'Input Error: Invalid number or operation';
    }
    
    // Generic
    if (msg.length > 50) {
      return 'Error: ${msg.substring(0, 50)}...';
    }
    return 'Error: $msg';
  }
  
  static ErrorType classify(dynamic error) {
    String msg = error.toString().toLowerCase();
    if (msg.contains('division') || msg.contains('infinity') || msg.contains('nan')) {
      return ErrorType.math;
    }
    if (msg.contains('parser') || msg.contains('format')) {
      return ErrorType.syntax;
    }
    return ErrorType.system;
  }
}
