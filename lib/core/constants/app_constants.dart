// core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'ComfyBase';
  static const String appVersion = '1.0.0';

  // User roles
  static const String organizerRole = 'organizer';
  static const String attendeeRole = 'attendee';

  // Event types
  static const List<String> eventTypes = [
    'conference',
    'workshop',
    'seminar',
    'expo',
    'networking',
  ];

  // Event statuses
  static const List<String> eventStatuses = [
    'draft',
    'published',
    'cancelled',
    'completed',
  ];

  // Supported image formats
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
  ];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
