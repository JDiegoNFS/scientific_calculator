import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/services/security_service.dart';

void main() {
  group('Security Service Property Tests', () {
    
    // **Feature: Security, Property 43: Data Sanitization**
    test('Property 43: Input Sanitization strips control chars', () {
      final service = SecurityService();
      String input = 'Hello\x00World';
      String sanitized = service.sanitizeInput(input);
      expect(sanitized, 'HelloWorld');
      
      String longInput = 'a' * 2000;
      String truncated = service.sanitizeInput(longInput);
      expect(truncated.length, 1000);
    });

    test('Privacy Mode Masking', () {
      final service = SecurityService();
      expect(service.isPrivateMode, false);
      expect(service.maskData('secret'), 'secret');
      
      service.togglePrivateMode();
      expect(service.isPrivateMode, true);
      expect(service.maskData('secret'), '******');
    });
  });
}
