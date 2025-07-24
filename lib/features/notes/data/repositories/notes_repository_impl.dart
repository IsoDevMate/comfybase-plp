import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kenyanvalley/core/error/exceptions.dart';
import 'package:kenyanvalley/core/error/failures.dart';
import 'package:kenyanvalley/features/notes/data/datasources/notes_service.dart';
import 'package:kenyanvalley/features/notes/data/models/note_model.dart';
import 'package:kenyanvalley/features/notes/domain/repositories/notes_repository.dart';

/// Maps exceptions to failures
Failure _mapExceptionToFailure(dynamic exception) {
  if (exception is NetworkException) {
    return const NetworkFailure();
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

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;

  NotesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Note>>> getNotes({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final notes = await remoteDataSource.getNotes(
        page: page,
        limit: limit,
      );
      return Right(notes);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Note>> getNoteById(String id) async {
    try {
      final note = await remoteDataSource.getNoteById(id);
      return Right(note);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
    String? eventId,
    List<String>? tags,
    bool isPrivate = true,
  }) async {
    try {
      final note = await remoteDataSource.createNote(
        title: title,
        content: content,
        eventId: eventId,
        tags: tags,
        isPrivate: isPrivate,
      );
      return Right(note);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote({
    required String id,
    String? title,
    String? content,
    List<String>? tags,
    bool? isPrivate,
  }) async {
    try {
      final note = await remoteDataSource.updateNote(
        id: id,
        title: title,
        content: content,
        tags: tags,
        isPrivate: isPrivate,
      );
      return Right(note);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Note>> shareNote(String id, String userId) async {
    try {
      final note = await remoteDataSource.shareNote(id, userId);
      return Right(note);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Note>> unshareNote(String id, String userId) async {
    try {
      final note = await remoteDataSource.unshareNote(id, userId);
      return Right(note);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Note>> addMediaAttachment({
    required String noteId,
    required String filePath,
    String? caption,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return Left(ServerFailure(message: 'File does not exist'));
      }
      
      final note = await remoteDataSource.addMediaAttachment(
        noteId: noteId,
        file: file,
        caption: caption,
      );
      return Right(note);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttachment({
    required String noteId,
    required String attachmentId,
  }) async {
    try {
      await remoteDataSource.deleteAttachment(
        noteId: noteId,
        attachmentId: attachmentId,
      );
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}
