import 'dart:convert';
import '../providers/calculator_provider.dart';

class SettingsModel {
  final int precision;
  final bool vibrationEnabled;
  final CalculatorMode defaultMode;
  // Add more settings as needed

  const SettingsModel({
    this.precision = 10,
    this.vibrationEnabled = true,
    this.defaultMode = CalculatorMode.basic,
  });

  SettingsModel copyWith({
    int? precision,
    bool? vibrationEnabled,
    CalculatorMode? defaultMode,
  }) {
    return SettingsModel(
      precision: precision ?? this.precision,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      defaultMode: defaultMode ?? this.defaultMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'precision': precision,
      'vibrationEnabled': vibrationEnabled,
      'defaultMode': defaultMode.index,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> map) {
    return SettingsModel(
      precision: map['precision'] ?? 10,
      vibrationEnabled: map['vibrationEnabled'] ?? true,
      defaultMode: CalculatorMode.values[map['defaultMode'] ?? 0],
    );
  }
}
