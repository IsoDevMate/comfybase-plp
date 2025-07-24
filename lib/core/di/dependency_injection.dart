import 'package:dio/dio.dart';
import 'package:kenyanvalley/core/network/api_client.dart';
import 'package:kenyanvalley/core/network/dio_client.dart';
import 'package:kenyanvalley/core/network/network_info.dart';
import 'package:kenyanvalley/features/notes/data/datasources/notes_service.dart';
import 'package:kenyanvalley/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:kenyanvalley/features/notes/domain/repositories/notes_repository.dart';

// Dependencies
class Dependencies {
  // Network
  final Dio dio = DioClient().dio;
  final NetworkInfo networkInfo = NetworkInfoImpl();
  
  // Services
  late final NotesRemoteDataSource notesService;
  
  // Repositories
  late final NotesRepository notesRepository;
  
  Dependencies() {
    // Initialize services
    notesService = NotesRemoteDataSourceImpl(
      dio: dio,
      networkInfo: networkInfo,
    );
    
    // Initialize repositories
    notesRepository = NotesRepositoryImpl(
      remoteDataSource: notesService,
    );
  }
}

// Global instance of dependencies
Dependencies? _dependencies;

// Initialize all dependencies
Future<void> initDependencies() async {
  // Initialize network clients
  DioClient().init();
  ApiClient().init();
  
  // Initialize dependencies
  _dependencies = Dependencies();
}

// Get dependencies instance
Dependencies get dependencies {
  if (_dependencies == null) {
    throw Exception('Dependencies not initialized. Call initDependencies() first.');
  }
  return _dependencies!;
}
