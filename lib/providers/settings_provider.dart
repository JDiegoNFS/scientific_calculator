import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/settings_model.dart';
import '../services/data_persistence_service.dart';
import '../providers/calculator_provider.dart';
import 'dart:convert';

class SettingsProvider with ChangeNotifier {
  SettingsModel _settings = const SettingsModel();
  // We'll need access to persistence. 
  // For now, let's assume we can pass it or use a singleton/service locator pattern if not passed in constructor.
  // Given previous patterns, we pass persistence service in constructor for ThemeProvider, let's look at main.dart later.
  // Actually, for simplicity in this iteration, we'll implement basic in-memory or mock persistence 
  // and set up the integration structure. 
  // *Correction*: usage of DataPersistenceService is cleaner.
  
  final DataPersistenceService _persistence;

  SettingsProvider(this._persistence) {
    _loadSettings();
  }

  SettingsModel get settings => _settings;

  Future<void> _loadSettings() async {
    final String? jsonStr = _persistence.getSetting('app_settings');
    if (jsonStr != null) {
      try {
        _settings = SettingsModel.fromJson(jsonDecode(jsonStr));
      } catch (e) {
        debugPrint('Failed to load settings: $e');
      }
    }
  }

  void updateSettings(SettingsModel newSettings) {
    _settings = newSettings;
    notifyListeners();
    _saveSettings();
  }

  void setPrecision(int precision) {
    updateSettings(_settings.copyWith(precision: precision));
  }

  void setVibration(bool enabled) {
    updateSettings(_settings.copyWith(vibrationEnabled: enabled));
  }

  void setDefaultMode(CalculatorMode mode) {
    updateSettings(_settings.copyWith(defaultMode: mode));
  }

  Future<void> _saveSettings() async {
    String jsonStr = jsonEncode(_settings.toJson());
    await _persistence.saveSetting('app_settings', jsonStr);
  }

  // Backup & Restore
  String exportSettings() {
    return jsonEncode(_settings.toJson());
  }

  void importSettings(String jsonString) {
    try {
      final map = jsonDecode(jsonString);
      _settings = SettingsModel.fromJson(map);
      notifyListeners();
      _saveSettings();
    } catch (e) {
      debugPrint('Error importing settings: $e');
      rethrow;
    }
  }
}
