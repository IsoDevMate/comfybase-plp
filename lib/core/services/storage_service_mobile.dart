import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_service.dart';

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

StorageService createStorageService() => SecureStorageService();
