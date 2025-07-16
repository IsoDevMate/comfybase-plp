import 'storage_service.dart';

StorageService createStorageService() {
  return WebStorageService();
}

class WebStorageService implements StorageService {
  final Map<String, String?> _store = {};

  @override
  Future<void> write({required String key, required String? value}) async {
    _store[key] = value;
  }

  @override
  Future<String?> read({required String key}) async {
    return _store[key];
  }

  @override
  Future<void> delete({required String key}) async {
    _store.remove(key);
  }
}
