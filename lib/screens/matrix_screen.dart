import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/matrix_model.dart';
import '../providers/matrix_provider.dart';

class MatrixScreen extends StatelessWidget {
  const MatrixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MatrixProvider>(
      builder: (context, matrixProvider, child) {
        return Column(
          children: [
            // Toolbar
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: OverflowBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showAddMatrixDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Matrix'),
                  ),
                   ElevatedButton.icon(
                    onPressed: matrixProvider.clearMatrices,
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Clear All'),
                  ),
                ],
              ),
            ),
             if (matrixProvider.error != null)
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.red.shade100,
                child: Text(
                  matrixProvider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Result Display
            if (matrixProvider.resultMatrix != null)
              Card(
                color: Colors.grey.shade900, // Dark background for white text visibility
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Result', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildMatrixView(matrixProvider.resultMatrix!),
                    ],
                  ),
                ),
              ),
            
            // List of Matrices
            Expanded(
              child: ListView.builder(
                itemCount: matrixProvider.matrices.length,
                itemBuilder: (context, index) {
                  final matrix = matrixProvider.matrices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Matrix ${String.fromCharCode(65 + index)}', 
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: () => matrixProvider.removeMatrix(index),
                              )
                            ],
                          ),
                          _buildMatrixView(matrix),
                          const Divider(),
                          // Matrix Options
                          Wrap(
                            spacing: 8,
                            children: [
                              TextButton(
                                onPressed: () => matrixProvider.performDeterminant(index),
                                child: const Text('Det'),
                              ),
                              TextButton(
                                onPressed: () => matrixProvider.performInverse(index),
                                child: const Text('Inv'),
                              ),
                              TextButton(
                                onPressed: () => matrixProvider.performTranspose(index),
                                child: const Text('T'),
                              ),
                              TextButton(
                                onPressed: () => _showScalarDialog(context, index),
                                child: const Text('* Scalar'),
                              ),
                               // Operations with other matrices
                              PopupMenuButton<int>(
                                child: const TextButton(onPressed: null, child: Text('+ Matrix...')),
                                onSelected: (otherIndex) => matrixProvider.performAddition(index, otherIndex),
                                itemBuilder: (context) => List.generate(matrixProvider.matrices.length, (i) => 
                                  PopupMenuItem(value: i, child: Text('Matrix ${String.fromCharCode(65 + i)}'))
                                ),
                              ),
                               PopupMenuButton<int>(
                                child: const TextButton(onPressed: null, child: Text('- Matrix...')),
                                onSelected: (otherIndex) => matrixProvider.performSubtraction(index, otherIndex),
                                itemBuilder: (context) => List.generate(matrixProvider.matrices.length, (i) => 
                                  PopupMenuItem(value: i, child: Text('Matrix ${String.fromCharCode(65 + i)}'))
                                ),
                              ),
                               PopupMenuButton<int>(
                                child: const TextButton(onPressed: null, child: Text('* Matrix...')),
                                onSelected: (otherIndex) => matrixProvider.performMultiplication(index, otherIndex),
                                itemBuilder: (context) => List.generate(matrixProvider.matrices.length, (i) => 
                                  PopupMenuItem(value: i, child: Text('Matrix ${String.fromCharCode(65 + i)}'))
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMatrixView(Matrix matrix) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade700), // Darker border
      children: matrix.data.map((row) {
        return TableRow(
          children: row.map((cell) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Text(
                  cell.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), ''),
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  void _showAddMatrixDialog(BuildContext context) {
    int rows = 2;
    int cols = 2;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Matrix'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Rows: '),
                  DropdownButton<int>(
                    value: rows,
                    items: [1, 2, 3, 4, 5].map((e) => DropdownMenuItem(value: e, child: Text('$e'))).toList(),
                    onChanged: (v) => setState(() => rows = v!),
                  ),
                  const SizedBox(width: 20),
                  const Text('Cols: '),
                  DropdownButton<int>(
                    value: cols,
                    items: [1, 2, 3, 4, 5].map((e) => DropdownMenuItem(value: e, child: Text('$e'))).toList(),
                    onChanged: (v) => setState(() => cols = v!),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMatrixValueInput(context, rows, cols);
            }, 
            child: const Text('Next')
          ),
        ],
      ),
    );
  }

  void _showMatrixValueInput(BuildContext context, int rows, int cols) {
    List<List<TextEditingController>> controllers = List.generate(
      rows, (i) => List.generate(cols, (j) => TextEditingController(text: '0')));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Values ($rows x $cols)'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(rows, (i) => 
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(cols, (j) => 
                  Container(
                    width: 50,
                    margin: const EdgeInsets.all(2),
                    child: TextField(
                      controller: controllers[i][j],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      // High contrast style
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade600)),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      ),
                    ),
                  )
                ),
              )
            ),
          ),
        ),
        actions: [
           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
           ElevatedButton(
            onPressed: () {
               try {
                 List<List<double>> data = List.generate(rows, (i) => 
                  List.generate(cols, (j) => double.parse(controllers[i][j].text)));
                 
                 context.read<MatrixProvider>().addMatrix(Matrix(rows, cols, data));
                 Navigator.pop(context);
               } catch (e) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid input')));
               }
            }, 
            child: const Text('Save')
          ),
        ],
      ),
    );
  }

  void _showScalarDialog(BuildContext context, int matrixIndex) {
    final controller = TextEditingController();
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Multiply by Scalar'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Scalar Value'),
        ),
         actions: [
           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
           ElevatedButton(
            onPressed: () {
               try {
                 double scalar = double.parse(controller.text);
                 context.read<MatrixProvider>().performScalarMultiplication(matrixIndex, scalar);
                 Navigator.pop(context);
               } catch (e) {
                  // ignore
               }
            }, 
            child: const Text('Multiply')
          ),
        ],
      ),
     );
  }
}
