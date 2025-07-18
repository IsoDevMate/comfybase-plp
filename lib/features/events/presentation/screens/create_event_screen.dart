// features/events/presentation/pages/create_event_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../../data/models/event_model.dart';
import '../widgets/event_form.dart';
import '../widgets/event_card.dart';

class CreateEventPage extends StatefulWidget {
  final EventModel? initialEvent; // Pass this for editing

  const CreateEventPage({Key? key, this.initialEvent}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  EventModel? _previewEvent;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _previewEvent = widget.initialEvent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialEvent == null ? 'Create Event' : 'Edit Event',
        ),
      ),
      body: Consumer<EventsProvider>(
        builder: (context, eventsProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventForm(
                  initialEvent: widget.initialEvent,
                  onSubmit: (event) async {
                    setState(() => _isSubmitting = true);
                    final success = widget.initialEvent == null
                        ? await eventsProvider.createEvent(event)
                        : await eventsProvider.updateEvent(event.id, event);
                    setState(() => _isSubmitting = false);
                    if (success) {
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(eventsProvider.error ?? 'Error'),
                        ),
                      );
                    }
                  },
                  onChanged: (event) {
                    setState(() => _previewEvent = event);
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'Live Preview:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (_previewEvent != null) EventCard(event: _previewEvent!),
                if (_isSubmitting)
                  const Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
