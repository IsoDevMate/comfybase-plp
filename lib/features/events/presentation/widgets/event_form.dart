import 'package:flutter/material.dart';
import '../../data/models/event_model.dart';

class EventForm extends StatefulWidget {
  final EventModel? initialEvent;
  final void Function(EventModel) onSubmit;

  const EventForm({Key? key, this.initialEvent, required this.onSubmit})
    : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _locationName;

  @override
  void initState() {
    super.initState();
    _title = widget.initialEvent?.title ?? '';
    _description = widget.initialEvent?.description ?? '';
    _locationName = widget.initialEvent?.location.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: _title,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (v) => v == null || v.isEmpty ? 'Enter a title' : null,
            onSaved: (v) => _title = v ?? '',
          ),
          TextFormField(
            initialValue: _description,
            decoration: const InputDecoration(labelText: 'Description'),
            validator: (v) =>
                v == null || v.isEmpty ? 'Enter a description' : null,
            onSaved: (v) => _description = v ?? '',
          ),
          TextFormField(
            initialValue: _locationName,
            decoration: const InputDecoration(labelText: 'Location Name'),
            validator: (v) =>
                v == null || v.isEmpty ? 'Enter a location' : null,
            onSaved: (v) => _locationName = v ?? '',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                final event = EventModel(
                  id: widget.initialEvent?.id ?? '',
                  title: _title,
                  description: _description,
                  organizer: widget.initialEvent?.organizer ?? '',
                  type: widget.initialEvent?.type ?? 'conference',
                  status: widget.initialEvent?.status ?? 'draft',
                  startDate: widget.initialEvent?.startDate ?? DateTime.now(),
                  endDate:
                      widget.initialEvent?.endDate ??
                      DateTime.now().add(const Duration(hours: 2)),
                  location:
                      widget.initialEvent?.location ??
                      EventLocation(
                        name: _locationName,
                        address: '',
                        city: '',
                        country: '',
                      ),
                  capacity: widget.initialEvent?.capacity,
                  ticketPrice: widget.initialEvent?.ticketPrice,
                  coverImage: widget.initialEvent?.coverImage,
                  sessions: widget.initialEvent?.sessions ?? [],
                  attendees: widget.initialEvent?.attendees ?? [],
                  createdAt: widget.initialEvent?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                widget.onSubmit(event);
              }
            },
            child: Text(
              widget.initialEvent == null ? 'Create Event' : 'Update Event',
            ),
          ),
        ],
      ),
    );
  }
}
