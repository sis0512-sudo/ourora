// YouTube API 또는 Firebase에서 가져온 영상 하나를 나타내는 데이터 클래스.
class YoutubeVideo {
  final String videoId;      // YouTube 동영상 ID (URL의 ?v= 뒤 부분)
  final String title;        // 영상 제목
  final String description;  // 영상 설명
  final String thumbnailUrl; // 썸네일 이미지 URL
  final String duration;     // 재생 시간 (예: '3:42' 또는 'PT3M42S' ISO 8601 형식)

  const YoutubeVideo({
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.duration,
  });
}
