// YouTube 데이터 접근의 단일 창구(Repository 패턴).
// Datasource를 직접 호출하는 대신 이 클래스를 통해 데이터를 요청합니다.
// 에러 처리를 담당하여 Either<Failure, T> 형태로 성공/실패를 반환합니다.
import 'package:fpdart/fpdart.dart';
import 'package:ourora/features/common/domain/datasources/youtube_datasource.dart';
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/common/infrastructure/datasources/youtube_remote_datasource.dart';
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/utils/utils.dart';

class YoutubeRepository {
  final YoutubeDatasource _datasource;

  // 기본값은 실제 원격 데이터소스를 사용하며, 테스트 시 다른 구현체를 주입할 수 있습니다.
  YoutubeRepository({YoutubeDatasource? datasource})
      : _datasource = datasource ?? YoutubeRemoteDatasource();

  // 주어진 ID 목록에 해당하는 YouTube 영상 정보를 가져옵니다.
  // 성공 시 Either.right(videos), 실패 시 Either.left(Failure)를 반환합니다.
  Future<Either<Failure, List<YoutubeVideo>>> fetchVideos(List<String> videoIds) async {
    try {
      final posts = await _datasource.fetchVideos(videoIds);
      return right(posts);
    } catch (e) {
      return Utils.debugLeft(e);
    }
  }
}
