import 'package:flutter/material.dart';
import '../../data/models/event_model.dart';

class EventForm extends StatefulWidget {
  final EventModel? initialEvent;
  final void Function(EventModel) onSubmit;
  final void Function(EventModel)? onChanged; // New callback for live preview

  const EventForm({
    Key? key,
    this.initialEvent,
    required this.onSubmit,
    this.onChanged,
  }) : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _locationName;
  late String _locationAddress;
  late String _locationCity;
  late String _locationCountry;
  late DateTime _startDate;
  late DateTime _endDate;
  late String _type;
  late String _status;
  late int? _capacity;
  late int? _ticketPrice;

  @override
  void initState() {
    super.initState();
    final e = widget.initialEvent;
    _title = e?.title ?? '';
    _description = e?.description ?? '';
    _locationName = e?.location.name ?? '';
    _locationAddress = e?.location.address ?? '';
    _locationCity = e?.location.city ?? '';
    _locationCountry = e?.location.country ?? '';
    _startDate = e?.startDate ?? DateTime.now();
    _endDate = e?.endDate ?? DateTime.now().add(const Duration(hours: 2));
    _type = e?.type ?? 'conference';
    _status = e?.status ?? 'draft';
    _capacity = e?.capacity;
    _ticketPrice = e?.ticketPrice;
  }

  void _notifyChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(_buildEventModel());
    }
  }

  EventModel _buildEventModel() {
    return EventModel(
      id: widget.initialEvent?.id ?? '',
      title: _title,
      description: _description,
      organizer: widget.initialEvent?.organizer ?? '',
      type: _type,
      status: _status,
      startDate: _startDate,
      endDate: _endDate,
      location: EventLocation(
        name: _locationName,
        address: _locationAddress,
        city: _locationCity,
        country: _locationCountry,
      ),
      capacity: _capacity,
      ticketPrice: _ticketPrice,
      coverImage: widget.initialEvent?.coverImage,
      sessions: widget.initialEvent?.sessions ?? [],
      attendees: widget.initialEvent?.attendees ?? [],
      createdAt: widget.initialEvent?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
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
            onChanged: (v) {
              setState(() => _title = v);
              _notifyChanged();
            },
            onSaved: (v) => _title = v ?? '',
          ),
          TextFormField(
            initialValue: _description,
            decoration: const InputDecoration(labelText: 'Description'),
            validator: (v) =>
                v == null || v.isEmpty ? 'Enter a description' : null,
            onChanged: (v) {
              setState(() => _description = v);
              _notifyChanged();
            },
            onSaved: (v) => _description = v ?? '',
          ),
          TextFormField(
            initialValue: _locationName,
            decoration: const InputDecoration(labelText: 'Location Name'),
            validator: (v) =>
                v == null || v.isEmpty ? 'Enter a location' : null,
            onChanged: (v) {
              setState(() => _locationName = v);
              _notifyChanged();
            },
            onSaved: (v) => _locationName = v ?? '',
          ),
          TextFormField(
            initialValue: _locationAddress,
            decoration: const InputDecoration(labelText: 'Location Address'),
            onChanged: (v) {
              setState(() => _locationAddress = v);
              _notifyChanged();
            },
            onSaved: (v) => _locationAddress = v ?? '',
          ),
          TextFormField(
            initialValue: _locationCity,
            decoration: const InputDecoration(labelText: 'City'),
            onChanged: (v) {
              setState(() => _locationCity = v);
              _notifyChanged();
            },
            onSaved: (v) => _locationCity = v ?? '',
          ),
          TextFormField(
            initialValue: _locationCountry,
            decoration: const InputDecoration(labelText: 'Country'),
            onChanged: (v) {
              setState(() => _locationCountry = v);
              _notifyChanged();
            },
            onSaved: (v) => _locationCountry = v ?? '',
          ),
          TextFormField(
            initialValue: _capacity?.toString() ?? '',
            decoration: const InputDecoration(labelText: 'Capacity'),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              setState(() => _capacity = int.tryParse(v));
              _notifyChanged();
            },
            onSaved: (v) => _capacity = int.tryParse(v ?? ''),
          ),
          TextFormField(
            initialValue: _ticketPrice?.toString() ?? '',
            decoration: const InputDecoration(labelText: 'Ticket Price'),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              setState(() => _ticketPrice = int.tryParse(v));
              _notifyChanged();
            },
            onSaved: (v) => _ticketPrice = int.tryParse(v ?? ''),
          ),
          // TODO: Add pickers for startDate, endDate, type, status if needed
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                widget.onSubmit(_buildEventModel());
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
