// 작품 데이터를 가져오거나 업로드하는 인터페이스(추상 클래스).
// 실제 구현체(WorksRemoteDatasource)가 이 계약을 따르도록 강제합니다.
import 'dart:typed_data';

import 'package:ourora/features/works/domain/work_item.dart';

abstract class WorksDatasource {
  // 새 작품을 Firebase Storage에 이미지를 업로드하고 Firestore에 데이터를 저장합니다.
  // [customId]: 직접 지정할 문서 ID (없으면 Firestore가 자동 생성)
  // [images]: 업로드할 이미지 목록 (파일명 + 바이트 데이터)
  // [onProgress]: 업로드 진행률 콜백 (0.0 ~ 1.0)
  Future<void> uploadWork({
    String? customId,
    required String title,
    required String description,
    required List<({String name, Uint8List bytes})> images,
    required String? youtubeUrl,
    required WorkType type,
    void Function(double progress)? onProgress,
  });

  // 작품 목록을 페이지 단위로 가져옵니다 (무한 스크롤용).
  // [cursor]: 이전 페이지의 마지막 Firestore DocumentSnapshot. null이면 첫 페이지.
  // [limit]: 한 번에 가져올 작품 수
  Future<({List<WorkItem> items, Object? nextCursor})> fetchWorksPage({
    Object? cursor,
    int limit = 9,
    WorkType? type,
  });

  // 타입 필터로 전체 작품 목록을 한 번에 가져옵니다 (검색·필터 기능용).
  Future<List<WorkItem>> fetchAllWorks({WorkType? type});

  // 특정 ID의 작품 하나를 가져옵니다. 없으면 null 반환.
  Future<WorkItem?> fetchWorkById(String id);
}
