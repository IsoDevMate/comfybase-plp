import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kenyanvalley/core/network/api_client.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'core/services/auth_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/auth/presentation/screens/dashboard_screen.dart';
import 'features/events/presentation/providers/events_provider.dart';
import 'core/network/dio_client.dart';
import 'features/auth/presentation/screens/settings_screen.dart';
import 'package:kenyanvalley/features/events/presentation/screens/events_list_screen.dart';
import 'package:kenyanvalley/features/events/presentation/screens/create_event_screen.dart';
import 'features/auth/presentation/screens/edit_profile_screen.dart';
import 'core/services/storage_service_factory.dart';
import 'core/services/hive_storage_service.dart';
import 'core/di/dependency_injection.dart';
import 'package:kenyanvalley/features/notes/presentation/screens/notes_list_screen.dart';
import 'package:kenyanvalley/features/notes/presentation/providers/notes_provider.dart';
import 'package:kenyanvalley/core/di/dependency_injection.dart' as di;
import 'package:kenyanvalley/features/notes/domain/repositories/notes_repository.dart';
import 'package:kenyanvalley/core/di/dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage
  await HiveStorageService.init();

  // Initialize dependencies
  await di.initDependencies();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProvider(create: (_) => EventsProvider()),
        ChangeNotifierProvider<NotesProvider>(
          create: (_) => NotesProvider(di.dependencies.notesRepository),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComfyBase',
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/settings': (context) => const SettingsPage(),
        '/events': (context) => const EventsListPage(),
        '/events/create': (context) => const CreateEventPage(),
        '/notes': (context) => const NotesListScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
