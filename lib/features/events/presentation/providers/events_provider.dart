import 'package:flutter/material.dart';
import '../../data/datasources/events_service.dart';
import '../../data/models/event_model.dart';

class EventsProvider extends ChangeNotifier {
  final EventService _eventService = EventService();

  List<EventModel> _events = [];
  List<EventModel> get events => _events;

  EventModel? _selectedEvent;
  EventModel? get selectedEvent => _selectedEvent;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  String? _error;
  String? get error => _error;

  // Fetch all events
  Future<void> fetchEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _events = await _eventService.getEvents();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // Fetch event by ID
  Future<void> fetchEventById(String eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _selectedEvent = await _eventService.getEventById(eventId);
    } catch (e) {
      _error = e.toString();
      _selectedEvent = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  // Create event
  Future<bool> createEvent(EventModel event) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final created = await _eventService.createEvent(event);
      _events.add(created);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update event
  Future<bool> updateEvent(String eventId, EventModel event) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final updated = await _eventService.updateEvent(eventId, event);
      final idx = _events.indexWhere((e) => e.id == eventId);
      if (idx != -1) {
        _events[idx] = updated;
      }
      if (_selectedEvent?.id == eventId) _selectedEvent = updated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete event
  Future<bool> deleteEvent(String eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _eventService.deleteEvent(eventId);
      _events.removeWhere((e) => e.id == eventId);
      if (_selectedEvent?.id == eventId) _selectedEvent = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get events the user is registered for
  Future<void> getMyEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _events = await _eventService.getMyEvents();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // Get events organized by the current user
  Future<void> getOrganizerEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _events = await _eventService.getOrganizerEvents();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // Register for free event
  Future<bool> registerForFreeEvent(String eventId) async {
    _isRegistering = true;
    _error = null;
    notifyListeners();
    try {
      await _eventService.registerForEvent(eventId);
      _isRegistering = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isRegistering = false;
      notifyListeners();
      return false;
    }
  }

  // Register for paid event (stub, add payment logic as needed)
  Future<bool> registerForPaidEvent(String eventId, String phoneNumber) async {
    _isRegistering = true;
    _error = null;
    notifyListeners();
    try {
      // TODO: Add payment logic here
      await _eventService.registerForEvent(eventId);
      _isRegistering = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isRegistering = false;
      notifyListeners();
      return false;
    }
  }

  // Pagination stub (implement as needed)
  Future<void> loadMoreEvents() async {
    // TODO: Implement pagination logic
    // Set _isLoadingMore = true, fetch more, append to _events, set _isLoadingMore = false
  }
}
