import 'package:flutter/foundation.dart';
import '../models/matrix_model.dart';

class MatrixProvider with ChangeNotifier {
  List<Matrix> _matrices = [];
  Matrix? _resultMatrix;
  String? _error;

  List<Matrix> get matrices => _matrices;
  Matrix? get resultMatrix => _resultMatrix;
  String? get error => _error;

  void addMatrix(Matrix matrix) {
    _matrices.add(matrix);
    notifyListeners();
  }
  
  void removeMatrix(int index) {
    if (index >= 0 && index < _matrices.length) {
      _matrices.removeAt(index);
      notifyListeners();
    }
  }

  void clearMatrices() {
    _matrices.clear();
    _resultMatrix = null;
    _error = null;
    notifyListeners();
  }

  void performAddition(int indexA, int indexB) {
    _tryOperation(() {
      _resultMatrix = _matrices[indexA] + _matrices[indexB];
    });
  }

  void performSubtraction(int indexA, int indexB) {
    _tryOperation(() {
      _resultMatrix = _matrices[indexA] - _matrices[indexB];
    });
  }

  void performMultiplication(int indexA, int indexB) {
    _tryOperation(() {
      _resultMatrix = _matrices[indexA] * _matrices[indexB];
    });
  }

  void performScalarMultiplication(int index, double scalar) {
     _tryOperation(() {
      _resultMatrix = _matrices[index] * scalar;
    });
  }

  void performDeterminant(int index) {
      // Determinant returns a double, but our result is a matrix.
      // We can represent it as a 1x1 matrix or handle it differently.
      // For now, let's treat it as an error or special case in UI, 
      // but strictly strict types might want a flexible result container.
      // Let's store it as a 1x1 matrix for consistency in this simple version.
     _tryOperation(() {
      double det = _matrices[index].determinant;
      _resultMatrix = Matrix(1, 1, [[det]]);
    });
  }

  void performInverse(int index) {
    _tryOperation(() {
      _resultMatrix = _matrices[index].inverse;
    });
  }

  void performTranspose(int index) {
    _tryOperation(() {
      _resultMatrix = _matrices[index].transpose();
    });
  }

  void _tryOperation(VoidCallback operation) {
    try {
      _error = null;
      operation();
    } catch (e) {
      _error = e.toString();
      _resultMatrix = null;
    }
    notifyListeners();
  }
}
