import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:kenyanvalley/core/constants/api_constants.dart';
import 'package:kenyanvalley/features/reports/data/models/event_summary_model.dart';
import 'package:kenyanvalley/core/network/api_client.dart';

class ReportsService {
  final ApiClient _apiClient;

  ReportsService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<EventSummary>> getEventSummaries() async {
    try {
      final response = await _apiClient.get(ApiConstants.eventSummary);
      
      if (response.statusCode == 200) {
        // Parse CSV response
        final csvString = response.data.toString();
        final rows = const CsvToListConverter().convert(csvString);
        
        if (rows.isEmpty) return [];
        
        // Get headers from first row
        final headers = (rows[0] as List).cast<String>();
        
        // Convert remaining rows to EventSummary objects
        return rows.skip(1).map((row) {
          final rowMap = <String, dynamic>{};
          for (var i = 0; i < row.length && i < headers.length; i++) {
            rowMap[headers[i]] = row[i];
          }
          return EventSummary.fromCsv(rowMap);
        }).toList();
      } else {
        throw Exception('Failed to load event summaries');
      }
    } catch (e) {
      throw Exception('Error fetching event summaries: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getEventAttendees(String eventId) async {
    try {
      final response = await _apiClient.get('${ApiConstants.attendeesReport}$eventId/attendees');
      
      if (response.statusCode == 200) {
        // Assuming the response is a list of attendees
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load event attendees');
      }
    } catch (e) {
      throw Exception('Error fetching event attendees: $e');
    }
  }
}
