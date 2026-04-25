// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instagram_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InstagramPost _$InstagramPostFromJson(Map<String, dynamic> json) =>
    _InstagramPost(
      id: json['id'] as String,
      mediaType: json['mediaType'] as String,
      mediaUrl: json['mediaUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      permalink: json['permalink'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$InstagramPostToJson(_InstagramPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mediaType': instance.mediaType,
      'mediaUrl': instance.mediaUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'permalink': instance.permalink,
      'timestamp': instance.timestamp.toIso8601String(),
      'caption': instance.caption,
    };
