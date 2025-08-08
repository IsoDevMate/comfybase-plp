import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kenyanvalley/features/onboarding/presentation/screens/introduction_screen.dart';
import '../../features/events/presentation/screens/events_list_screen.dart';
import '../../features/events/presentation/screens/event_detail_screen.dart';
import '../../features/events/presentation/screens/create_event_screen.dart';
import '../../features/events/presentation/screens/my_events_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static Future<GoRouter> get router async {
    final prefs = await SharedPreferences.getInstance();
    final bool showIntro = prefs.getBool('show_intro') ?? true;

    return GoRouter(
      initialLocation: showIntro ? '/intro' : '/events',
      routes: [
        // Introduction/Onboarding Screen
        GoRoute(
          path: '/intro',
          builder: (context, state) => const OnboardingScreen(),
        ),
        
        // Main App Routes
        GoRoute(
          path: '/events',
          builder: (context, state) => const EventsListScreen(),
          routes: [
            GoRoute(
              path: 'details/:id',
              builder: (context, state) {
                final eventId = state.pathParameters['id']!;
                return EventDetailsScreen(eventId: eventId);
              },
            ),
            GoRoute(
              path: 'create',
              builder: (context, state) => const EventCreateScreen(),
            ),
            GoRoute(
              path: 'my', 
              builder: (context, state) => const MyEventsScreen()
            ),
            GoRoute(
              path: 'reports', 
              builder: (context, state) => const ReportsScreen()
            ),
          ],
        ),
        
        // Auth Routes (add your auth routes here)
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(), // Add your login screen
        ),
      ],
    );
  }
  
  // Call this method when intro is completed
  static Future<void> completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_intro', false);
  }
}
