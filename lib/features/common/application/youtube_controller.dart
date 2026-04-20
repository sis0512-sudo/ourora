import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/infrastructure/repositories/youtube_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'youtube_controller.g.dart';

@riverpod
YoutubeRepository youtubeRepository(Ref ref) => YoutubeRepository();

@riverpod
class YoutubeController extends _$YoutubeController {
  late YoutubeRepository _repository;

  @override
  AsyncValue<List<YoutubeVideo>> build() {
    _repository = ref.watch(youtubeRepositoryProvider);
    fetchVideos();
    return const AsyncLoading();
  }

  Future<void> fetchVideos() async {
    final result = await _repository.fetchVideos(['3QSZ5ahBXkY', '08iU4uU0vZg', 'BaAVRvF6kEQ', 'bz4h65cJyWE']);
    result.fold((l) => state = AsyncError(l, l.stackTrace), (r) => state = AsyncData(r));
  }
}
