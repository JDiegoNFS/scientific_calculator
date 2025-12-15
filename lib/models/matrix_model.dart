import 'package:flutter/foundation.dart';

class Matrix {
  final int rows;
  final int cols;
  final List<List<double>> data;

  Matrix(this.rows, this.cols, this.data) {
    if (data.length != rows || data.any((row) => row.length != cols)) {
      throw ArgumentError('Data dimensions do not match specified rows and columns.');
    }
  }

  factory Matrix.zero(int rows, int cols) {
    return Matrix(
      rows,
      cols,
      List.generate(rows, (_) => List.filled(cols, 0.0)),
    );
  }

  factory Matrix.identity(int size) {
    return Matrix(
      size,
      size,
      List.generate(size, (i) => List.generate(size, (j) => i == j ? 1.0 : 0.0)),
    );
  }

  Matrix operator +(Matrix other) {
    if (rows != other.rows || cols != other.cols) {
      throw ArgumentError('Matrices must have the same dimensions for addition.');
    }
    return Matrix(
      rows,
      cols,
      List.generate(rows, (i) => List.generate(cols, (j) => data[i][j] + other.data[i][j])),
    );
  }

  Matrix operator -(Matrix other) {
    if (rows != other.rows || cols != other.cols) {
      throw ArgumentError('Matrices must have the same dimensions for subtraction.');
    }
    return Matrix(
      rows,
      cols,
      List.generate(rows, (i) => List.generate(cols, (j) => data[i][j] - other.data[i][j])),
    );
  }

  Matrix operator *(dynamic other) {
    if (other is double || other is int) {
      double scalar = other.toDouble();
      return Matrix(
        rows,
        cols,
        List.generate(rows, (i) => List.generate(cols, (j) => data[i][j] * scalar)),
      );
    } else if (other is Matrix) {
      if (cols != other.rows) {
        throw ArgumentError('Number of columns in first matrix must equal number of rows in second matrix.');
      }
      return Matrix(
        rows,
        other.cols,
        List.generate(rows, (i) {
          return List.generate(other.cols, (j) {
            double sum = 0.0;
            for (int k = 0; k < cols; k++) {
              sum += data[i][k] * other.data[k][j];
            }
            return sum;
          });
        }),
      );
    } else {
      throw ArgumentError('Multiplication not supported for type ${other.runtimeType}');
    }
  }

  Matrix transpose() {
    return Matrix(
      cols,
      rows,
      List.generate(cols, (i) => List.generate(rows, (j) => data[j][i])),
    );
  }

  double get determinant {
    if (rows != cols) {
      throw ArgumentError('Determinant can only be calculated for square matrices.');
    }
    if (rows == 1) return data[0][0];
    if (rows == 2) return data[0][0] * data[1][1] - data[0][1] * data[1][0];

    double det = 0.0;
    for (int i = 0; i < cols; i++) {
      det += (i % 2 == 0 ? 1 : -1) * data[0][i] * _minor(0, i).determinant;
    }
    return det;
  }

  Matrix get inverse {
    double det = determinant;
    if (det == 0) {
      throw ArgumentError('Matrix is singular and cannot be inverted.');
    }
    
    // Adjugate matrix / determinant
    Matrix cofactorMatrix = Matrix(
      rows,
      cols,
      List.generate(rows, (i) => List.generate(cols, (j) {
        return ((((i + j) % 2 == 0) ? 1 : -1) * _minor(i, j).determinant);
      })),
    );

    return cofactorMatrix.transpose() * (1 / det);
  }

  Matrix _minor(int row, int col) {
    return Matrix(
      rows - 1,
      cols - 1,
      data
          .asMap()
          .entries
          .where((e) => e.key != row)
          .map((e) => e.value.asMap().entries.where((e) => e.key != col).map((e) => e.value).toList())
          .toList(),
    );
  }
  
  @override
  String toString() {
    return data.map((row) => row.join('\t')).join('\n');
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Matrix && listEquals(data, other.data); // Simplified check
  }

  @override
  int get hashCode => data.hashCode;

  // Helper for deep equality check if needed, mostly for tests
  bool equals(Matrix other, {double tolerance = 1e-9}) {
     if (rows != other.rows || cols != other.cols) return false;
     for(int i=0; i<rows; i++) {
       for(int j=0; j<cols; j++) {
         if ((data[i][j] - other.data[i][j]).abs() > tolerance) return false;
       }
     }
     return true;
  }
}
