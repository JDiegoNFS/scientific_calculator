import 'package:flutter/foundation.dart';
import '../models/calculation_entry.dart';
import '../services/data_persistence_service.dart';

class HistoryProvider extends ChangeNotifier {
  final DataPersistenceService _persistenceService;
  List<CalculationEntry> _history = [];

  HistoryProvider(this._persistenceService) {
    _loadHistory();
  }

  List<CalculationEntry> get history => _history;

  void _loadHistory() {
    _history = _persistenceService.getHistory();
    notifyListeners();
  }

  Future<void> addEntry(String expression, String result) async {
    final entry = CalculationEntry(
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );
    await _persistenceService.saveHistoryEntry(entry);
    _history.insert(0, entry);
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    await _persistenceService.deleteHistoryEntry(id);
    _history.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _persistenceService.clearHistory();
    _history.clear();
    notifyListeners();
  }
}
