import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/event_model.dart';
import '../providers/events_provider.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  EventModel? event;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  Future<void> _loadEventDetails() async {
    try {
      final eventsProvider = Provider.of<EventsProvider>(
        context,
        listen: false,
      );

      // First try to find the event in the existing events list
      final events = eventsProvider.events;
      EventModel? foundEvent;

      try {
        foundEvent = events.firstWhere((e) => e.id == widget.eventId);
      } catch (e) {
        // If not found in list, fetch it from API
        await eventsProvider.fetchEventById(widget.eventId);
        foundEvent = eventsProvider.selectedEvent;
      }

      if (foundEvent == null) {
        throw Exception('Event not found');
      }

      setState(() {
        event = foundEvent;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(event?.title ?? 'Event Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading event',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error!,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadEventDetails,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : event == null
          ? const Center(child: Text('Event not found'))
          : _buildEventDetails(),
    );
  }

  Widget _buildEventDetails() {
    final event = this.event!;
    final dateFormat = DateFormat('MMM d, y • h:mm a');
    final startDate = dateFormat.format(event.startDate);
    final endDate = dateFormat.format(event.endDate);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: event.coverImage != null && event.coverImage!.isNotEmpty
                ? Image.network(
                    event.coverImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDefaultEventImage(),
                  )
                : _buildDefaultEventImage(),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                Text(
                  event.title,
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Event Type and Status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        event.type,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        event.status,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                if (event.description.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Date and Time
                _buildInfoSection('Date & Time', [
                  _buildInfoRow(Icons.schedule, 'Start: $startDate'),
                  _buildInfoRow(Icons.schedule, 'End: $endDate'),
                ]),

                // Location
                const SizedBox(height: 16),
                _buildInfoSection('Location', [
                  _buildInfoRow(Icons.location_on, event.location.name),
                  _buildInfoRow(Icons.location_on, event.location.address),
                  _buildInfoRow(Icons.location_city, event.location.city),
                  _buildInfoRow(Icons.public, event.location.country),
                ]),

                // Event Details
                const SizedBox(height: 16),
                _buildInfoSection('Event Details', [
                  _buildInfoRow(
                    Icons.people,
                    'Capacity: ${event.capacity ?? 'Unlimited'}',
                  ),
                  _buildInfoRow(
                    Icons.attach_money,
                    'Price: ${event.ticketPrice != null && event.ticketPrice! > 0 ? 'KSH ${event.ticketPrice!.toStringAsFixed(2)}' : 'Free'}',
                  ),
                  _buildInfoRow(
                    Icons.group,
                    'Attendees: ${event.attendees.length}',
                  ),
                ]),

                // Organizer
                if (event.organizer != null) ...[
                  const SizedBox(height: 16),
                  _buildInfoSection('Organizer', [
                    _buildInfoRow(
                      Icons.person,
                      _getOrganizerName(event.organizer),
                    ),
                    if (_getOrganizerEmail(event.organizer) != null)
                      _buildInfoRow(
                        Icons.email,
                        _getOrganizerEmail(event.organizer)!,
                      ),
                  ]),
                ],

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle registration
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Register'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Handle sharing
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getOrganizerName(dynamic organizer) {
    if (organizer is Map<String, dynamic>) {
      final firstName = organizer['firstName'] ?? organizer['first_name'] ?? '';
      final lastName = organizer['lastName'] ?? organizer['last_name'] ?? '';
      return '$firstName $lastName'.trim();
    }
    return organizer.toString();
  }

  String? _getOrganizerEmail(dynamic organizer) {
    if (organizer is Map<String, dynamic>) {
      return organizer['email'];
    }
    return null;
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultEventImage() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: Center(
        child: Icon(Icons.event, size: 60, color: AppColors.primary),
      ),
    );
  }
}
