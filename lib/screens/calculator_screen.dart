import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/calculator_provider.dart';
import '../widgets/display_area.dart';
import '../widgets/keypad.dart';
import 'statistics_view.dart';
import 'matrix_screen.dart';
import 'graph_screen.dart';
import 'statistical_chart_screen.dart';
import 'unit_converter_screen.dart';
import 'settings_screen.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CalculatorProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(provider.mode)),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy Result',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: provider.result));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Result copied to clipboard')),
              );
            },
          ),
          PopupMenuButton<dynamic>(
            icon: const Icon(Icons.calculate_outlined),
            onSelected: (value) {
              if (value == 'settings') {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              } else if (value is CalculatorMode) {
                context.read<CalculatorProvider>().setMode(value);
              }
            },
            itemBuilder: (context) => [
               const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: CalculatorMode.basic,
                child: Text('Basic Mode'),
              ),
              const PopupMenuItem(
                value: CalculatorMode.scientific,
                child: Text('Scientific Mode'),
              ),
               const PopupMenuItem(
                value: CalculatorMode.statistics,
                child: Text('Statistics Mode'),
              ),
               const PopupMenuItem(
                value: CalculatorMode.matrix,
                child: Text('Matrix Mode'),
              ),
               const PopupMenuItem(
                value: CalculatorMode.graphing,
                child: Text('Graphing Mode'),
              ),
               const PopupMenuItem(
                value: CalculatorMode.converter,
                child: Text('Unit Converter'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(provider.mode),
      ),
    );
  }

  String _getTitle(CalculatorMode mode) {
    switch (mode) {
      case CalculatorMode.basic: return 'Scientific Calculator';
      case CalculatorMode.scientific: return 'Scientific Mode';
      case CalculatorMode.scientific: return 'Scientific Mode';
      case CalculatorMode.statistics: return 'Statistics Mode';
      case CalculatorMode.matrix: return 'Matrix Calculator';
      case CalculatorMode.graphing: return 'Function Grapher';
      case CalculatorMode.converter: return 'Unit Converter';
    }
  }

  Widget _buildBody(CalculatorMode mode) {
    if (mode == CalculatorMode.statistics) {
      return const StatisticsView();
    }
    if (mode == CalculatorMode.matrix) {
      return const MatrixScreen();
    }
    if (mode == CalculatorMode.graphing) {
      return const GraphScreen();
    }
    if (mode == CalculatorMode.converter) {
      return const UnitConverterScreen();
    }
    
    return const Column(
      children: [
        Expanded(
          flex: 2,
          child: DisplayArea(),
        ),
        Expanded(
          flex: 4,
          child: Keypad(),
        ),
      ],
    );
  }
}
