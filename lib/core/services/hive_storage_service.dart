import 'package:hive_flutter/hive_flutter.dart';
import 'storage_service.dart';

class HiveStorageService implements StorageService {
  static const String _boxName = 'kenyan_valley_storage';
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      await Hive.openBox<String>(_boxName);
      _isInitialized = true;
    }
  }

  Box<String> get _box => Hive.box<String>(_boxName);

  @override
  Future<void> write({required String key, required String? value}) async {
    try {
      if (value == null) {
        await _box.delete(key);
        print('Hive: Removed key: $key');
      } else {
        await _box.put(key, value);
        print('Hive: Stored key: $key with value length: ${value.length}');
      }
    } catch (e) {
      print('Hive: Error writing to storage: $e');
      rethrow;
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      final value = _box.get(key);
      print('Hive: Read key: $key, value found: ${value != null}');
      return value;
    } catch (e) {
      print('Hive: Error reading from storage: $e');
      return null;
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      await _box.delete(key);
      print('Hive: Deleted key: $key');
    } catch (e) {
      print('Hive: Error deleting from storage: $e');
      rethrow;
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _box.clear();
      print('Hive: Cleared all data');
    } catch (e) {
      print('Hive: Error clearing storage: $e');
      rethrow;
    }
  }
}

StorageService createHiveStorageService() => HiveStorageService();
