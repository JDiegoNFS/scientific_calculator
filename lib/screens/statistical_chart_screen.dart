import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/calculator_provider.dart';
import '../utils/stats_logic.dart';
import '../utils/regression_logic.dart';
import 'dart:math';

class StatisticalChartScreen extends StatelessWidget {
  const StatisticalChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Statistical Charts'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Histogram (1D)'),
              Tab(text: 'Regression (2D)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HistogramView(),
            RegressionView(),
          ],
        ),
      ),
    );
  }
}

class HistogramView extends StatelessWidget {
  const HistogramView({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CalculatorProvider>();
    var data = provider.statsData;

    if (data.isEmpty) {
      return const Center(child: Text('No data for histogram'));
    }

    // Simple Histogram Binning
    int binCount = max(5, sqrt(data.length).ceil());
    double minVal = data.reduce(min);
    double maxVal = data.reduce(max);
    double range = maxVal - minVal;
    if (range == 0) range = 1;
    double binWidth = range / binCount;

    List<int> bins = List.filled(binCount, 0);
    for (var x in data) {
      int binIdx = ((x - minVal) / binWidth).floor();
      if (binIdx >= binCount) binIdx = binCount - 1;
      bins[binIdx]++;
    }
    
    int maxFreq = bins.reduce(max);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          barGroups: List.generate(binCount, (i) {
             return BarChartGroupData(
               x: i,
               barRods: [
                 BarChartRodData(
                   toY: bins[i].toDouble(), 
                   color: Colors.blueAccent, 
                   width: 16
                 )
               ]
             );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  int idx = val.toInt();
                  if (idx >= 0 && idx < binCount) {
                     double binCenter = minVal + (idx + 0.5) * binWidth;
                     return Text(binCenter.toStringAsFixed(1), style: const TextStyle(fontSize: 10));
                  }
                  return const SizedBox.shrink();
                }
              )
            ),
             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          maxY: maxFreq.toDouble() + 1,
        ),
      ),
    );
  }
}

class RegressionView extends StatelessWidget {
  const RegressionView({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CalculatorProvider>();
    var xData = provider.statsDataX;
    var yData = provider.statsDataY;

    if (xData.isEmpty || xData.length != yData.length) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No paired data for regression'),
           const SizedBox(height: 20),
           ElevatedButton(
             onPressed: () => _showAddPairDialog(context),
             child: const Text('Add Data Pair')
           )
        ],
      );
    }
    
    var regression = RegressionLogic(xData, yData);
    double slope = regression.slope;
    double intercept = regression.intercept;
    double r2 = regression.rSquared;
    
    // Line points
    double minX = xData.reduce(min);
    double maxX = xData.reduce(max);
    double padding = (maxX - minX) * 0.1;
    if (padding == 0) padding = 1;
    
    List<FlSpot> lineSpots = [
      FlSpot(minX - padding, regression.predict(minX - padding)),
      FlSpot(maxX + padding, regression.predict(maxX + padding)),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('y = ${slope.toStringAsFixed(3)}x + ${intercept.toStringAsFixed(3)}\nR² = ${r2.toStringAsFixed(4)}'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  // Regression Line
                  LineChartBarData(
                    spots: lineSpots,
                    color: Colors.red,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  // Scatter Points (represented as a line with dots and invisible line)
                  LineChartBarData(
                    spots: List.generate(xData.length, (i) => FlSpot(xData[i], yData[i])),
                    color: Colors.blue,
                    barWidth: 0, // invisible line
                    dotData: const FlDotData(show: true),
                  ),
                ],
                 titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              )
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
             onPressed: () => _showAddPairDialog(context),
             child: const Text('Add Pair')
           ),
           ElevatedButton(
             onPressed: () => provider.clearStats(), // Clears both! Warning to user?
             style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
             child: const Text('Clear All')
           ),
          ],
        )
      ],
    );
  }
  
  void _showAddPairDialog(BuildContext context) {
    TextEditingController xCtrl = TextEditingController();
    TextEditingController yCtrl = TextEditingController();
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Data Pair'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: xCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'X Value')),
            TextField(controller: yCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Y Value')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
               try {
                 double x = double.parse(xCtrl.text);
                 double y = double.parse(yCtrl.text);
                 context.read<CalculatorProvider>().addBivariateData(x, y);
                 Navigator.pop(context);
               } catch (e) {
                 // ignore
               }
            }, 
            child: const Text('Add')
          ),
        ],
      )
    );
  }
}
