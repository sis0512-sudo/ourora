// Instagram Graph API 응답에서 받아온 게시물 하나를 나타내는 데이터 클래스.
class InstagramPost {
  final String id;          // 인스타그램 게시물 고유 ID
  final String mediaType;   // 미디어 종류: 'IMAGE' | 'VIDEO' | 'CAROUSEL_ALBUM'
  final String mediaUrl;    // 원본 미디어 URL (이미지 또는 동영상)
  final String? thumbnailUrl; // 동영상인 경우의 썸네일 이미지 URL (없을 수 있음)
  final String permalink;   // 인스타그램 게시물 원본 페이지 URL
  final DateTime timestamp; // 게시물 작성 시각
  final String? caption;    // 게시물 설명 문자열 (없을 수 있음)

  const InstagramPost({
    required this.id,
    required this.mediaType,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.permalink,
    required this.timestamp,
    this.caption,
  });

  // 화면에 표시할 이미지 URL을 반환합니다.
  // 동영상인 경우 썸네일을, 이미지인 경우 원본 URL을 사용합니다.
  String get displayUrl =>
      mediaType == 'VIDEO' ? (thumbnailUrl ?? mediaUrl) : mediaUrl;
}
