import 'package:flutter/foundation.dart';
import 'package:kenyanvalley/features/reports/data/datasources/reports_service.dart';
import 'package:kenyanvalley/features/reports/data/models/event_summary_model.dart';

class ReportsProvider extends ChangeNotifier {
  final ReportsService _reportsService;
  
  List<EventSummary> _eventSummaries = [];
  List<EventSummary> get eventSummaries => _eventSummaries;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  ReportsProvider({ReportsService? reportsService})
      : _reportsService = reportsService ?? ReportsService();
  
  Future<void> fetchEventSummaries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _eventSummaries = await _reportsService.getEventSummaries();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<List<Map<String, dynamic>>> fetchEventAttendees(String eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final attendees = await _reportsService.getEventAttendees(eventId);
      _error = null;
      return attendees;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
