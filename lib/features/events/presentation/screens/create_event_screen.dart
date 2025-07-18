// features/events/presentation/pages/create_event_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/events_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

class CreateEventPage extends StatefulWidget {
  final String? eventId; // For editing existing event

  const CreateEventPage({
    super.key,
    this.eventId,
  });

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _capacityController = TextEditingController();
  final _ticketPriceController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _locationAddressController = TextEditingController();
  final _locationCityController = TextEditingController();
  final _locationPostalCodeController = TextEditingController();
  final _locationCountryController = TextEditingController();

  String _selectedType = AppConstants.eventTypes.first;
  String _selectedStatus = AppConstants.eventStatuses.first;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 1, hours: 2));
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  bool _isPublic = true;
  File? _coverImage;

  bool get _isEditing => widget.eventId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadEventData();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    _ticketPriceController.dispose();
    _locationNameController.dispose();
    _locationAddressController.dispose();
    _locationCityController.dispose();
    _locationPostalCodeController.dispose();
    _locationCountryController.dispose();
    super.dispose();
  }

  void _loadEventData() {
    final eventsProvider = context.read<EventsProvider>();
    final event = eventsProvider.selectedEvent;

    if (event != null) {
      _titleController.text = event.title;
      _descriptionController.text = event.description;
      _capacityController.text = event.capacity?.toString() ?? '';
      _ticketPriceController.text = event.ticketPrice.toString();
      _selectedType = event.type;
      _selectedStatus = event.status;
      _startDate = event.startDate;
      _endDate = event.endDate;
      _startTime = TimeOfDay.fromDateTime(event.startDate);
      _endTime = TimeOfDay.fromDateTime(event.endDate);
      _isPublic = event.isPublic;
      _locationNameController.text = event.location.name;
      _locationAddressController.text = event.location.address;
      _locationCityController.text = event.location.city;
      _locationPostalCodeController.text = event.location.postalCode ?? '';
      _locationCountryController.text = event.location.country;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Event' : 'Create Event'),
        actions: [
          Consumer<EventsProvider>(
            builder: (context, eventsProvider, child) {
              return TextButton(
                onPressed: eventsProvider.isCreating ? null : _saveEvent,
                child: eventsProvider.isCreating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Update' : 'Create'),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoverImageSection(),
              const SizedBox(height: 24),
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildDateTimeSection(),
              const SizedBox(height: 24),
              _buildLocationSection(),
              const SizedBox(height: 24),
              _buildSettingsSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cover Image',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickCoverImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.outline),
                  color: AppColors.surfaceLight,
                ),
                child: _coverImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _coverImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap to add cover image',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Event Title',
                hintText: 'Enter event title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter event description',
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
