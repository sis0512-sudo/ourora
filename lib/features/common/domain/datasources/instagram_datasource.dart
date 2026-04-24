// Instagram 데이터를 가져오는 인터페이스(추상 클래스).
// 실제 구현체(InstagramRemoteDatasource)가 이 계약을 따르도록 강제합니다.
// 테스트 시에는 이 인터페이스의 가짜(mock) 구현체로 교체할 수 있습니다.
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';

abstract class InstagramDatasource {
  // 인스타그램 게시물을 페이지 단위로 가져옵니다.
  // [afterCursor]: 이전 페이지의 마지막 커서값. null이면 첫 페이지를 가져옵니다.
  // [pageSize]: 한 번에 가져올 게시물 수 (기본값: 9개)
  // 반환: 게시물 목록과 다음 페이지 커서를 담은 레코드(Record) 타입
  Future<({List<InstagramPost> posts, String? nextCursor})> fetchPage({String? afterCursor, int pageSize = 9});
}
