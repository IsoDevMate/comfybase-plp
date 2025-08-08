import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String? imageUrl;
  final int maxAttendees;
  final List<String> attendees;
  final String organizerId;
  final bool isOnline;
  final String? meetingUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.imageUrl,
    required this.maxAttendees,
    required this.attendees,
    required this.organizerId,
    this.isOnline = false,
    this.meetingUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startDate,
        endDate,
        location,
        imageUrl,
        maxAttendees,
        attendees,
        organizerId,
        isOnline,
        meetingUrl,
        createdAt,
        updatedAt,
      ];

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    String? imageUrl,
    int? maxAttendees,
    List<String>? attendees,
    String? organizerId,
    bool? isOnline,
    String? meetingUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      attendees: attendees ?? this.attendees,
      organizerId: organizerId ?? this.organizerId,
      isOnline: isOnline ?? this.isOnline,
      meetingUrl: meetingUrl ?? this.meetingUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
