import 'package:flutter/foundation.dart';
import 'package:kenyanvalley/core/error/failures.dart';
import 'package:kenyanvalley/features/notes/data/models/note_model.dart';
import 'package:kenyanvalley/features/notes/domain/repositories/notes_repository.dart';

// State for notes list
class NotesState {
  final bool isLoading;
  final List<Note> notes;
  final Failure? error;
  final int page;
  final bool hasReachedMax;

  const NotesState({
    this.isLoading = false,
    this.notes = const [],
    this.error,
    this.page = 1,
    this.hasReachedMax = false,
  });

  NotesState copyWith({
    bool? isLoading,
    List<Note>? notes,
    Failure? error,
    int? page,
    bool? hasReachedMax,
  }) {
    return NotesState(
      isLoading: isLoading ?? this.isLoading,
      notes: notes ?? this.notes,
      error: error,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

// State for a single note
class NoteState {
  final Note? note;
  final bool isLoading;
  final Failure? error;

  const NoteState({
    this.note,
    this.isLoading = false,
    this.error,
  });

  NoteState copyWith({
    Note? note,
    bool? isLoading,
    Failure? error,
  }) {
    return NoteState(
      note: note ?? this.note,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Provider for managing notes list state
class NotesProvider with ChangeNotifier {
  final NotesRepository _repository;
  static const int _pageSize = 10;
  
  NotesState _state = const NotesState();
  NotesState get state => _state;
  
  // Expose hasReachedMax for convenience
  bool get hasReachedMax => _state.hasReachedMax;

  NotesProvider(this._repository);

  Future<void> getNotes({bool refresh = false}) async {
    if (_state.isLoading) return;

    final page = refresh ? 1 : _state.page;
    
    _state = _state.copyWith(
      isLoading: true,
      error: null,
      page: page,
    );
    notifyListeners();

    try {
      final result = await _repository.getNotes(
        page: page,
        limit: _pageSize,
      );

      result.fold(
        (failure) {
          _state = _state.copyWith(
            isLoading: false,
            error: failure,
            hasReachedMax: true,
          );
          notifyListeners();
        },
        (notes) {
          final allNotes = refresh ? notes : [..._state.notes, ...notes];
          _state = _state.copyWith(
            isLoading: false,
            notes: allNotes,
            page: page + 1,
            hasReachedMax: notes.length < _pageSize,
          );
          notifyListeners();
        },
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: ServerFailure(message: 'An unexpected error occurred'),
        hasReachedMax: true,
      );
      notifyListeners();
    }
  }

  Future<void> refreshNotes() async {
    _state = const NotesState(); // Reset state
    notifyListeners();
    await getNotes(refresh: true);
  }

  Future<void> createNote({
    required String title,
    required String content,
    String? eventId,
    List<String>? tags,
    bool isPrivate = true,
  }) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.createNote(
      title: title,
      content: content,
      eventId: eventId,
      tags: tags,
      isPrivate: isPrivate,
    );

    result.fold(
      (failure) {
        _state = _state.copyWith(error: failure);
        notifyListeners();
      },
      (note) {
        _state = _state.copyWith(
          notes: [note, ..._state.notes],
        );
        notifyListeners();
      },
    );
  }

  Future<void> updateNote({
    required String id,
    String? title,
    String? content,
    List<String>? tags,
    bool? isPrivate,
  }) async {
    final result = await _repository.updateNote(
      id: id,
      title: title,
      content: content,
      tags: tags,
      isPrivate: isPrivate,
    );

    result.fold(
      (failure) {
        _state = _state.copyWith(error: failure);
        notifyListeners();
      },
      (updatedNote) {
        final updatedNotes = _state.notes.map((note) {
          return note.id == updatedNote.id ? updatedNote : note;
        }).toList();
        
        _state = _state.copyWith(notes: updatedNotes);
        notifyListeners();
      },
    );
  }

  Future<void> deleteNote(String id) async {
    // Optimistically remove the note
    final notes = [..._state.notes];
    notes.removeWhere((note) => note.id == id);
    
    _state = _state.copyWith(notes: notes);
    notifyListeners();
    
    // TODO: Implement actual deletion from the server
    // final result = await _repository.deleteNote(id);
    // result.fold(
    //   (failure) {
    //     // Revert the change if deletion fails
    //     _state = _state.copyWith(notes: _state.notes);
    //     _state = _state.copyWith(error: failure);
    //     notifyListeners();
    //   },
    //   (_) {
    //     // Success - state already updated
    //   },
    // );
  }

  Future<void> shareNote(String id, String userId) async {
    final result = await _repository.shareNote(id, userId);
    
    result.fold(
      (failure) {
        _state = _state.copyWith(error: failure);
        notifyListeners();
      },
      (updatedNote) {
        final updatedNotes = _state.notes.map((note) {
          return note.id == updatedNote.id ? updatedNote : note;
        }).toList();
        
        _state = _state.copyWith(notes: updatedNotes);
        notifyListeners();
      },
    );
  }

  Future<void> unshareNote(String id, String userId) async {
    final result = await _repository.unshareNote(id, userId);
    
    result.fold(
      (failure) {
        _state = _state.copyWith(error: failure);
        notifyListeners();
      },
      (updatedNote) {
        final updatedNotes = _state.notes.map((note) {
          return note.id == updatedNote.id ? updatedNote : note;
        }).toList();
        
        _state = _state.copyWith(notes: updatedNotes);
        notifyListeners();
      },
    );
  }

  Future<void> addMediaAttachment({
    required String noteId,
    required String filePath,
    String? caption,
  }) async {
    final result = await _repository.addMediaAttachment(
      noteId: noteId,
      filePath: filePath,
      caption: caption,
    );
    
    result.fold(
      (failure) {
        _state = _state.copyWith(error: failure);
        notifyListeners();
      },
      (updatedNote) {
        final updatedNotes = _state.notes.map((note) {
          return note.id == updatedNote.id ? updatedNote : note;
        }).toList();
        
        _state = _state.copyWith(notes: updatedNotes);
        notifyListeners();
      },
    );
  }

  Future<void> deleteAttachment({
    required String noteId,
    required String attachmentId,
  }) async {
    final result = await _repository.deleteAttachment(
      noteId: noteId,
      attachmentId: attachmentId,
    );
    
    result.fold(
      (failure) {
        _state = _state.copyWith(error: failure);
        notifyListeners();
      },
      (_) {
        // Refresh the notes to get the updated state
        refreshNotes();
      },
    );
  }
}
