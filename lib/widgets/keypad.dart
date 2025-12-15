import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';

class Keypad extends StatelessWidget {
  const Keypad({super.key});

  @override
  Widget build(BuildContext context) {
    bool isSci = context.watch<CalculatorProvider>().mode == CalculatorMode.scientific;

    // Define buttons. 
    // Format: [Label, Function] (Function can be null for default add)
    final List<List<String>> basicButtons = [
      ['AC', '(', ')', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', 'DEL', '='],
    ];

    final List<List<String>> sciButtons = [
      ['sin()', 'cos()', 'tan()', 'log()', 'ln()'],
      ['^', 'sqrt()', 'pi', 'e', 'inv'], 
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          if (isSci) ...[
            // Scientific Rows
             for (var row in sciButtons)
              Expanded(
                child: Row(
                  children: row.map((e) => _buildButton(context, e, isSci: true)).toList(),
                ),
              ),
          ],
           // Spacer between sci and basic
          if (isSci) const Divider(height: 1),
          // Basic Rows
          for (var row in basicButtons)
            Expanded(
              child: Row(
                children: row.map((e) => _buildButton(context, e)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, {bool isSci = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: isSci ? Colors.white10 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () => _handlePress(context, label),
            child: Center(
              child: Text(
                label == 'sqrt()' ? '√' : label.replaceAll('()', ''),
                style: TextStyle(
                  fontSize: isSci ? 18 : 24,
                  fontWeight: isSci ? FontWeight.normal : FontWeight.bold,
                  color: _getBtnColor(context, label),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBtnColor(BuildContext context, String label) {
    if (['AC', 'DEL'].contains(label)) return Colors.redAccent;
    if (['=', '×', '÷', '-', '+'].contains(label)) return Theme.of(context).colorScheme.primary;
    return Colors.white;
  }

  void _handlePress(BuildContext context, String label) {
    var p = context.read<CalculatorProvider>();
    switch (label) {
      case 'AC':
        p.clearHelper();
        break;
      case 'DEL':
        p.deleteLast();
        break;
      case '=':
        p.evaluate();
        break;
      case 'pi':
        p.addToExpression('π');
        break;
      case 'sqrt()':
        p.addToExpression('sqrt(');
        break;
      case 'log()':
         p.addToExpression('log(10,'); // Base 10? math_expressions log is natural? standard is log10
         // wait, logic check: math_expressions log(x) is ln(x), log(b, x) is base b.
         // standard calc log is base 10. ln is base e.
         // Let's assume log() -> log(10, 
         break;
       case 'ln()':
         p.addToExpression('ln(');
         break;
       case 'sin()':
       case 'cos()':
       case 'tan()':
         p.addToExpression('${label.replaceAll("()", "")}(');
         break;
      default:
        p.addToExpression(label);
    }
  }
}
