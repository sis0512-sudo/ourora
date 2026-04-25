import 'package:freezed_annotation/freezed_annotation.dart';

part 'instagram_post.freezed.dart';
part 'instagram_post.g.dart';

@freezed
abstract class InstagramPost with _$InstagramPost {
  const InstagramPost._();

  const factory InstagramPost({
    required String id,
    required String mediaType,
    required String mediaUrl,
    String? thumbnailUrl,
    required String permalink,
    required DateTime timestamp,
    String? caption,
  }) = _InstagramPost;

  factory InstagramPost.fromJson(Map<String, dynamic> json) => _$InstagramPostFromJson(json);

  // 동영상인 경우 썸네일을, 이미지인 경우 원본 URL을 반환합니다.
  String get displayUrl => mediaType == 'VIDEO' ? (thumbnailUrl ?? mediaUrl) : mediaUrl;
}
