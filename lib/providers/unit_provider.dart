import 'package:flutter/foundation.dart';
import '../models/unit_model.dart';

class UnitProvider with ChangeNotifier {
  UnitCategory _category = UnitCategory.length;
  Unit? _fromUnit;
  Unit? _toUnit;
  double _inputValue = 0.0;
  double _resultValue = 0.0;

  UnitCategory get category => _category;
  Unit? get fromUnit => _fromUnit;
  Unit? get toUnit => _toUnit;
  double get inputValue => _inputValue;
  double get resultValue => _resultValue;
  
  List<Unit> get currentUnits => UnitDefinitions.units[_category] ?? [];

  UnitProvider() {
     _initUnits();
  }

  void _initUnits() {
    var units = currentUnits;
    if (units.isNotEmpty) {
      _fromUnit = units.first;
      _toUnit = units.length > 1 ? units[1] : units.first;
    }
  }

  void setCategory(UnitCategory cat) {
    if (_category != cat) {
      _category = cat;
      _initUnits();
      calculate();
    }
  }

  void setFromUnit(Unit? unit) {
    _fromUnit = unit;
    calculate();
  }

  void setToUnit(Unit? unit) {
    _toUnit = unit;
    calculate();
  }

  void setInputValue(double value) {
    _inputValue = value;
    calculate();
  }

  void calculate() {
    if (_fromUnit == null || _toUnit == null) return;
    
    if (_category == UnitCategory.temperature) {
      _resultValue = UnitDefinitions.convertTemperature(
        _inputValue, 
        _fromUnit!.symbol, 
        _toUnit!.symbol
      );
    } else {
      // Standard linear conversion: (Value * FromFactor) / ToFactor
      // Base unit is the anchor.
      // e.g. 1 km (1000) -> m (1).  1 * 1000 / 1 = 1000.
      double baseValue = _inputValue * _fromUnit!.factor;
      _resultValue = baseValue / _toUnit!.factor;
    }
    notifyListeners();
  }
}
