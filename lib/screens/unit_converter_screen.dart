import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/unit_provider.dart';
import '../models/unit_model.dart';

class UnitConverterScreen extends StatelessWidget {
  const UnitConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UnitProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category Selection
              DropdownButtonFormField<UnitCategory>(
                value: provider.category,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: UnitCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) provider.setCategory(val);
                },
              ),
              const SizedBox(height: 20),

              // From Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'From Value', border: OutlineInputBorder()),
                      onChanged: (val) {
                         if (val.isNotEmpty) {
                           provider.setInputValue(double.tryParse(val) ?? 0.0);
                         }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<Unit>(
                      value: provider.fromUnit,
                      isExpanded: true,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: provider.currentUnits.map((u) {
                        return DropdownMenuItem(value: u, child: Text('${u.name} (${u.symbol})'));
                      }).toList(),
                      onChanged: (u) => provider.setFromUnit(u),
                    ),
                  ),
                ],
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Icon(Icons.arrow_downward)),
              ),

              // To Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text(
                        provider.resultValue.toStringAsFixed(4),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<Unit>(
                      value: provider.toUnit,
                      isExpanded: true,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: provider.currentUnits.map((u) {
                        return DropdownMenuItem(value: u, child: Text('${u.name} (${u.symbol})'));
                      }).toList(),
                      onChanged: (u) => provider.setToUnit(u),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
