// core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://final-year-project-5d85.onrender.com';
  static const String apiVersion = '/api/v1';

  // Auth endpoints
  static const String register = '$apiVersion/auth/register';
  static const String login = '$apiVersion/auth/login';
  static const String refreshToken = '$apiVersion/auth/refresh-token';
  static const String profile = '$apiVersion/auth/me';
  static const String forgotPassword = '$apiVersion/auth/forgot-password';
  static const String generateQR = '$apiVersion/auth/generate-qr-code';
  static const String verifyQR = '$apiVersion/auth/verify-qr-code';
  static const String linkedin = '$apiVersion/auth/linkedin';
  static const String updateProfile = '$apiVersion/auth/update-profile';
  static const String linkedinProfile = '$apiVersion/auth/profile';

  // Events endpoints
  static const String events = '$apiVersion/events';
  static const String createEvent = '$apiVersion/events';
  static const String updateEvent = '$apiVersion/events/'; // +:id
  static const String deleteEvent = '$apiVersion/events/'; // +:id
  static const String getEventById = '$apiVersion/events/'; // +:id
  static const String coverImage = '$apiVersion/events/'; // +:id/cover-image
  static const String registerEvent = '$apiVersion/events/register';
  static const String unregisterEvent = '$apiVersion/events/register/'; // +:id
  static const String myEvents = '$apiVersion/events/registered';
  static const String organizerEvents = '$apiVersion/events/organizer/events';
  static const String attendeesOneEvent =
      '$apiVersion/events/'; // +:id/attendees

  // Notes endpoints
  static const String notes = '$apiVersion/notes';
  static const String getNoteById = '$apiVersion/notes/'; // +:id
  static const String updateNote = '$apiVersion/notes/'; // +:id
  static const String shareNote = '$apiVersion/notes/'; // +:id/share
  static const String unshareNote = '$apiVersion/notes/'; // +:id/unshare
  static const String addMediaAttachment = '$apiVersion/notes/'; // +:id/media
  static const String deleteAttachment =
      '$apiVersion/notes/'; // +:id/media/:attachmentId

  // Sessions endpoints
  static const String sessions = '$apiVersion/sessions';
  static const String createSession = '$apiVersion/sessions/create';

  // Payments & Subscriptions endpoints
  static const String payments = '$apiVersion/payments';
  static const String checkoutSession = '$apiVersion/payments/checkout';
  static const String createSubscription = '$apiVersion/payments';
  static const String cancelSubscription =
      '$apiVersion/payments/'; // +:id/cancel
  static const String checkSubscriptionStatus = '$apiVersion/payments/status';
  static const String getSubscription = '$apiVersion/payments';

  // Mpesa endpoints
  static const String mpesaInitiate = '$apiVersion/mpesa/event/'; // +:id
  static const String mpesaCallback =
      '$apiVersion/mpesa/callback/'; // +:eventId/:userId
  static const String mpesaStatusQuery = '$apiVersion/mpesa/status';

  // Reports endpoints
  static const String eventSummary = '$apiVersion/reports/events/summary';
  static const String attendeesReport =
      '$apiVersion/reports/events/'; // +:eventId/attendees

  // LinkedIn endpoints
  static const String linkedinStatus = '$apiVersion/linkedin/status';
  static const String linkedinShareNote =
      '$apiVersion/linkedin/share/note/'; // +:noteId
  static const String linkedinShareText = '$apiVersion/linkedin/share/text';
  static const String linkedinShareImage = '$apiVersion/linkedin/share/image';
  static const String linkedinShareArticle =
      '$apiVersion/linkedin/share/article';

  // Request timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}
