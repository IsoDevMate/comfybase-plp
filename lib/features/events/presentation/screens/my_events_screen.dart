import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';

class MyEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Registered Events')),
      body: FutureBuilder(
        future: Provider.of<EventsProvider>(
          context,
          listen: false,
        ).getMyEvents(),
        builder: (context, snapshot) {
          final provider = Provider.of<EventsProvider>(context);
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          if (provider.events.isEmpty) {
            return const Center(
              child: Text('You have not registered for any events.'),
            );
          }
          return ListView.builder(
            itemCount: provider.events.length,
            itemBuilder: (context, index) {
              final event = provider.events[index];
              return EventCard(
                event: event,
                onTap: () {
                  context.go('/events/details/${event.id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
