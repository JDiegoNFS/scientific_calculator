import 'package:flutter/material.dart';
import '../models/theme_configuration.dart';
import '../services/data_persistence_service.dart';

class ThemeProvider extends ChangeNotifier {
  final DataPersistenceService _persistenceService;
  late ThemeConfiguration _configuration;

  static const String _themeSettingsKey = 'theme_settings';

  ThemeProvider(this._persistenceService) {
    _configuration = const ThemeConfiguration(); // Default
    _loadSettings();
  }

  ThemeConfiguration get configuration => _configuration;
  ThemeMode get themeMode => _configuration.mode;
  double get fontSize => _configuration.fontSize;

  ColorScheme get lightScheme => _configuration.lightScheme;
  ColorScheme get darkScheme => _configuration.darkScheme;

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: lightScheme,
    scaffoldBackgroundColor: lightScheme.background,
    textTheme: _getTextTheme(),
    fontFamily: _configuration.fontFamily,
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: darkScheme,
    scaffoldBackgroundColor: darkScheme.background,
    textTheme: _getTextTheme(),
    fontFamily: _configuration.fontFamily,
  );

  TextTheme _getTextTheme() {
    // Basic scaling logic
    final scale = _configuration.fontSize / 18.0; // Base size
    return TextTheme(
      displayLarge: TextStyle(fontSize: 48 * scale, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 36 * scale, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 18 * scale),
      bodyMedium: TextStyle(fontSize: 16 * scale),
    );
  }

  void _loadSettings() {
    final stored = _persistenceService.getSetting(_themeSettingsKey);
    if (stored != null) {
      try {
        // Handle Map<dynamic, dynamic> from Hive
        final Map<String, dynamic> json = Map<String, dynamic>.from(stored as Map);
        _configuration = ThemeConfiguration.fromJson(json);
      } catch (e) {
        debugPrint('Error loading theme settings: $e');
      }
    }
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    await _persistenceService.saveSetting(_themeSettingsKey, _configuration.toJson());
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _configuration = _configuration.copyWith(mode: mode);
    await _saveSettings();
  }

  Future<void> setSeedColor(Color color) async {
    _configuration = _configuration.copyWith(seedColorValue: color.value);
    await _saveSettings();
  }

  Future<void> setFontSize(double size) async {
    _configuration = _configuration.copyWith(fontSize: size);
    await _saveSettings();
  }
}
