import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_item.freezed.dart';

enum WorkType {
  furniture,
  etc,
}

@freezed
abstract class WorkItem with _$WorkItem {
  const WorkItem._();

  const factory WorkItem({
    required String id,
    required String title,
    required String description,
    required List<String> imageUrls,
    required List<String> lightImageUrls,
    String? youtubeUrl,
    required WorkType type,
    required DateTime createdAt,
  }) = _WorkItem;

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'title': title,
    'description': description,
    'imageUrls': imageUrls,
    'lightImageUrls': lightImageUrls,
    'youtubeUrl': youtubeUrl,
    'type': type.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory WorkItem.fromFirestore(Map<String, dynamic> data) => WorkItem(
    id: data['id'] as String,
    title: data['title'] as String,
    description: data['description'] as String,
    imageUrls: List<String>.from(data['imageUrls'] as List),
    lightImageUrls: List<String>.from(data['lightImageUrls'] as List),
    youtubeUrl: data['youtubeUrl'] as String?,
    type: WorkType.values.firstWhere((t) => t.name == data['type']),
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}
