import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import 'statistical_chart_screen.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  final TextEditingController _controller = TextEditingController();

  void _addData(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      context.read<CalculatorProvider>().addStatData(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var p = context.watch<CalculatorProvider>();
    var stats = p.statsRef;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Input Area
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: const InputDecoration(
                    labelText: 'Enter number(s) comma separated',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _addData(context),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () => _addData(context),
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.clear_all),
                onPressed: () => p.clearStats(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Data List (Collapsible or small)
          ExpansionTile(
            title: Text('Data Points (${p.statsData.length})'),
            children: [
              Wrap(
                spacing: 8,
                children: p.statsData.asMap().entries.map((e) {
                  return Chip(
                    label: Text(e.value.toString()),
                    onDeleted: () => p.removeStatDataAt(e.key),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticalChartScreen()));
            },
            icon: const Icon(Icons.bar_chart),
            label: const Text('View Charts & Regression'),
          ),
          const Divider(),
          // Results
          Expanded(
            child: ListView(
              children: [
                _statRow('Mean', stats.mean.toStringAsFixed(4)),
                _statRow('Median', stats.median.toStringAsFixed(4)),
                _statRow('Mode', stats.mode.isEmpty ? 'None' : stats.mode.join(', ')),
                _statRow('Std Dev (Sample)', stats.sampleStdDev.toStringAsFixed(4)),
                _statRow('Std Dev (Pop)', stats.populationStdDev.toStringAsFixed(4)),
                _statRow('Variance (Sample)', stats.sampleVariance.toStringAsFixed(4)),
                _statRow('Variance (Pop)', stats.populationVariance.toStringAsFixed(4)),
                _statRow('Min', stats.minVal.toString()),
                _statRow('Max', stats.maxVal.toString()),
                _statRow('Range', stats.range.toString()),
                _statRow('Sum', stats.sum.toString()),
                _statRow('Count', stats.count.toString()),
                _statRow('Geo Mean', stats.geometricMean.isNaN ? 'NaN' : stats.geometricMean.toStringAsFixed(4)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(value, style: const TextStyle(color: Colors.blueAccent)),
        ],
      ),
    );
  }
}
