// YouTube 영상 목록의 상태 관리를 담당하는 Riverpod 컨트롤러.
// riverpod_annotation으로 코드 생성(youtube_controller.g.dart)을 사용합니다.
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/infrastructure/repositories/youtube_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'youtube_controller.g.dart';

// YoutubeRepository를 Riverpod Provider로 제공합니다.
@riverpod
YoutubeRepository youtubeRepository(Ref ref) => YoutubeRepository();

// @riverpod: riverpod_generator가 YoutubeControllerProvider를 자동 생성합니다.
// 상태 타입은 AsyncValue<List<YoutubeVideo>> — 로딩/에러/데이터 세 가지 상태를 표현합니다.
@riverpod
class YoutubeController extends _$YoutubeController {
  late YoutubeRepository _repository;

  @override
  AsyncValue<List<YoutubeVideo>> build() {
    _repository = ref.watch(youtubeRepositoryProvider);
    fetchVideos(); // 위젯 생성 시 즉시 영상 목록 로드 시작
    return const AsyncLoading(); // 초기 상태: 로딩 중
  }

  // 하드코딩된 YouTube 영상 ID 목록으로 영상 정보를 불러옵니다.
  // 성공 시 AsyncData(videos), 실패 시 AsyncError(failure)로 상태 변경
  Future<void> fetchVideos() async {
    final result = await _repository.fetchVideos(['3QSZ5ahBXkY', '08iU4uU0vZg', 'BaAVRvF6kEQ', 'bz4h65cJyWE']);
    result.fold(
      (l) => state = AsyncError(l, l.stackTrace), // 실패: stackTrace 포함 에러 상태
      (r) => state = AsyncData(r),                 // 성공: 영상 목록 데이터 상태
    );
  }
}
