import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';

class DisplayArea extends StatelessWidget {
  const DisplayArea({super.key});

  @override
  Widget build(BuildContext context) {
    var p = context.watch<CalculatorProvider>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              p.expression.isEmpty ? '0' : p.expression,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white54,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            p.result,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
