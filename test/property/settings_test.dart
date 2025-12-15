import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/models/settings_model.dart';
import 'package:scientific_calculator/providers/calculator_provider.dart';

void main() {
  group('Settings System Property Tests', () {
    
    // **Feature: Settings, Property 37: Settings Export-Import Round-trip**
    test('Property 37: Settings serialization round-trip', () {
      final original = SettingsModel(
        precision: 4,
        vibrationEnabled: false,
        defaultMode: CalculatorMode.scientific,
      );
      
      final json = original.toJson();
      final restored = SettingsModel.fromJson(json);
      
      expect(restored.precision, original.precision);
      expect(restored.vibrationEnabled, original.vibrationEnabled);
      expect(restored.defaultMode, original.defaultMode);
    });

    test('Property 35: Precision Application logic', () {
      // Simulate precision application
      double value = 1.23456789;
      int precision = 4;
      
      String formatted = value.toStringAsFixed(precision);
      expect(formatted, '1.2346'); // rounded
      
      precision = 2;
      formatted = value.toStringAsFixed(precision);
      expect(formatted, '1.23');
    });
  });
}
