import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'calculation_entry.g.dart';

@HiveType(typeId: 0)
class CalculationEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String expression;

  @HiveField(2)
  final String result;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final Map<String, dynamic> metadata;

  CalculationEntry({
    String? id,
    required this.expression,
    required this.result,
    required this.timestamp,
    this.metadata = const {},
  }) : id = id ?? const Uuid().v4();

  factory CalculationEntry.fromJson(Map<String, dynamic> json) {
    return CalculationEntry(
      id: json['id'] as String?,
      expression: json['expression'] as String,
      result: json['result'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  CalculationEntry copyWith({
    String? id,
    String? expression,
    String? result,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return CalculationEntry(
      id: id ?? this.id,
      expression: expression ?? this.expression,
      result: result ?? this.result,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }
}
