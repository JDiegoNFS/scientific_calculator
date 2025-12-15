import 'package:flutter/material.dart';

class ThemeConfiguration {
  final ThemeMode mode;
  final int seedColorValue;
  final double fontSize;
  final String? fontFamily;
  final bool useSystemFont;

  const ThemeConfiguration({
    this.mode = ThemeMode.dark, // Default to Dark as requested
    this.seedColorValue = 0xFF2563EB, // Brighter Blue for contrast
    this.fontSize = 18.0,
    this.fontFamily,
    this.useSystemFont = true,
  });

  factory ThemeConfiguration.fromJson(Map<String, dynamic> json) {
    return ThemeConfiguration(
      mode: ThemeMode.values[json['mode'] as int? ?? 1], // Default json fallback to Dark (1)
      seedColorValue: json['seedColorValue'] as int? ?? 0xFF2563EB,
      fontSize: (json['fontSize'] as num? ?? 18.0).toDouble(),
      fontFamily: json['fontFamily'] as String?,
      useSystemFont: json['useSystemFont'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.index,
      'seedColorValue': seedColorValue,
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'useSystemFont': useSystemFont,
    };
  }

  ThemeConfiguration copyWith({
    ThemeMode? mode,
    int? seedColorValue,
    double? fontSize,
    String? fontFamily,
    bool? useSystemFont,
  }) {
    return ThemeConfiguration(
      mode: mode ?? this.mode,
      seedColorValue: seedColorValue ?? this.seedColorValue,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      useSystemFont: useSystemFont ?? this.useSystemFont,
    );
  }


  // Helper to generate ColorScheme
  ColorScheme get lightScheme => ColorScheme.fromSeed(
    seedColor: Color(seedColorValue),
    brightness: Brightness.light,
    // Add distinct surface for light mode to avoid "all white"
    surface: const Color(0xFFF1F5F9), // Slate 100
    background: const Color(0xFFE2E8F0), // Slate 200
  );

  ColorScheme get darkScheme => ColorScheme.fromSeed(
    seedColor: Color(seedColorValue),
    brightness: Brightness.dark,
    primary: Color(seedColorValue),
    onPrimary: Colors.white,
    // "Botones plomo oscuro" (Dark Lead/Grey)
    secondary: const Color(0xFF475569), // Slate 600
    onSecondary: Colors.white,
    // Backgrounds
    surface: const Color(0xFF1E293B), // Slate 800 (Button background usually)
    background: const Color(0xFF0F172A), // Slate 900 (Screen background)
    surfaceVariant: const Color(0xFF334155), // Lighter slate for specialized containers
  );
}
