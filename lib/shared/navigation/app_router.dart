import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/events/presentation/screens/events_list_screen.dart';
import '../../features/events/presentation/screens/event_detail_screen.dart';
import '../../features/events/presentation/screens/create_event_screen.dart';
import '../../features/events/presentation/screens/my_events_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/events',
  routes: [
    GoRoute(
      path: '/events',
      builder: (context, state) => EventsListScreen(),
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
          builder: (context, state) => EventCreateScreen(),
        ),
        GoRoute(path: 'my', builder: (context, state) => MyEventsScreen()),
        GoRoute(path: 'reports', builder: (context, state) => const ReportsScreen()),
      ],
    ),
  ],
);
