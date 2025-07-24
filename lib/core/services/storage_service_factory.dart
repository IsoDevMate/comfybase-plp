import 'storage_service.dart';
import 'hive_storage_service.dart';

/// Returns the appropriate storage service implementation
/// Currently using Hive for all platforms
StorageService getStorageService() => createHiveStorageService();
