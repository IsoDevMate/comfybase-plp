import 'package:equatable/equatable.dart';
import 'exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => 'Failure: $message';
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server error', int? statusCode})
      : super(message, statusCode: statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection'])
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error'])
      : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error'])
      : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String message = 'Unauthorized'])
      : super(message, statusCode: 401);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([String message = 'Forbidden'])
      : super(message, statusCode: 403);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Not found'])
      : super(message, statusCode: 404);
}

class ConflictFailure extends Failure {
  const ConflictFailure([String message = 'Conflict'])
      : super(message, statusCode: 409);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure([String message = 'Bad request'])
      : super(message, statusCode: 400);
}

class InternalServerErrorFailure extends Failure {
  const InternalServerErrorFailure([String message = 'Internal server error'])
      : super(message, statusCode: 500);
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure([String message = 'Service unavailable'])
      : super(message, statusCode: 503);
}

// A utility function to convert exceptions to failures
Failure mapExceptionToFailure(dynamic exception) {
  if (exception is NetworkException) {
    return const NetworkFailure('Network error occurred');
  } else if (exception is ServerException) {
    return ServerFailure(
      message: exception.message,
      statusCode: exception.statusCode,
    );
  } else if (exception is UnauthorizedException) {
    return const UnauthorizedFailure();
  } else if (exception is ForbiddenException) {
    return const ForbiddenFailure();
  } else if (exception is NotFoundException) {
    return const NotFoundFailure();
  } else if (exception is ConflictException) {
    return const ConflictFailure();
  } else if (exception is BadRequestException) {
    return const BadRequestFailure();
  } else if (exception is InternalServerErrorException) {
    return const InternalServerErrorFailure();
  } else if (exception is ServiceUnavailableException) {
    return const ServiceUnavailableFailure();
  } else if (exception is CacheException) {
    return const CacheFailure();
  } else if (exception is ValidationException) {
    return const ValidationFailure();
  } else {
    return ServerFailure(message: 'Unexpected error: ${exception?.toString() ?? 'Unknown error'}');
  }
}
