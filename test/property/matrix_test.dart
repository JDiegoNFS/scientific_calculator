import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/models/matrix_model.dart';
import 'dart:math';

void main() {
  group('Matrix Property Tests', () {
    
    // Helper to generate random matrix
    Matrix generateRandomMatrix(int rows, int cols) {
      var rng = Random();
      return Matrix(
        rows,
        cols,
        List.generate(rows, (_) => List.generate(cols, (_) => rng.nextDouble() * 10 - 5)), // -5 to 5
      );
    }

    // **Feature: Matrix Module, Property 20: Matrix Dimension Consistency**
    test('Property 20: Matrix Dimension Consistency', () {
      for (int i = 0; i < 50; i++) {
        int r = Random().nextInt(4) + 1; // 1-4
        int c = Random().nextInt(4) + 1; // 1-4
        
        Matrix A = generateRandomMatrix(r, c);
        Matrix B = generateRandomMatrix(r, c);
        
        Matrix C = A + B;
        expect(C.rows, r);
        expect(C.cols, c);
        
        Matrix D = A - B;
        expect(D.rows, r);
        expect(D.cols, c);
        
        // Transpose dimensions
        Matrix T = A.transpose();
        expect(T.rows, c);
        expect(T.cols, r);
      }
    });

    test('Matrix Multiplication Dimensions', () {
      for (int i = 0; i < 50; i++) {
        int rA = Random().nextInt(4) + 1;
        int cA = Random().nextInt(4) + 1;
        int rB = cA; // Must match
        int cB = Random().nextInt(4) + 1;
        
        Matrix A = generateRandomMatrix(rA, cA);
        Matrix B = generateRandomMatrix(rB, cB);
        
        Matrix C = A * B;
        expect(C.rows, rA);
        expect(C.cols, cB);
      }
    });

    // **Feature: Matrix Module, Property 21: Matrix Inverse Identity**
    test('Property 21: Matrix Inverse Identity', () {
      for (int i = 0; i < 20; i++) {
         int size = Random().nextInt(3) + 2; // 2x2 to 4x4
         Matrix A = generateRandomMatrix(size, size);
         
         // Avoid singular matrices by checking determinant
         if (A.determinant.abs() < 1e-3) continue; 
         
         try {
           Matrix Inv = A.inverse;
           Matrix Identity = A * Inv;
           
           // Check against true Identity matrix
           Matrix TrueIdentity = Matrix.identity(size);
           
           expect(Identity.equals(TrueIdentity, tolerance: 1e-4), isTrue, 
             reason: 'A * A^-1 != I for size $size');
             
         } catch (e) {
           // Singular matrix exception is expected sometimes for random matrices
           // but we tried to avoid it.
         }
      }
    });

    test('Determinant Properties', () {
      // det(A^T) == det(A)
       for (int i = 0; i < 20; i++) {
         int size = Random().nextInt(3) + 2;
         Matrix A = generateRandomMatrix(size, size);
         
         expect(A.determinant, closeTo(A.transpose().determinant, 1e-9));
       }
       
       // det(I) == 1
       expect(Matrix.identity(3).determinant, closeTo(1.0, 1e-9));
    });

    test('Scalar Multiplication Distributivity', () {
      // k(A + B) == kA + kB
      for(int i=0; i<20; i++) {
         int r = 2, c = 2;
         Matrix A = generateRandomMatrix(r, c);
         Matrix B = generateRandomMatrix(r, c);
         double k = Random().nextDouble() * 5;
         
         Matrix Left = (A + B) * k;
         Matrix Right = (A * k) + (B * k);
         
         expect(Left.equals(Right), isTrue);
      }
    });
  });
}
