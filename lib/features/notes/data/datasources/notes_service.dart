import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kenyanvalley/core/constants/api_constants.dart';
import 'package:kenyanvalley/core/error/exceptions.dart';
import 'package:kenyanvalley/core/network/network_info.dart';
import 'package:kenyanvalley/features/notes/data/models/note_model.dart';
import 'package:kenyanvalley/core/error/failures.dart';

abstract class NotesRemoteDataSource {
  Future<List<Note>> getNotes({int page = 1, int limit = 10});
  Future<Note> getNoteById(String id);
  Future<Note> createNote({
    required String title,
    required String content,
    String? eventId,
    List<String>? tags,
    bool isPrivate = true,
  });
  Future<Note> updateNote({
    required String id,
    String? title,
    String? content,
    List<String>? tags,
    bool? isPrivate,
  });
  Future<Note> shareNote(String id, String userId);
  Future<Note> unshareNote(String id, String userId);
  Future<Note> addMediaAttachment({
    required String noteId,
    required File file,
    String? caption,
  });
  Future<void> deleteAttachment({
    required String noteId,
    required String attachmentId,
  });
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final Dio dio;
  final NetworkInfo networkInfo;

  NotesRemoteDataSourceImpl({
    required this.dio,
    required this.networkInfo,
  });

  @override
  Future<List<Note>> getNotes({int page = 1, int limit = 10}) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }

    try {
      final response = await dio.get(
        ApiConstants.notes,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        // Handle different possible response formats
        if (response.data is List) {
          // Case 1: Response is a direct list of notes
          return (response.data as List).map((json) => Note.fromJson(json)).toList();
        } else if (response.data is Map) {
          final responseData = response.data as Map<String, dynamic>;
          
          // Case 2: Response has a 'data' field containing the notes
          if (responseData.containsKey('data') && responseData['data'] is List) {
            return (responseData['data'] as List).map((json) => Note.fromJson(json)).toList();
          }
          
          // Case 3: Response has a 'notes' field containing the notes
          if (responseData.containsKey('notes') && responseData['notes'] is List) {
            return (responseData['notes'] as List).map((json) => Note.fromJson(json)).toList();
          }
        }
        
        // If we get here, the response format is unexpected
        throw ServerException(
          message: 'Invalid response format',
          statusCode: response.statusCode,
        );
      } else {
        throw ServerException(
          message: 'Failed to load notes',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.response != null) {
        throw ServerException.fromDioError(e);
      } else {
        throw ServerException(message: 'Failed to load notes');
      }
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<Note> getNoteById(String id) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }

    try {
      final response = await dio.get('${ApiConstants.notes}/$id');
      
      if (response.statusCode == 200) {
        return Note.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to load note');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<Note> createNote({
    required String title,
    required String content,
    String? eventId,
    List<String>? tags,
    bool isPrivate = true,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }

    try {
      final response = await dio.post(
        ApiConstants.notes,
        data: {
          'title': title,
          'content': content,
          if (eventId != null) 'event': eventId,
          if (tags != null && tags.isNotEmpty) 'tags': tags,
          'isPrivate': isPrivate,
        },
      );
      
      if (response.statusCode == 201) {
        return Note.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to create note');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<Note> updateNote({
    required String id,
    String? title,
    String? content,
    List<String>? tags,
    bool? isPrivate,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }

    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (tags != null) data['tags'] = tags;
      if (isPrivate != null) data['isPrivate'] = isPrivate;

      final response = await dio.put(
        '${ApiConstants.notes}/$id',
        data: data,
      );
      
      if (response.statusCode == 200) {
        return Note.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to update note');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<Note> shareNote(String id, String userId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }

    try {
      final response = await dio.post(
        '${ApiConstants.notes}/$id/share',
        data: {'userId': userId},
      );
      
      if (response.statusCode == 200) {
        return Note.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to share note');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<Note> unshareNote(String id, String userId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }

    try {
      final response = await dio.post(
        '${ApiConstants.notes}/$id/unshare',
        data: {'userId': userId},
      );
      
      if (response.statusCode == 200) {
        return Note.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to unshare note');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<Note> addMediaAttachment({
    required String noteId,
    required File file,
    String? caption,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        ),
        if (caption != null) 'caption': caption,
      });

      final response = await dio.post(
        '${ApiConstants.notes}/$noteId/media',
        data: formData,
      );
      
      if (response.statusCode == 200) {
        return Note.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to upload attachment');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteAttachment({
    required String noteId,
    required String attachmentId,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }

    try {
      final response = await dio.delete(
        '${ApiConstants.notes}/$noteId/media/$attachmentId',
      );
      
      if (response.statusCode != 200) {
        throw ServerException(message: 'Failed to delete attachment');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    }
  }
}
