import 'storage_service.dart';

// Platform-specific imports
import 'storage_service_io.dart'
    if (dart.library.html) 'storage_service_web.dart';

StorageService getStorageService() => createStorageService();
