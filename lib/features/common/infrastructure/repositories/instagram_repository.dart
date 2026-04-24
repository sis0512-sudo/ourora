// Instagram 데이터 접근의 단일 창구(Repository 패턴).
// Datasource를 직접 호출하는 대신 이 클래스를 통해 데이터를 요청합니다.
// 에러 처리를 담당하여 Either<Failure, T> 형태로 성공/실패를 반환합니다.
import 'package:fpdart/fpdart.dart';
import 'package:ourora/features/common/domain/datasources/instagram_datasource.dart';
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/common/infrastructure/datasources/instagram_remote_datasource.dart';
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/utils/utils.dart';

class InstagramRepository {
  final InstagramDatasource _datasource;

  // 기본값은 실제 원격 데이터소스를 사용하며, 테스트 시 다른 구현체를 주입할 수 있습니다.
  InstagramRepository({InstagramDatasource? datasource}) : _datasource = datasource ?? InstagramRemoteDatasource();

  // 인스타그램 게시물을 페이지 단위로 가져옵니다.
  // 성공 시 Either.right(page), 실패 시 Either.left(Failure)를 반환합니다.
  Future<Either<Failure, ({List<InstagramPost> posts, String? nextCursor})>> fetchPage({String? afterCursor, int pageSize = 9}) async {
    try {
      final page = await _datasource.fetchPage(afterCursor: afterCursor, pageSize: pageSize);
      return right(page); // 성공: Either의 오른쪽(right) 값
    } catch (e) {
      return Utils.debugLeft(e); // 실패: 에러 로그 출력 + Either의 왼쪽(left) 값
    }
  }
}
