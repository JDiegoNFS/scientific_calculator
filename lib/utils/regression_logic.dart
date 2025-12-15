import 'dart:math';

class RegressionLogic {
  final List<double> x;
  final List<double> y;

  RegressionLogic(this.x, this.y) {
    if (x.length != y.length) {
      throw ArgumentError('X and Y lists must have the same length');
    }
  }

  double get meanX => x.isEmpty ? 0 : x.reduce((a, b) => a + b) / x.length;
  double get meanY => y.isEmpty ? 0 : y.reduce((a, b) => a + b) / y.length;

  // Linear Regression: y = mx + c
  double get slope {
    if (x.isEmpty || x.length < 2) return 0.0;
    
    double mx = meanX;
    double my = meanY;
    
    double numerator = 0.0;
    double denominator = 0.0;
    
    for (int i = 0; i < x.length; i++) {
      numerator += (x[i] - mx) * (y[i] - my);
      denominator += pow(x[i] - mx, 2);
    }
    
    if (denominator == 0) return 0.0; // Vertical line or single point
    return numerator / denominator;
  }

  double get intercept {
    return meanY - slope * meanX;
  }

  // Pearson Correlation Coefficient (r)
  double get correlationCoefficient {
    if (x.isEmpty || x.length < 2) return 0.0;

    double mx = meanX;
    double my = meanY;

    double numerator = 0.0;
    double sumSqDiffX = 0.0;
    double sumSqDiffY = 0.0;

    for (int i = 0; i < x.length; i++) {
        double diffX = x[i] - mx;
        double diffY = y[i] - my;
        numerator += diffX * diffY;
        sumSqDiffX += diffX * diffX;
        sumSqDiffY += diffY * diffY;
    }

    double denominator = sqrt(sumSqDiffX * sumSqDiffY);
    if (denominator == 0) return 0.0;
    
    return numerator / denominator;
  }
  
  double get rSquared => pow(correlationCoefficient, 2).toDouble();

  double predict(double inputX) {
    return slope * inputX + intercept;
  }
}

class ProbabilityDistributions {
  // Normal Distribution PDF
  static double normalPDF(double x, double mean, double stdDev) {
    if (stdDev <= 0) return 0.0;
    double exponent = -pow(x - mean, 2) / (2 * pow(stdDev, 2));
    return (1 / (stdDev * sqrt(2 * pi))) * exp(exponent);
  }
}
