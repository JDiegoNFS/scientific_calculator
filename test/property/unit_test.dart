import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/providers/unit_provider.dart';
import 'package:scientific_calculator/models/unit_model.dart';

void main() {
  group('Unit Converter Property Tests', () {
    
    // **Feature: Unit Converter, Property 30: Unit Conversion Round-trip**
    test('Property 30: Unit Conversion Round-trip', () {
      var provider = UnitProvider();
      
      // Test Length
      provider.setCategory(UnitCategory.length);
      var units = provider.currentUnits;
      
      for(var u1 in units) {
        for (var u2 in units) {
          if (u1 == u2) continue;
          
          // A -> B
          provider.setFromUnit(u1);
          provider.setToUnit(u2);
          provider.setInputValue(100.0);
          double valB = provider.resultValue;
          
          // B -> A
          provider.setFromUnit(u2);
          provider.setToUnit(u1);
          provider.setInputValue(valB);
          
          expect(provider.resultValue, closeTo(100.0, 1e-4), 
            reason: 'Failed round trip ${u1.name} <-> ${u2.name}');
        }
      }
    });

    // **Feature: Unit Converter, Property 31: Scientific Unit Accuracy**
    test('Property 31: Scientific Unit Accuracy', () {
       var provider = UnitProvider();
       provider.setCategory(UnitCategory.length);
       
       // 1 Inch = 2.54 cm
       Unit inch = provider.currentUnits.firstWhere((u) => u.name == 'Inch');
       Unit cm = provider.currentUnits.firstWhere((u) => u.name == 'Centimeter');
       
       provider.setFromUnit(inch);
       provider.setToUnit(cm);
       provider.setInputValue(1.0);
       
       expect(provider.resultValue, closeTo(2.54, 1e-9));
    });
    
    test('Temperature Conversion', () {
       var provider = UnitProvider();
       provider.setCategory(UnitCategory.temperature);
       
       Unit c = provider.currentUnits.firstWhere((u) => u.symbol == '°C');
       Unit f = provider.currentUnits.firstWhere((u) => u.symbol == '°F');
       
       // 0 C = 32 F
       provider.setFromUnit(c);
       provider.setToUnit(f);
       provider.setInputValue(0);
       expect(provider.resultValue, closeTo(32.0, 1e-9));
       
       // 100 C = 212 F
       provider.setInputValue(100);
       expect(provider.resultValue, closeTo(212.0, 1e-9));
    });
  });
}
