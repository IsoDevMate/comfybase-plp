import 'dart:io';
import 'package:kenyanvalley/core/network/api_client.dart';
import '../models/event_model.dart';
import 'package:dio/dio.dart';
import 'package:kenyanvalley/core/constants/api_constants.dart';

class EventService {
  final ApiClient _apiClient = ApiClient();

  // Get all events
  Future<List<EventModel>> getEvents() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiConstants.events,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    final eventsJson = (response.data?['events'] ?? []) as List;
    return eventsJson
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Get single event by ID
  Future<EventModel> getEventById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiConstants.getEventById + id,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return EventModel.fromJson(response.data!);
  }

  // Create event
  Future<EventModel> createEvent(EventModel event) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiConstants.createEvent,
      data: event.toJson(),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return EventModel.fromJson(response.data!);
  }

  // Update event
  Future<EventModel> updateEvent(String id, EventModel event) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      ApiConstants.updateEvent + id,
      data: event.toJson(),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return EventModel.fromJson(response.data!);
  }

  // Delete event
  Future<void> deleteEvent(String id) async {
    await _apiClient.delete<Map<String, dynamic>>(
      ApiConstants.deleteEvent + id,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // Upload cover image
  Future<String?> uploadCoverImage(String eventId, File imageFile) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imageFile.path),
    });
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiConstants.coverImage + '$eventId/cover-image',
      data: formData,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return response.data?['coverImageUrl'] as String?;
  }

  // Register for an event
  Future<void> registerForEvent(String eventId) async {
    await _apiClient.post<Map<String, dynamic>>(
      ApiConstants.registerEvent + '/$eventId',
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // Unregister from an event
  Future<void> unregisterFromEvent(String eventId) async {
    await _apiClient.delete<Map<String, dynamic>>(
      ApiConstants.unregisterEvent + eventId,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // Get events the user is registered for
  Future<List<EventModel>> getMyEvents() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiConstants.myEvents,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    final eventsJson = (response.data?['events'] ?? []) as List;
    return eventsJson
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Get events organized by the user
  Future<List<EventModel>> getOrganizerEvents() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiConstants.organizerEvents,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    final eventsJson = (response.data?['events'] ?? []) as List;
    return eventsJson
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Get attendees for an event
  Future<List<dynamic>> getAttendees(String eventId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiConstants.attendeesOneEvent + '$eventId/attendees',
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return (response.data?['attendees'] ?? []) as List<dynamic>;
  }
}
