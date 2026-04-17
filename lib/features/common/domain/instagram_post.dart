class InstagramPost {
  final String id;
  final String mediaType; // IMAGE | VIDEO | CAROUSEL_ALBUM
  final String mediaUrl;
  final String? thumbnailUrl;
  final String permalink;
  final DateTime timestamp;

  const InstagramPost({
    required this.id,
    required this.mediaType,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.permalink,
    required this.timestamp,
  });

  // 그리드에 표시할 URL: 영상은 썸네일, 이미지는 원본
  String get displayUrl =>
      mediaType == 'VIDEO' ? (thumbnailUrl ?? mediaUrl) : mediaUrl;
}
