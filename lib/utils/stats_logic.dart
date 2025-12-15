import 'dart:math';

class StatsLogic {
  final List<double> data;

  StatsLogic(this.data);

  // Sort data helper
  List<double> get _sortedData => List.from(data)..sort();

  double get mean {
    if (data.isEmpty) return 0.0;
    return data.reduce((a, b) => a + b) / data.length;
  }

  double get median {
    if (data.isEmpty) return 0.0;
    var sorted = _sortedData;
    int mid = sorted.length ~/ 2;
    if (sorted.length % 2 == 1) {
      return sorted[mid];
    } else {
      return (sorted[mid - 1] + sorted[mid]) / 2;
    }
  }

  List<double> get mode {
    if (data.isEmpty) return [];
    Map<double, int> frequency = {};
    for (var x in data) {
      frequency[x] = (frequency[x] ?? 0) + 1;
    }
    int maxFreq = frequency.values.reduce(max);
    if (maxFreq == 1 && data.length > 1) return []; // No mode if all unique? Convention varies.
    return frequency.entries
        .where((e) => e.value == maxFreq)
        .map((e) => e.key)
        .toList();
  }

  double get sampleVariance {
    if (data.length < 2) return 0.0;
    double m = mean;
    double sum = data.map((x) => pow(x - m, 2).toDouble()).reduce((a, b) => a + b);
    return sum / (data.length - 1);
  }

  double get populationVariance {
    if (data.isEmpty) return 0.0;
    double m = mean;
    double sum = data.map((x) => pow(x - m, 2).toDouble()).reduce((a, b) => a + b);
    return sum / data.length;
  }

  double get sampleStdDev => sqrt(sampleVariance);
  double get populationStdDev => sqrt(populationVariance);

  double get minVal => data.isEmpty ? 0.0 : data.reduce(min);
  double get maxVal => data.isEmpty ? 0.0 : data.reduce(max);
  double get range => maxVal - minVal;

  double get sum => data.isEmpty ? 0.0 : data.reduce((a, b) => a + b);
  int get count => data.length;

  double get geometricMean {
    if (data.isEmpty) return 0.0;
    // Use log sum for numerical stability: exp(sum(ln(x))/n)
    // Warning: requires positive calculations
    if (data.any((x) => x <= 0)) return double.nan; 
    double logSum = data.map((x) => log(x)).reduce((a, b) => a + b);
    return exp(logSum / data.length);
  }

  double get harmonicMean {
     if (data.isEmpty) return 0.0;
     if (data.any((x) => x == 0)) return 0.0;
     double sumReciprocals = data.map((x) => 1/x).reduce((a, b) => a + b);
     return data.length / sumReciprocals;
  }
}
