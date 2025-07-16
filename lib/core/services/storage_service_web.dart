import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

class WebStorageService implements StorageService {
  @override
  Future<void> write({required String key, required String? value}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value == null) {
        await prefs.remove(key);
        print('Removed key: $key from storage');
      } else {
        await prefs.setString(key, value);
        print('Stored key: $key with value length: ${value.length}');
      }
    } catch (e) {
      print('Error writing to storage: $e');
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      print('Read key: $key, value found: ${value != null}');
      return value;
    } catch (e) {
      print('Error reading from storage: $e');
      return null;
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      print('Deleted key: $key from storage');
    } catch (e) {
      print('Error deleting from storage: $e');
    }
  }
}

StorageService createStorageService() => WebStorageService();
