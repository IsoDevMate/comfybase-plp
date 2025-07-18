// features/events/presentation/pages/events_list_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';
// import '../widgets/events_filter.dart';
// import '../widgets/payment_modal.dart';
// import '../../domain/entities/event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({super.key});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsProvider>().fetchEvents();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<EventsProvider>().loadMoreEvents();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_available),
            tooltip: 'My Registered Events',
            onPressed: () {
              context.go('/events/my');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/events/create');
            },
          ),
        ],
      ),
      body: Consumer<EventsProvider>(
        builder: (context, eventsProvider, child) {
          return Column(
            children: [
              // Filters Section
              // TODO: Implement EventsFilter widget
              // const EventsFilter(),

              // Events List
              Expanded(child: _buildEventsList(eventsProvider)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/events/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventsList(EventsProvider eventsProvider) {
    if (eventsProvider.isLoading && eventsProvider.events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventsProvider.error != null && eventsProvider.events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error: ${eventsProvider.error}',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                eventsProvider.fetchEvents();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (eventsProvider.events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 64, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text('No events found', style: AppTextStyles.titleMedium),
            SizedBox(height: 8),
            Text(
              'Try adjusting your filters or create a new event',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await eventsProvider.fetchEvents();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount:
            eventsProvider.events.length +
            (eventsProvider.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == eventsProvider.events.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final event = eventsProvider.events[index];
          return EventCard(
            event: event,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/events/details',
                arguments: event.id,
              );
            },
            // TODO: Implement onRegister and onDelete handlers
            // onRegister: () {
            //   _handleEventRegistration(event, eventsProvider);
            // },
            onEdit: () {
              Navigator.pushNamed(context, '/events/edit', arguments: event.id);
            },
            // onDelete: () {
            //   _showDeleteConfirmation(event, eventsProvider);
            // },
          );
        },
      ),
    );
  }

  // TODO: Use correct EventModel type instead of Event, and implement payment modal if needed
  void _handleEventRegistration(
    /* Event event, */ EventsProvider eventsProvider,
  ) {
    // TODO: Implement event registration logic, including PaymentModal for paid events
    // if (event.ticketPrice > 0) {
    //   // Show payment modal for paid events
    //   showDialog(
    //     context: context,
    //     builder: (context) => PaymentModal(
    //       event: event,
    //       onPaymentSubmit: (phoneNumber) {
    //         eventsProvider.registerForPaidEvent(event.id, phoneNumber);
    //         Navigator.pop(context);
    //       },
    //     ),
    //   );
    // } else {
    //   // Direct registration for free events
    //   eventsProvider.registerForFreeEvent(event.id);
    // }
  }

  // TODO: Use correct EventModel type instead of Event
  void _showDeleteConfirmation(
    /* Event event, */ EventsProvider eventsProvider,
  ) {
    // TODO: Implement delete confirmation dialog
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Delete Event'),
    //     content: Text('Are you sure you want to delete " event.title"?'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: const Text('Cancel'),
    //       ),
    //       TextButton(
    //         onPressed: () {
    //           eventsProvider.deleteEvent(event.id);
    //           Navigator.pop(context);
    //         },
    //         style: TextButton.styleFrom(foregroundColor: AppColors.error),
    //         child: const Text('Delete'),
    //       ),
    //     ],
    //   ),
    // );
  }
}
