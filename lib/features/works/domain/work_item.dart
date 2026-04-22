enum WorkType { furniture, etc }

class WorkItem {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String? youtubeUrl;
  final WorkType type;
  final DateTime createdAt;

  const WorkItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    this.youtubeUrl,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'title': title,
    'description': description,
    'imageUrls': imageUrls,
    'youtubeUrl': youtubeUrl,
    'type': type.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory WorkItem.fromFirestore(Map<String, dynamic> data) => WorkItem(
    id: data['id'] as String,
    title: data['title'] as String,
    description: data['description'] as String,
    imageUrls: List<String>.from(data['imageUrls'] as List),
    youtubeUrl: data['youtubeUrl'] as String?,
    type: WorkType.values.firstWhere((t) => t.name == data['type']),
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}
