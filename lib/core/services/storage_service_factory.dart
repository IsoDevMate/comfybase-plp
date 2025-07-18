import 'storage_service.dart';
import 'storage_service_shared_prefs.dart'
    if (dart.library.html) 'storage_service_web.dart';

StorageService getStorageService() => createStorageService();
