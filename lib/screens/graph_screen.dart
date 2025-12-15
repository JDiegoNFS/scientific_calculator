import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/graph_provider.dart';
import '../models/math_function.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final TextEditingController _controller = TextEditingController();

  void _addFunction() {
    if (_controller.text.isNotEmpty) {
      context.read<GraphProvider>().addFunction(
        _controller.text, 
        Colors.primaries[
          context.read<GraphProvider>().functions.length % Colors.primaries.length
        ]
      );
      _controller.clear();
    }
  }

  void _insertText(String text) {
    // Insert at cursor or append
    final textVal = _controller.text;
    final selection = _controller.selection;
    
    if (selection.isValid && selection.start >= 0) {
      final newText = textVal.replaceRange(selection.start, selection.end, text);
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start + text.length),
      );
    } else {
      _controller.text += text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Function Input Area
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'f(x) =',
                    hintText: 'e.g., sin(x), x^2, x + 5',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _addFunction(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _addFunction,
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () => context.read<GraphProvider>().clearFunctions(),
              )
            ],
          ),
        ),

        // Quick Function Shortcuts
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              _buildShortcut('sin('),
              _buildShortcut('cos('),
              _buildShortcut('tan('),
              _buildShortcut('x^2'),
              _buildShortcut('sqrt('),
              _buildShortcut('log('),
              _buildShortcut('('),
              _buildShortcut(')'),
              _buildShortcut('x'),
              _buildShortcut('+'),
              _buildShortcut('-'),
              _buildShortcut('*'),
              _buildShortcut('/'),
            ],
          ),
        ),
        
        // Active Functions List
        Consumer<GraphProvider>(
          builder: (context, graphProvider, _) {
            return SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: graphProvider.functions.length,
                itemBuilder: (context, index) {
                  final func = graphProvider.functions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Chip(
                      label: Text(func.expression),
                      backgroundColor: func.color?.withOpacity(0.2),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () => graphProvider.removeFunction(index),
                      side: BorderSide(color: func.color ?? Colors.grey),
                    ),
                  );
                },
              ),
            );
          },
        ),

        // Chart Area
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<GraphProvider>(
              builder: (context, graphProvider, _) {
                return LineChart(
                  LineChartData(
                    lineBarsData: graphProvider.functions.map((func) {
                      return LineChartBarData(
                        spots: graphProvider.generatePoints(func),
                        isCurved: true,
                        color: func.color ?? Colors.blue,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                      );
                    }).toList(),
                    minX: graphProvider.minX,
                    maxX: graphProvider.maxX,
                    minY: graphProvider.minY,
                    maxY: graphProvider.maxY,
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    titlesData: const FlTitlesData(
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineTouchData: const LineTouchData(enabled: true), 
                  ),
                );
              },
            ),
          ),
        ),
        
        // Zoom Controls
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () {
                   var p = context.read<GraphProvider>();
                   p.updateViewport(
                     minX: p.minX + 2, maxX: p.maxX - 2, 
                     minY: p.minY + 2, maxY: p.maxY - 2
                   );
                },
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () {
                   var p = context.read<GraphProvider>();
                   p.updateViewport(
                     minX: p.minX - 2, maxX: p.maxX + 2, 
                     minY: p.minY - 2, maxY: p.maxY + 2
                   );
                },
              ),
               IconButton(
                icon: const Icon(Icons.center_focus_strong),
                onPressed: () {
                   context.read<GraphProvider>().updateViewport(
                     minX: -10, maxX: 10, minY: -10, maxY: 10
                   );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildShortcut(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: ActionChip(
        label: Text(text),
        backgroundColor: Colors.grey.shade800,
        labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        onPressed: () => _insertText(text),
      ),
    );
  }
}
