import 'package:dio/dio.dart';

// Base exception class
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

// Network related exceptions
class NetworkException extends AppException {
  NetworkException([String message = 'No internet connection'])
      : super(message);

  factory NetworkException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.sendTimeout:
        return NetworkException('Send timeout');
      case DioExceptionType.receiveTimeout:
        return NetworkException('Receive timeout');
      case DioExceptionType.badResponse:
        return NetworkException('Bad response from server');
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      default:
        return NetworkException('Network error occurred');
    }
  }
}

// Server related exceptions
class ServerException extends AppException {
  ServerException({String message = 'Server error', int? statusCode})
      : super(message, statusCode: statusCode);

  factory ServerException.fromDioError(DioException error) {
    if (error.response?.data != null &&
        error.response?.data is Map<String, dynamic>) {
      final data = error.response!.data as Map<String, dynamic>;
      final message = data['message'] ?? 'Server error';
      return ServerException(
        message: message,
        statusCode: error.response?.statusCode,
      );
    }
    return ServerException(
      message: error.message ?? 'Server error',
      statusCode: error.response?.statusCode,
    );
  }
}

// Cache related exceptions
class CacheException extends AppException {
  CacheException([String message = 'Cache error']) : super(message);
}

// Validation exceptions
class ValidationException extends AppException {
  ValidationException([String message = 'Validation error']) : super(message);
}

// Authentication exceptions
class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Unauthorized'])
      : super(message, statusCode: 401);
}

// Forbidden exceptions
class ForbiddenException extends AppException {
  ForbiddenException([String message = 'Forbidden'])
      : super(message, statusCode: 403);
}

// Not found exceptions
class NotFoundException extends AppException {
  NotFoundException([String message = 'Not found'])
      : super(message, statusCode: 404);
}

// Conflict exceptions
class ConflictException extends AppException {
  ConflictException([String message = 'Conflict'])
      : super(message, statusCode: 409);
}

// Bad request exceptions
class BadRequestException extends AppException {
  BadRequestException([String message = 'Bad request'])
      : super(message, statusCode: 400);
}

// Internal server error exceptions
class InternalServerErrorException extends AppException {
  InternalServerErrorException([String message = 'Internal server error'])
      : super(message, statusCode: 500);
}

// Service unavailable exceptions
class ServiceUnavailableException extends AppException {
  ServiceUnavailableException([String message = 'Service unavailable'])
      : super(message, statusCode: 503);
}
