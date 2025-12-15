import 'package:flutter/foundation.dart';

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, Stopwatch> _watches = {};
  final Map<String, int> _thresholds = {}; // in milliseconds

  void start(String label, {int thresholdMs = 16}) {
    _thresholds[label] = thresholdMs;
    final stopwatch = Stopwatch()..start();
    _watches[label] = stopwatch;
  }

  void stop(String label) {
    var stopwatch = _watches[label];
    if (stopwatch != null) {
      stopwatch.stop(); // Stop before reading
      int elapsed = stopwatch.elapsedMilliseconds;
      int threshold = _thresholds[label] ?? 16;
      
      if (elapsed > threshold) {
        debugPrint('[Performance Warning] Operation "$label" took ${elapsed}ms (Threshold: ${threshold}ms)');
      } else {
        // debugPrint('[Performance] "$label": ${elapsed}ms'); // Verbose logging if needed
      }
      _watches.remove(label);
    }
  }
}
