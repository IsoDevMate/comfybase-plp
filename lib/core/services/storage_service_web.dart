import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

class WebStorageService implements StorageService {
  String _getPrefixedKey(String key) => 'flutter:$key';

  @override
  Future<void> write({required String key, required String? value}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefixedKey = _getPrefixedKey(key);
      if (value == null) {
        await prefs.remove(prefixedKey);
        print('Removed key: $prefixedKey from storage');
      } else {
        await prefs.setString(prefixedKey, value);
        print('Stored key: $prefixedKey with value length: ${value.length}');
      }
    } catch (e) {
      print('Error writing to storage: $e');
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefixedKey = _getPrefixedKey(key);
      final value = prefs.getString(prefixedKey);
      print('Read key: $prefixedKey, value found: ${value != null}');
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
      final prefixedKey = _getPrefixedKey(key);
      await prefs.remove(prefixedKey);
      print('Deleted key: $prefixedKey from storage');
    } catch (e) {
      print('Error deleting from storage: $e');
    }
  }
}

StorageService createStorageService() => WebStorageService();
