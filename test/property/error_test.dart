import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/services/error_handler.dart';

void main() {
  group('Error Handling Property Tests', () {
    
    // **Feature: Error Handling, Property 39: Error Message Clarity**
    test('Property 39: Error Message Clarity', () {
      // Simulate generic error
      var err = Exception('Division by zero');
      String msg = ErrorHandler.handle(err);
      expect(msg, contains('Math Error'));
      expect(msg, contains('zero'));
      
      // Simulate parser error
      err = FormatException('Unexpected character');
      msg = ErrorHandler.handle(err);
      expect(msg, contains('Syntax Error'));
    });

    test('Property 42: Long error message truncation', () {
      String longMsg = 'This is a very very very very very very very very very long error message that should be truncated';
      String handled = ErrorHandler.handle(Exception(longMsg));
      expect(handled.length, lessThanOrEqualTo(61));
      expect(handled, contains('...'));
    });
  });
}
