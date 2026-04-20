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

  String get displayUrl =>
      mediaType == 'VIDEO' ? (thumbnailUrl ?? mediaUrl) : mediaUrl;
}
