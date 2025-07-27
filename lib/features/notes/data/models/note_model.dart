import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String email;
  @JsonKey(name: 'firstName')
  final String firstName;
  @JsonKey(name: 'lastName')
  final String lastName;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  @override
  List<Object?> get props => [id, email, firstName, lastName];
}

@JsonSerializable()
class MediaAttachment extends Equatable {
  final String id;
  final String type;
  final String url;
  final String caption;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  final String? filename;
  final int? size;

  const MediaAttachment({
    required this.id,
    required this.type,
    required this.url,
    this.caption = '',
    this.createdAt,
    this.filename,
    this.size,
  });

  factory MediaAttachment.fromJson(Map<String, dynamic> json) => 
      _$MediaAttachmentFromJson(json);
      
  Map<String, dynamic> toJson() => _$MediaAttachmentToJson(this);
  
  String get displayFilename => filename ?? url.split('/').last;
  int get displaySize => size ?? 0;
  
  @override
  List<Object?> get props => [id, type, url, caption, createdAt, filename, size];
}

@JsonSerializable()
class Note extends Equatable {
  final String? id;
  final String title;
  final String content;
  @JsonKey(fromJson: _userFromJson, toJson: _userToJson, includeIfNull: false)
  final dynamic user;
  final String? event;
  final List<String>? tags;
  @JsonKey(name: 'isPrivate', defaultValue: true)
  final bool isPrivate;
  @JsonKey(name: 'sharedWith', defaultValue: const [])
  final List<String> sharedWith;
  @JsonKey(name: 'mediaAttachments', defaultValue: const [])
  final List<MediaAttachment> attachments;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @JsonKey(name: '__v', defaultValue: 0)
  final int version;

  const Note({
    this.id,
    required this.title,
    required this.content,
    this.user,
    this.event,
    this.tags,
    this.isPrivate = true,
    this.sharedWith = const [],
    this.attachments = const [],
    this.createdAt,
    this.updatedAt,
    this.version = 0,
  });

  // Factory constructor for creating a new Note from JSON with proper null handling
  factory Note.fromJson(Map<String, dynamic> json) {
    try {
      return Note(
        id: json['_id']?.toString(),
        title: json['title']?.toString() ?? '',
        content: json['content']?.toString() ?? '',
        user: _userFromJson(json['user']),
        event: json['event']?.toString(),
        tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
        isPrivate: json['isPrivate'] ?? true,
        sharedWith: json['sharedWith'] != null 
            ? List<String>.from(json['sharedWith']) 
            : const [],
        attachments: json['mediaAttachments'] != null
            ? (json['mediaAttachments'] as List)
                .map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
                .toList()
            : const [],
        createdAt: json['createdAt'] != null 
            ? DateTime.tryParse(json['createdAt']) 
            : null,
        updatedAt: json['updatedAt'] != null 
            ? DateTime.tryParse(json['updatedAt']) 
            : null,
        version: (json['__v'] as num?)?.toInt() ?? 0,
      );
    } catch (e) {
      // Log the error for debugging
      print('Error parsing Note from JSON: $e');
      // Return a default note with the available data
      return Note(
        id: json['_id']?.toString(),
        title: json['title']?.toString() ?? 'Error loading note',
        content: json['content']?.toString() ?? 'There was an error loading this note.',
        user: _userFromJson(json['user']),
        event: json['event']?.toString(),
        tags: const [],
        isPrivate: true,
        sharedWith: const [],
        attachments: const [],
        version: 0,
      );
    }
  }

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

  // Convert Note to JSON with proper null handling
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'content': content,
      if (user != null) 'user': _userToJson(user),
      if (event != null) 'event': event,
      if (tags != null) 'tags': tags,
      'isPrivate': isPrivate,
      'sharedWith': sharedWith,
      'mediaAttachments': attachments.map((e) => e.toJson()).toList(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      '__v': version,
    }..removeWhere((key, value) => value == null);
  }

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
      
  // Helper method to safely convert dynamic list to List<String>
  static List<String> _stringListFromDynamic(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return [];
  }
}
