import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_service.dart';

StorageService createStorageService() {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    return MockStorageService();
  } else {
    return SecureStorageService();
  }
}

class MockStorageService implements StorageService {
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

class SecureStorageService implements StorageService {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> write({required String key, required String? value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);
}
