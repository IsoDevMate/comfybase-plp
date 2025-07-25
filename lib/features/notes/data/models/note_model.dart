// import 'package:equatable/equatable.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'note_model.g.dart';

// @JsonSerializable()
// class User {
//   final String id;
//   final String email;
//   @JsonKey(name: 'firstName')
//   final String firstName;
//   @JsonKey(name: 'lastName')
//   final String lastName;

//   User({
//     required this.id,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//   });

//   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
//   Map<String, dynamic> toJson() => _$UserToJson(this);
// }

// @JsonSerializable()
// class MediaAttachment {
//   final String id;
//   final String type;
//   final String url;
//   final String caption;
//   @JsonKey(name: 'createdAt')
//   final DateTime createdAt;

//   MediaAttachment({
//     required this.id,
//     required this.type,
//     required this.url,
//     required this.caption,
//     required this.createdAt,
//   });

//   factory MediaAttachment.fromJson(Map<String, dynamic> json) =>
//       _$MediaAttachmentFromJson(json);
//   Map<String, dynamic> toJson() => _$MediaAttachmentToJson(this);
// }

// @JsonSerializable()
// class Note extends Equatable {
//   final String id;
//   final String title;
//   final String content;
//   @JsonKey(fromJson: _userFromJson, toJson: _userToJson)
//   final dynamic user;
//   final String? event;
//   final List<String> tags;
//   @JsonKey(name: 'isPrivate')
//   final bool isPrivate;
//   @JsonKey(name: 'sharedWith')
//   final List<String> sharedWith;
//   @JsonKey(name: 'mediaAttachments')
//   final List<MediaAttachment> attachments;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   @JsonKey(name: '__v')
//   final int version;

//   const Note({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.user,
//     this.event,
//     this.tags = const [],
//     this.isPrivate = true,
//     this.sharedWith = const [],
//     this.attachments = const [],
//     required this.createdAt,
//     required this.updatedAt,
//     this.version = 0,
//   });

//   // Handle dynamic user field (can be String ID or User object)
//   static dynamic _userFromJson(dynamic user) {
//     if (user == null) return null;
//     if (user is String) return user;
//     if (user is Map<String, dynamic>) {
//       try {
//         return User.fromJson(user);
//       } catch (e) {
//         // If parsing as User fails, return the id if available
//         return user['_id']?.toString() ?? user['id']?.toString();
//       }
//     }
//     return null;
//   }

//   static dynamic _userToJson(dynamic user) {
//     if (user == null) return null;
//     if (user is User) return user.toJson();
//     if (user is Map<String, dynamic>) {
//       return user; // Return as is if it's already a map
//     }
//     return user.toString(); // Fallback to string representation
//   }

//   factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
//   Map<String, dynamic> toJson() => _$NoteToJson(this);

//   // Copy with method for immutable updates
//   Note copyWith({
//     String? id,
//     String? title,
//     String? content,
//     dynamic user,
//     String? event,
//     List<String>? tags,
//     bool? isPrivate,
//     List<String>? sharedWith,
//     List<MediaAttachment>? attachments,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     int? version,
//   }) {
//     return Note(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       content: content ?? this.content,
//       user: user ?? this.user,
//       event: event ?? this.event,
//       tags: tags ?? this.tags,
//       isPrivate: isPrivate ?? this.isPrivate,
//       sharedWith: sharedWith ?? this.sharedWith,
//       attachments: attachments ?? this.attachments,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       version: version ?? this.version,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         id,
//         title,
//         content,
//         user,
//         event,
//         tags,
//         isPrivate,
//         sharedWith,
//         attachments,
//         createdAt,
//         updatedAt,
//         version,
//       ];
// }


import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  @JsonKey(name: 'firstName')
  final String firstName;
  @JsonKey(name: 'lastName')
  final String lastName;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class MediaAttachment {
  final String id;
  final String type;
  final String url;
  final String caption;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  // Add the missing properties
  final String? filename;
  final int? size;

  MediaAttachment({
    required this.id,
    required this.type,
    required this.url,
    required this.caption,
    required this.createdAt,
    this.filename,
    this.size,
  });

  // Helper getter for filename with fallback
  String get displayFilename {
    if (filename != null && filename!.isNotEmpty) {
      return filename!;
    }
    // Extract filename from URL as fallback
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return 'attachment';
  }

  // Helper getter for size with fallback
  int get displaySize {
    return size ?? 0;
  }

  factory MediaAttachment.fromJson(Map<String, dynamic> json) =>
      _$MediaAttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$MediaAttachmentToJson(this);
}

@JsonSerializable()
class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  @JsonKey(fromJson: _userFromJson, toJson: _userToJson)
  final dynamic user;
  final String? event;
  final List<String> tags;
  @JsonKey(name: 'isPrivate')
  final bool isPrivate;
  @JsonKey(name: 'sharedWith')
  final List<String> sharedWith;
  @JsonKey(name: 'mediaAttachments')
  final List<MediaAttachment> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(name: '__v')
  final int version;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.user,
    this.event,
    this.tags = const [],
    this.isPrivate = true,
    this.sharedWith = const [],
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
    this.version = 0,
  });

  // Handle dynamic user field (can be String ID or User object)
  static dynamic _userFromJson(dynamic user) {
    if (user == null) return null;
    if (user is String) return user;
    if (user is Map<String, dynamic>) {
      try {
        return User.fromJson(user);
      } catch (e) {
        // If parsing as User fails, return the id if available
        return user['_id']?.toString() ?? user['id']?.toString();
      }
    }
    return null;
  }

  static dynamic _userToJson(dynamic user) {
    if (user == null) return null;
    if (user is User) return user.toJson();
    if (user is Map<String, dynamic>) {
      return user; // Return as is if it's already a map
    }
    return user.toString(); // Fallback to string representation
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);

  // Copy with method for immutable updates
  Note copyWith({
    String? id,
    String? title,
    String? content,
    dynamic user,
    String? event,
    List<String>? tags,
    bool? isPrivate,
    List<String>? sharedWith,
    List<MediaAttachment>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      user: user ?? this.user,
      event: event ?? this.event,
      tags: tags ?? this.tags,
      isPrivate: isPrivate ?? this.isPrivate,
      sharedWith: sharedWith ?? this.sharedWith,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        user,
        event,
        tags,
        isPrivate,
        sharedWith,
        attachments,
        createdAt,
        updatedAt,
        version,
      ];
}
