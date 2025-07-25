// features/events/presentation/pages/create_event_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../../data/models/event_model.dart';
import '../widgets/event_form.dart';
import '../widgets/event_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_dimensions.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class CreateEventPage extends StatefulWidget {
  final EventModel? initialEvent;

  const CreateEventPage({Key? key, this.initialEvent}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage>
    with TickerProviderStateMixin {
  DateTime? _startDate;
  DateTime? _endDate;
  EventModel? _previewEvent;
  bool _isSubmitting = false;
  int _currentStep = 0;
  bool _showPreview = false;

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late List<Animation<double>> _stepAnimations;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;
  late Animation<Color?> _submitButtonColorAnimation;

  final PageController _pageController = PageController();
  final List<String> _stepTitles = [
    'Basic Info',
    'Details',
    'Location',
    'Preview'
  ];

  @override
  void initState() {
    super.initState();
    _previewEvent = widget.initialEvent;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _stepAnimations = List.generate(
      4,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.15,
            0.4 + (index * 0.15),
            curve: Curves.elasticOut,
          ),
        ),
      ),
    );

    _floatingAnimation = Tween<double>(begin: -3.0, end: 3.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _submitButtonColorAnimation = ColorTween(
      begin: AppColors.primary,
      end: AppColors.success,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.8, 1.0),
    ));

    _animationController.forward();
    _updateProgress();
  }

  void _updateProgress() {
    _progressController.animateTo(_currentStep / (_stepTitles.length - 1));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildModernHeader(),
            _buildProgressIndicator(),
            Expanded(
              child: Consumer<EventsProvider>(
                builder: (context, eventsProvider, child) {
                  return AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primaryLight.withOpacity(0.05),
                                AppColors.background,
                              ],
                            ),
                          ),
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentStep = index;
                                _showPreview = index == _stepTitles.length - 1;
                                _updateProgress();
                              });
                            },
                            children: [
                              _buildStepContent(0, _buildBasicInfoStep()),
                              _buildStepContent(1, _buildDetailsStep()),
                              _buildStepContent(2, _buildLocationStep()),
                              _buildStepContent(3, _buildPreviewStep()),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    widget.initialEvent == null ? '✨ Create New Event' : '✏️ Edit Event',
                    key: ValueKey(widget.initialEvent == null),
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Step ${_currentStep + 1} of ${_stepTitles.length}: ${_stepTitles[_currentStep]}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Live Preview',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        children: [
          // Progress Bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Step Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_stepTitles.length, (index) {
              return AnimatedBuilder(
                animation: _stepAnimations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _stepAnimations[index].value,
                    child: _buildStepIndicator(index),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int index) {
    final isActive = index == _currentStep;
    final isCompleted = index < _currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: isActive || isCompleted
            ? LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              )
            : null,
        color: isActive || isCompleted ? null : AppColors.outline.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted
                ? Icons.check_circle
                : isActive
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
            size: 16,
            color: isActive || isCompleted ? Colors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            _stepTitles[index],
            style: AppTextStyles.bodySmall.copyWith(
              color: isActive || isCompleted ? Colors.white : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int stepIndex, Widget content) {
    return AnimatedBuilder(
      animation: _stepAnimations[stepIndex],
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _stepAnimations[stepIndex].value)),
          child: Opacity(
            opacity: _stepAnimations[stepIndex].value,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: content,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBasicInfoStep() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppColors.primaryLight.withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Basic Information',
              'Let\'s start with the essentials',
              Icons.info_outline,
            ),
            const SizedBox(height: 24),

            // Event Title
            _buildAnimatedTextField(
              label: 'Event Title',
              hint: 'Enter your event title...',
              icon: Icons.title,
              maxLines: 1,
            ),
            const SizedBox(height: 20),

            // Event Description
            _buildAnimatedTextField(
              label: 'Description',
              hint: 'Describe your event...',
              icon: Icons.description,
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            // Category Selection
            _buildCategorySelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsStep() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppColors.secondary.withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Event Details',
              'When and how much?',
              Icons.event_note,
            ),
            const SizedBox(height: 24),

            // Date and Time
            Row(
              children: [
                Expanded(
                  child: _buildDateTimePicker(
                    label: 'Start Date & Time',
                    icon: Icons.schedule,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateTimePicker(
                    label: 'End Date & Time',
                    icon: Icons.schedule_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Ticket Price
            _buildAnimatedTextField(
              label: 'Ticket Price (KSH)',
              hint: 'Enter 0 for free events',
              icon: Icons.payments,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Max Attendees
            _buildAnimatedTextField(
              label: 'Maximum Attendees',
              hint: 'Leave empty for unlimited',
              icon: Icons.people,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStep() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppColors.success.withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Location Details',
              'Where will it happen?',
              Icons.location_on,
            ),
            const SizedBox(height: 24),

            // Event Type Toggle
            _buildEventTypeToggle(),
            const SizedBox(height: 20),

            // Address
            _buildAnimatedTextField(
              label: 'Venue/Address',
              hint: 'Enter venue name or address...',
              icon: Icons.business,
            ),
            const SizedBox(height: 20),

            // City and Country
            Row(
              children: [
                Expanded(
                  child: _buildAnimatedTextField(
                    label: 'City',
                    hint: 'Enter city...',
                    icon: Icons.location_city,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAnimatedTextField(
                    label: 'Country',
                    hint: 'Enter country...',
                    icon: Icons.public,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Preview Your Event',
          'This is how your event will look',
          Icons.visibility,
        ),
        const SizedBox(height: 24),

        if (_previewEvent != null)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: EventCard(event: _previewEvent!),
                ),
              );
            },
          )
        else
          _buildEmptyPreview(),

        const SizedBox(height: 32),

        // Success Message
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.success.withOpacity(0.1),
                AppColors.success.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: AppColors.success.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to Publish!',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your event looks great! Review the details and hit publish when ready.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedTextField({
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide(
              color: AppColors.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      'Conference', 'Workshop', 'Networking', 'Social',
      'Sports', 'Music', 'Art', 'Technology'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = false; // Add your selection logic
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  // Handle selection
                },
                backgroundColor: Colors.white,
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.outline.withOpacity(0.3),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate 
          ? _startDate ?? now
          : _endDate ?? (_startDate ?? now).add(const Duration(hours: 1)),
      firstDate: isStartDate ? now : _startDate ?? now,
      lastDate: DateTime(now.year + 2),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: isStartDate
            ? TimeOfDay.fromDateTime(_startDate ?? now)
            : TimeOfDay.fromDateTime(_endDate ?? now.add(const Duration(hours: 1))),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
        },
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStartDate) {
            _startDate = selectedDateTime;
            // If end date is before start date, update it to be 1 hour after start
            if (_endDate == null || _endDate!.isBefore(selectedDateTime)) {
              _endDate = selectedDateTime.add(const Duration(hours: 1));
            }
          } else {
            // Ensure end date is after start date
            if (selectedDateTime.isAfter(_startDate ?? now)) {
              _endDate = selectedDateTime;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('End date must be after start date'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
      }
    }
  }

  Widget _buildDateTimePicker({required String label, required IconData icon}) {
    final bool isStartDate = label.toLowerCase().contains('start');
    final selectedDate = isStartDate ? _startDate : _endDate;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _selectDateTime(context, isStartDate),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: AppColors.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
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
                    const SizedBox(height: 2),
                    Text(
                      selectedDate != null
                          ? '${DateFormat('MMM d, y').format(selectedDate)} • ${DateFormat('h:mm a').format(selectedDate)}'
                          : 'Select date & time',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: selectedDate != null ? FontWeight.w500 : null,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.outline.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleOption('Physical', Icons.location_on, true),
          ),
          Expanded(
            child: _buildToggleOption('Virtual', Icons.computer, false),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String title, IconData icon, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPreview() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.outline.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(
          color: AppColors.outline.withOpacity(0.3),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.preview,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Preview Not Available',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in the event details to see your preview',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous Button
            if (_currentStep > 0)
              Expanded(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.95 + (0.05 * _pulseAnimation.value),
                      child: Container(
                        height: 56,
                        margin: const EdgeInsets.only(right: 8),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Next/Submit Button
            Expanded(
              flex: _currentStep > 0 ? 1 : 2,
              child: AnimatedBuilder(
                animation: Listenable.merge([_pulseAnimation, _submitButtonColorAnimation]),
                builder: (context, child) {
                  final isLastStep = _currentStep == _stepTitles.length - 1;
                  return Transform.scale(
                    scale: 0.95 + (0.05 * _pulseAnimation.value),
                    child: Container(
                      height: 56,
                      margin: EdgeInsets.only(left: _currentStep > 0 ? 8 : 0),
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : () async {
                          if (isLastStep) {
                            // Submit the form
                            setState(() => _isSubmitting = true);
                            await _submitEvent();
                            setState(() => _isSubmitting = false);
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        icon: _isSubmitting
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Icon(
                                isLastStep ? Icons.publish : Icons.arrow_forward,
                                color: Colors.white,
                              ),
                        label: Text(
                          _isSubmitting
                              ? 'Publishing...'
                              : isLastStep
                                  ? 'Publish Event'
                                  : 'Next',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _submitButtonColorAnimation.value ?? AppColors.primary,
                          elevation: 8,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitEvent() async {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);

    // Create a dummy event for demonstration
    // Replace this with actual form data collection
    final eventData = EventModel(
      id: widget.initialEvent?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Sample Event Title',
      description: 'Sample Description',
      organizer: {
        'id': 'current_user_id',
        'firstName': 'Current',
        'lastName': 'User',
        'email': 'user@example.com'
      },
      type: 'conference', // Default type, should come from form
      status: 'draft', // Default status
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 7, hours: 3)),
      location: EventLocation(
        name: 'Venue Name',
        address: '123 Main St',
        city: 'Nairobi',
        country: 'Kenya',
      ),
      capacity: 100, // Default capacity
      ticketPrice: 0, // Default to free
      sessions: [],
      attendees: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      final success = widget.initialEvent == null
          ? await eventsProvider.createEvent(eventData)
          : await eventsProvider.updateEvent(eventData.id, eventData);

      if (success) {
        // Show success animation
        _animationController.forward();

        // Navigate back with success
        Navigator.pop(context, true);

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.initialEvent == null
                        ? '🎉 Event created successfully!'
                        : '✅ Event updated successfully!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    eventsProvider.error ?? 'Failed to save event. Please try again.',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
