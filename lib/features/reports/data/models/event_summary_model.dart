class EventSummary {
  final String eventTitle;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String type;
  final String status;
  final int attendeeCount;
  final int capacity;
  final String ticketPrice;

  EventSummary({
    required this.eventTitle,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.type,
    required this.status,
    required this.attendeeCount,
    required this.capacity,
    required this.ticketPrice,
  });

  factory EventSummary.fromCsv(Map<String, dynamic> csvRow) {
    return EventSummary(
      eventTitle: csvRow['Event Title'] ?? '',
      startDate: DateTime.parse(csvRow['Start Date'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(csvRow['End Date'] ?? DateTime.now().toIso8601String()),
      location: csvRow['Location'] ?? '',
      type: csvRow['Type'] ?? '',
      status: csvRow['Status'] ?? '',
      attendeeCount: int.tryParse(csvRow['Attendee Count'] ?? '0') ?? 0,
      capacity: int.tryParse(csvRow['Capacity'] ?? '0') ?? 0,
      ticketPrice: csvRow['Ticket Price'] ?? '0',
    );
  }
}
