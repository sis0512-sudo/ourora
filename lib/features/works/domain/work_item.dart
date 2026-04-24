// 작품 하나를 나타내는 도메인 모델 클래스.
// Firestore에 저장되는 데이터 구조와 대응됩니다.

// 작품의 카테고리를 나타내는 열거형
enum WorkType {
  furniture, // 가구 작품
  etc,       // 기타 작품
}

class WorkItem {
  final String id;               // Firestore 문서 ID (URL 경로에도 사용)
  final String title;            // 작품 제목
  final String description;      // 작품 설명
  final List<String> imageUrls;      // 원본 이미지 URL 목록 (고화질)
  final List<String> lightImageUrls; // 썸네일/경량 이미지 URL 목록 (그리드 표시용)
  final String? youtubeUrl;      // 관련 YouTube 영상 URL (없을 수 있음)
  final WorkType type;           // 작품 유형 (furniture / etc)
  final DateTime createdAt;      // 작품 등록 시각

  const WorkItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.lightImageUrls,
    this.youtubeUrl,
    required this.type,
    required this.createdAt,
  });

  // WorkItem 객체를 Firestore에 저장할 수 있는 Map으로 변환합니다.
  Map<String, dynamic> toFirestore() => {
    'id': id,
    'title': title,
    'description': description,
    'imageUrls': imageUrls,
    'lightImageUrls': lightImageUrls,
    'youtubeUrl': youtubeUrl,
    'type': type.name, // 열거형을 문자열로 저장 ('furniture' / 'etc')
    'createdAt': createdAt.toIso8601String(),
  };

  // Firestore 문서 데이터(Map)로부터 WorkItem 객체를 생성합니다.
  // factory 생성자: 내부 로직(타입 변환 등)이 있을 때 사용합니다.
  factory WorkItem.fromFirestore(Map<String, dynamic> data) => WorkItem(
    id: data['id'] as String,
    title: data['title'] as String,
    description: data['description'] as String,
    imageUrls: List<String>.from(data['imageUrls'] as List),
    lightImageUrls: List<String>.from(data['lightImageUrls'] as List),
    youtubeUrl: data['youtubeUrl'] as String?,
    // 저장된 문자열('furniture')을 다시 열거형(WorkType.furniture)으로 변환
    type: WorkType.values.firstWhere((t) => t.name == data['type']),
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}
