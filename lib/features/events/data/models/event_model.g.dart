// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

EventLocation _$EventLocationFromJson(Map<String, dynamic> json) =>
    EventLocation(
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      coordinates: json['coordinates'] == null
          ? null
          : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventLocationToJson(EventLocation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'country': instance.country,
      'coordinates': instance.coordinates,
    };

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      organizer: json['organizer'],
      type: json['type'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      location:
          EventLocation.fromJson(json['location'] as Map<String, dynamic>),
      capacity: (json['capacity'] as num?)?.toInt(),
      ticketPrice: (json['ticketPrice'] as num?)?.toInt(),
      coverImage: json['coverImage'] as String?,
      sessions: json['sessions'] as List<dynamic>,
      attendees: json['attendees'] as List<dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'organizer': instance.organizer,
      'type': instance.type,
      'status': instance.status,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'location': instance.location,
      'capacity': instance.capacity,
      'ticketPrice': instance.ticketPrice,
      'coverImage': instance.coverImage,
      'sessions': instance.sessions,
      'attendees': instance.attendees,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
