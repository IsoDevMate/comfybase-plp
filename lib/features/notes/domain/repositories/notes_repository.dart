import 'package:dartz/dartz.dart';
import 'package:kenyanvalley/core/error/failures.dart';
import 'package:kenyanvalley/features/notes/data/models/note_model.dart';

abstract class NotesRepository {
  Future<Either<Failure, List<Note>>> getNotes({int page, int limit});
  Future<Either<Failure, Note>> getNoteById(String id);
  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
    String? eventId,
    List<String>? tags,
    bool isPrivate = true,
  });
  Future<Either<Failure, Note>> updateNote({
    required String id,
    String? title,
    String? content,
    List<String>? tags,
    bool? isPrivate,
  });
  Future<Either<Failure, Note>> shareNote(String id, String userId);
  Future<Either<Failure, Note>> unshareNote(String id, String userId);
  Future<Either<Failure, Note>> addMediaAttachment({
    required String noteId,
    required String filePath,
    String? caption,
  });
  Future<Either<Failure, void>> deleteAttachment({
    required String noteId,
    required String attachmentId,
  });
}
