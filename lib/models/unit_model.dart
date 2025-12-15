enum UnitCategory { length, mass, temperature, time, digitalStorage }

class Unit {
  final String name;
  final String symbol;
  final double factor; // Conversion factor to base unit
  final double offset; // For temperature (e.g. Celsius to Kelvin)

  const Unit({
    required this.name,
    required this.symbol,
    required this.factor,
    this.offset = 0.0,
  });
}

class UnitDefinitions {
  static const Map<UnitCategory, List<Unit>> units = {
    UnitCategory.length: [
      Unit(name: 'Meter', symbol: 'm', factor: 1.0),
      Unit(name: 'Kilometer', symbol: 'km', factor: 1000.0),
      Unit(name: 'Centimeter', symbol: 'cm', factor: 0.01),
      Unit(name: 'Millimeter', symbol: 'mm', factor: 0.001),
      Unit(name: 'Inch', symbol: 'in', factor: 0.0254),
      Unit(name: 'Foot', symbol: 'ft', factor: 0.3048),
      Unit(name: 'Mile', symbol: 'mi', factor: 1609.34),
    ],
    UnitCategory.mass: [
      Unit(name: 'Kilogram', symbol: 'kg', factor: 1.0),
      Unit(name: 'Gram', symbol: 'g', factor: 0.001),
      Unit(name: 'Milligram', symbol: 'mg', factor: 0.000001),
      Unit(name: 'Pound', symbol: 'lb', factor: 0.453592),
      Unit(name: 'Ounce', symbol: 'oz', factor: 0.0283495),
    ],
    UnitCategory.temperature: [
      Unit(name: 'Celsius', symbol: '°C', factor: 1.0), 
      Unit(name: 'Fahrenheit', symbol: '°F', factor: 1.0),
      Unit(name: 'Kelvin', symbol: 'K', factor: 1.0),
    ],
     UnitCategory.time: [
      Unit(name: 'Second', symbol: 's', factor: 1.0),
      Unit(name: 'Minute', symbol: 'min', factor: 60.0),
      Unit(name: 'Hour', symbol: 'h', factor: 3600.0),
      Unit(name: 'Day', symbol: 'd', factor: 86400.0),
    ],
  };

  // Temperature logic usually requires custom functions
  static double convertTemperature(double value, String fromSymbol, String toSymbol) {
    // Convert to Celsius first
    double celsius;
    switch (fromSymbol) {
      case '°F': celsius = (value - 32) * 5 / 9; break;
      case 'K': celsius = value - 273.15; break;
      default: celsius = value;
    }
    
    // Convert from Celsius to Target
    switch (toSymbol) {
      case '°F': return celsius * 9 / 5 + 32;
      case 'K': return celsius + 273.15;
      default: return celsius;
    }
  }
}
