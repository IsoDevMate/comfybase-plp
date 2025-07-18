import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'core/services/auth_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/auth/presentation/screens/dashboard_screen.dart';
import 'features/events/presentation/providers/events_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProvider(create: (_) => EventsProvider()),
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
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/': (context) => const DashboardScreen(),
      },
    );
  }
}
