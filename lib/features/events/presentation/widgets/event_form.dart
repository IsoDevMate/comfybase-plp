import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/event_model.dart';

// List of countries and their major cities
const List<Map<String, dynamic>> countries = [
  {
    'name': 'Kenya',
    'cities': ['Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret', 'Nyeri', 'Kakamega', 'Nyakach']
  },
  {
    'name': 'Uganda',
    'cities': ['Kampala', 'Entebbe', 'Jinja', 'Gulu', 'Mbarara']
  },
  {
    'name': 'Tanzania',
    'cities': ['Dar es Salaam', 'Dodoma', 'Zanzibar', 'Arusha', 'Mwanza']
  },
  {
    'name': 'Nigeria',
    'cities': ['Lagos', 'Abuja', 'Kano', 'Ibadan', 'Port Harcourt']
  },
  {
    'name': 'South Africa',
    'cities': ['Johannesburg', 'Cape Town', 'Durban', 'Pretoria', 'Bloemfontein']
  },
  {
    'name': 'Other',
    'cities': ['Other']
  }
];

// Event types matching the backend enum
const List<String> eventTypes = [
  'conference',
  'seminar',
  'workshop',
  'meetup',
  'webinar',
  'training',
  'expo',
  'other'
];

// Event statuses
const List<String> eventStatuses = [
  'draft',
  'published',
  'cancelled',
  'completed'
];

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

  // Get list of cities for the selected country
  List<String> get _availableCities {
    final country = countries.firstWhere(
      (c) => c['name'] == _locationCountry,
      orElse: () => {'cities': <String>[]},
    );
    return List<String>.from(country['cities'] ?? []);
  }

  // Show date picker and update the date
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _startDate.hour,
            _startDate.minute,
          );
          // If end date is before new start date, update it
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(hours: 2));
          }
        } else {
          _endDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _endDate.hour,
            _endDate.minute,
          );
        }
        _notifyChanged();
      });
    }
  }

  // Show time picker and update the time
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        isStartTime ? _startDate : _endDate,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startDate = DateTime(
            _startDate.year,
            _startDate.month,
            _startDate.day,
            picked.hour,
            picked.minute,
          );
          // If end date is before new start date, update it
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(hours: 2));
          }
        } else {
          _endDate = DateTime(
            _endDate.year,
            _endDate.month,
            _endDate.day,
            picked.hour,
            picked.minute,
          );
        }
        _notifyChanged();
      });
    }
  }

  // Validate form fields
  String? _validateField(String fieldName, String value) {
    switch (fieldName) {
      case 'title':
        return value.isEmpty ? 'Title is required' : null;
      case 'description':
        return value.isEmpty ? 'Description is required' : null;
      case 'location.name':
        return value.isEmpty ? 'Venue name is required' : null;
      case 'location.address':
        return value.isEmpty ? 'Address is required' : null;
      case 'location.city':
        return value.isEmpty ? 'City is required' : null;
      case 'location.country':
        return value.isEmpty ? 'Country is required' : null;
      case 'capacity':
        if (value.isEmpty) return 'Capacity is required';
        final capacity = int.tryParse(value);
        if (capacity == null) return 'Enter a valid number';
        if (capacity < 30) return 'Minimum capacity is 30';
        if (capacity > 5000) return 'Maximum capacity is 5000';
        return null;
      case 'ticketPrice':
        if (value.isNotEmpty) {
          final price = int.tryParse(value);
          if (price == null) return 'Enter a valid number';
          if (price < 0) return 'Price cannot be negative';
        }
        return null;
      default:
        return null;
    }
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(
                labelText: 'Event Title *',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _validateField('title', v ?? ''),
              onChanged: (v) {
                setState(() => _title = v);
                _notifyChanged();
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (v) => _validateField('description', v ?? ''),
              onChanged: (v) {
                setState(() => _description = v);
                _notifyChanged();
              },
            ),
            const SizedBox(height: 16),

            // Event Type
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(
                labelText: 'Event Type *',
                border: OutlineInputBorder(),
              ),
              items: eventTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type[0].toUpperCase() + type.substring(1)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _type = value);
                  _notifyChanged();
                }
              },
            ),
            const SizedBox(height: 16),

            // Event Status
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status *',
                border: OutlineInputBorder(),
              ),
              items: eventStatuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status[0].toUpperCase() + status.substring(1)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _status = value);
                  _notifyChanged();
                }
              },
            ),
            const SizedBox(height: 24),

            // Date and Time Section
            const Text('Date & Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Start Date & Time
            const Text('Start Date & Time *', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(DateFormat('MMM dd, yyyy').format(_startDate)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectTime(context, true),
                    child: Text(DateFormat('hh:mm a').format(_startDate)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // End Date & Time
            const Text('End Date & Time *', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(DateFormat('MMM dd, yyyy').format(_endDate)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectTime(context, false),
                    child: Text(DateFormat('hh:mm a').format(_endDate)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Location Section
            const Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Country Dropdown
            DropdownButtonFormField<String>(
              value: _locationCountry.isNotEmpty ? _locationCountry : null,
              decoration: const InputDecoration(
                labelText: 'Country *',
                border: OutlineInputBorder(),
              ),
              items: countries.map<DropdownMenuItem<String>>((country) {
                return DropdownMenuItem<String>(
                  value: country['name'] as String,
                  child: Text(country['name'] as String),
                );
              }).toList(),
              validator: (value) => _validateField('location.country', value ?? ''),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _locationCountry = value;
                    // Reset city when country changes
                    _locationCity = '';
                  });
                  _notifyChanged();
                }
              },
            ),
            const SizedBox(height: 16),

            // City Dropdown
            DropdownButtonFormField<String>(
              value: _locationCity.isNotEmpty ? _locationCity : null,
              decoration: const InputDecoration(
                labelText: 'City *',
                border: OutlineInputBorder(),
              ),
              items: _availableCities.map<DropdownMenuItem<String>>((city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              validator: (value) => _locationCountry.isEmpty 
                  ? 'Select a country first' 
                  : _validateField('location.city', value ?? ''),
              onChanged: _locationCountry.isEmpty
                  ? null
                  : (String? value) {
                      if (value != null) {
                        setState(() => _locationCity = value);
                        _notifyChanged();
                      }
                    },
            ),
            const SizedBox(height: 16),

            // Venue Name
            TextFormField(
              initialValue: _locationName,
              decoration: const InputDecoration(
                labelText: 'Venue Name *',
                border: OutlineInputBorder(),
                hintText: 'e.g. KICC, Nairobi',
              ),
              validator: (v) => _validateField('location.name', v ?? ''),
              onChanged: (v) {
                setState(() => _locationName = v);
                _notifyChanged();
              },
            ),
            const SizedBox(height: 16),

            // Address
            TextFormField(
              initialValue: _locationAddress,
              decoration: const InputDecoration(
                labelText: 'Address *',
                border: OutlineInputBorder(),
                hintText: 'Full address including street and building',
              ),
              validator: (v) => _validateField('location.address', v ?? ''),
              onChanged: (v) {
                setState(() => _locationAddress = v);
                _notifyChanged();
              },
            ),
            const SizedBox(height: 24),

            // Capacity
            TextFormField(
              initialValue: _capacity?.toString() ?? '',
              decoration: const InputDecoration(
                labelText: 'Capacity *',
                border: OutlineInputBorder(),
                hintText: 'Number of attendees',
                suffixText: 'people',
              ),
              keyboardType: TextInputType.number,
              validator: (v) => _validateField('capacity', v ?? ''),
              onChanged: (v) {
                setState(() => _capacity = int.tryParse(v));
                _notifyChanged();
              },
            ),
            const SizedBox(height: 16),

            // Ticket Price (Optional)
            TextFormField(
              initialValue: _ticketPrice?.toString() ?? '',
              decoration: const InputDecoration(
                labelText: 'Ticket Price (KES)',
                border: OutlineInputBorder(),
                hintText: 'Leave empty for free events',
                prefixText: 'KES ', 
                suffixText: '.00',
              ),
              keyboardType: TextInputType.number,
              validator: (v) => _validateField('ticketPrice', v ?? ''),
              onChanged: (v) {
                setState(() => _ticketPrice = int.tryParse(v));
                _notifyChanged();
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    widget.onSubmit(_buildEventModel());
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.initialEvent == null ? 'Create Event' : 'Update Event',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
