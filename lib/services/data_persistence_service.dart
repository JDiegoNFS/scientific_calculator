import 'package:hive_flutter/hive_flutter.dart';
import '../models/calculation_entry.dart';

class DataPersistenceService {
  static const String _historyBoxName = 'historyBox';
  static const String _settingsBoxName = 'settingsBox';

  late Box<CalculationEntry> _historyBox;
  late Box _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CalculationEntryAdapter());
    _historyBox = await Hive.openBox<CalculationEntry>(_historyBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // History Methods
  List<CalculationEntry> getHistory() {
    return _historyBox.values.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> saveHistoryEntry(CalculationEntry entry) async {
    await _historyBox.put(entry.id, entry);
  }

  Future<void> deleteHistoryEntry(String id) async {
    await _historyBox.delete(id);
  }

  Future<void> clearHistory() async {
    await _historyBox.clear();
  }

  // Settings Methods (Placeholder for future implementation)
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }
}
