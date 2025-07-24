// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

MediaAttachment _$MediaAttachmentFromJson(Map<String, dynamic> json) =>
    MediaAttachment(
      id: json['id'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      caption: json['caption'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MediaAttachmentToJson(MediaAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'url': instance.url,
      'caption': instance.caption,
      'createdAt': instance.createdAt.toIso8601String(),
    };

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      user: Note._userFromJson(json['user']),
      event: json['event'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isPrivate: json['isPrivate'] as bool? ?? true,
      sharedWith: (json['sharedWith'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      attachments: (json['mediaAttachments'] as List<dynamic>?)
              ?.map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: (json['__v'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'user': Note._userToJson(instance.user),
      'event': instance.event,
      'tags': instance.tags,
      'isPrivate': instance.isPrivate,
      'sharedWith': instance.sharedWith,
      'mediaAttachments': instance.attachments,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '__v': instance.version,
    };
