import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  void initState() {
    super.initState();
    // Load events after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventsProvider>(context, listen: false).getMyEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Registered Events')),
      body: Consumer<EventsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.getMyEvents(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
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
                  Navigator.pushNamed(context, '/events/details/${event.id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
