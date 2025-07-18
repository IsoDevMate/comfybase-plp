// features/events/presentation/pages/event_details_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../widgets/payment_modal.dart';
import '../../domain/entities/event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsProvider>().fetchEventById(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EventsProvider>(
        builder: (context, eventsProvider, child) {
          final event = eventsProvider.selectedEvent;

          if (eventsProvider.isLoading || event == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (eventsProvider.error != null) {
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
                      eventsProvider.fetchEventById(widget.eventId);
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(event),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEventHeader(event),
                      const SizedBox(height: 24),
                      _buildEventDetails(event),
                      const SizedBox(height: 24),
                      _buildLocation(event),
                      const SizedBox(height: 24),
                      _buildDescription(event),
                      const SizedBox(height: 24),
                      _buildAttendees(event),
                      const SizedBox(height: 32),
                      _buildActionButtons(event, eventsProvider),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(Event event) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: event.coverImage != null
            ? Image.network(event.coverImage!, fit: BoxFit.cover)
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: const Icon(Icons.event, size: 64, color: Colors.white),
              ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                Navigator.pushNamed(
                  context,
                  '/events/edit',
                  arguments: event.id,
                );
                break;
              case 'delete':
                _showDeleteConfirmation(event);
                break;
              case 'share':
                _shareEvent(event);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share),
                  SizedBox(width: 8),
                  Text('Share'),
                ],
              ),
            ),
            if (event.canEdit)
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
            if (event.canDelete)
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventHeader(Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatusChip(event.status),
            const SizedBox(width: 8),
            _buildTypeChip(event.type),
          ],
        ),
        const SizedBox(height: 12),
        Text(event.title, style: AppTextStyles.headlineMedium),
        if (event.ticketPrice > 0) ...[
          const SizedBox(height: 8),
          Text(
            'KES ${event.ticketPrice.toStringAsFixed(2)}',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEventDetails(Event event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow(
              Icons.calendar_today,
              'Start Date',
              DateFormatter.formatDateTime(event.startDate),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.calendar_today_outlined,
              'End Date',
              DateFormatter.formatDateTime(event.endDate),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.people,
              'Capacity',
              event.capacity != null
                  ? '${event.attendees.length} / ${event.capacity}'
                  : '${event.attendees.length} attendees',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.visibility,
              'Visibility',
              event.isPublic ? 'Public' : 'Private',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocation(Event event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Location', style: AppTextStyles.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.location.name,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(event.location.address, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 4),
            Text(
              '${event.location.city}, ${event.location.country}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(Event event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description', style: AppTextStyles.titleMedium),
            const SizedBox(height: 12),
            Text(event.description, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendees(Event event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attendees (${event.attendees.length})',
                  style: AppTextStyles.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to attendees list
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (event.attendees.isEmpty)
              const Text('No attendees yet', style: AppTextStyles.bodyMedium)
            else
              // Show first few attendees
              const Text(
                'Attendees list would go here',
                style: AppTextStyles.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Event event, EventsProvider eventsProvider) {
    return Column(
      children: [
        if (!event.isUserRegistered) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: eventsProvider.isRegistering
                  ? null
                  : () => _handleRegistration(event, eventsProvider),
              child: eventsProvider.isRegistering
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Processing...'),
                      ],
                    )
                  : Text(
                      event.ticketPrice > 0
                          ? 'Pay KES ${event.ticketPrice.toStringAsFixed(2)}'
                          : 'Register for Free',
                    ),
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              child: const Text('Already Registered'),
            ),
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/events/sessions',
                arguments: event.id,
              );
            },
            child: const Text('View Sessions'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'draft':
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        break;
      case 'published':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case 'completed':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }

  Widget _buildTypeChip(String type) {
    return Chip(
      label: Text(
        type.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColors.primaryLight.withOpacity(0.1),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  void _handleRegistration(Event event, EventsProvider eventsProvider) {
    if (event.ticketPrice > 0) {
      showDialog(
        context: context,
        builder: (context) => PaymentModal(
          event: event,
          onPaymentSubmit: (phoneNumber) {
            eventsProvider.registerForPaidEvent(event.id, phoneNumber);
            Navigator.pop(context);
          },
        ),
      );
    } else {
      eventsProvider.registerForFreeEvent(event.id);
    }
  }

  void _showDeleteConfirmation(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<EventsProvider>().deleteEvent(event.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _shareEvent(Event event) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality not implemented yet')),
    );
  }
}
