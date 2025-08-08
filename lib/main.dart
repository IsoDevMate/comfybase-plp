// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:kenyanvalley/core/network/api_client.dart';
// import 'features/auth/presentation/providers/auth_provider.dart';
// import 'core/services/auth_service.dart';
// import 'features/auth/presentation/screens/login_screen.dart';
// import 'features/auth/presentation/screens/register_screen.dart';
// import 'features/auth/presentation/screens/profile_screen.dart';
// import 'features/auth/presentation/screens/dashboard_screen.dart';
// import 'features/events/presentation/providers/events_provider.dart';
// import 'core/network/dio_client.dart';
// import 'features/auth/presentation/screens/settings_screen.dart';
// import 'package:kenyanvalley/features/events/presentation/screens/events_list_screen.dart';
// import 'package:kenyanvalley/features/events/presentation/screens/create_event_screen.dart';
// import 'features/auth/presentation/screens/edit_profile_screen.dart';
// import 'core/services/storage_service_factory.dart';
// import 'core/services/hive_storage_service.dart';
// import 'core/di/dependency_injection.dart';
// import 'package:kenyanvalley/features/notes/presentation/screens/notes_list_screen.dart';
// import 'package:kenyanvalley/features/notes/presentation/providers/notes_provider.dart';
// import 'package:kenyanvalley/core/di/dependency_injection.dart' as di;
// import 'package:kenyanvalley/features/notes/domain/repositories/notes_repository.dart';
// import 'package:kenyanvalley/core/di/dependency_injection.dart' as di;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Hive storage
//   await HiveStorageService.init();

//   // Initialize dependencies
//   await di.initDependencies();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
//         ChangeNotifierProvider(create: (_) => EventsProvider()),
//         ChangeNotifierProvider<NotesProvider>(
//           create: (_) => NotesProvider(di.dependencies.notesRepository),
//         ),
//       ],
//       child: const MainApp(),
//     ),
//   );
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ComfyBase',
//       theme: ThemeData(useMaterial3: true),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const DashboardScreen(),
//         '/profile': (context) => const ProfileScreen(),
//         '/edit-profile': (context) => const EditProfileScreen(),
//         '/settings': (context) => const SettingsPage(),
//         '/events': (context) => const EventsListPage(),
//         '/events/create': (context) => const CreateEventPage(),
//         '/notes': (context) => const NotesListScreen(),
//         '/login': (context) => const LoginScreen(),
//         '/register': (context) => const RegisterScreen(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:kenyanvalley/features/events/presentation/screens/my_events_screen.dart';
import 'package:kenyanvalley/features/events/presentation/screens/event_detail_screen.dart';
import 'features/auth/presentation/screens/edit_profile_screen.dart';
import 'core/services/storage_service_factory.dart';
import 'core/services/hive_storage_service.dart';
import 'core/di/dependency_injection.dart';
import 'package:kenyanvalley/features/notes/presentation/screens/notes_list_screen.dart';
import 'package:kenyanvalley/features/notes/presentation/providers/notes_provider.dart';
import 'package:kenyanvalley/core/di/dependency_injection.dart' as di;
import 'package:kenyanvalley/features/notes/domain/repositories/notes_repository.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // Preserve the splash screen until the app is ready
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Hive storage
  await HiveStorageService.init();

  // Initialize dependencies
  await di.initDependencies();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

  // Remove the splash screen after the app is fully loaded
  FlutterNativeSplash.remove();
}

class MainAppWithNavigation extends StatefulWidget {
  const MainAppWithNavigation({super.key});

  @override
  State<MainAppWithNavigation> createState() => _MainAppWithNavigationState();
}

class _MainAppWithNavigationState extends State<MainAppWithNavigation> {
  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainAppWithNavigation(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      title: 'ComfyBase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/events/create': (context) => const CreateEventPage(),
        '/notes': (context) => const NotesListScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Page not found: ${settings.name}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/'),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onGenerateRoute: (settings) {
        // Handle dynamic routes
        if (settings.name?.startsWith('/events/') ?? false) {
          final uri = Uri.parse(settings.name!);
          final segments = uri.pathSegments;

          if (segments.length == 2 &&
              segments[1] != 'create' &&
              segments[1] != 'my') {
            final eventId = segments[1];
            return MaterialPageRoute(
              builder: (context) => EventDetailsScreen(eventId: eventId),
            );
          }
        }

        // Handle 404
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('Page not found: ${settings.name}')),
          ),
        );
      },
    );
  }
}
