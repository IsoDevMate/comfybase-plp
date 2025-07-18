import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}

@JsonSerializable()
class EventLocation {
  final String name;
  final String address;
  final String city;
  final String country;
  final Coordinates? coordinates;

  EventLocation({
    required this.name,
    required this.address,
    required this.city,
    required this.country,
    this.coordinates,
  });

  factory EventLocation.fromJson(Map<String, dynamic> json) =>
      _$EventLocationFromJson(json);
  Map<String, dynamic> toJson() => _$EventLocationToJson(this);
}

@JsonSerializable()
class EventModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  final dynamic organizer;
  final String type;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final EventLocation location;
  final int? capacity;
  final int? ticketPrice;
  final String? coverImage;
  final List<dynamic> sessions;
  final List<dynamic> attendees;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizer,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.capacity,
    this.ticketPrice,
    this.coverImage,
    required this.sessions,
    required this.attendees,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
