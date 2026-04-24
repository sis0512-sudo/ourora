// 인스타그램 피드의 상태 관리를 담당하는 Riverpod 컨트롤러.
// riverpod_annotation으로 코드 생성(instagram_controller.g.dart)을 사용합니다.
// 페이지네이션(Load More) 기능을 포함합니다.
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/infrastructure/repositories/instagram_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'instagram_controller.g.dart';

// 인스타그램 피드의 현재 상태를 나타내는 불변(immutable) 데이터 클래스.
class InstagramFeedState {
  final List<InstagramPost> posts;  // 지금까지 불러온 게시물 목록
  final bool isLoading;             // 현재 데이터를 불러오는 중인지 여부
  final bool hasMore;               // 더 불러올 게시물이 있는지 여부
  final String? nextCursor;        // 다음 페이지를 불러올 때 사용하는 커서값
  final String? error;             // 에러 발생 시 에러 메시지

  const InstagramFeedState({this.posts = const [], this.isLoading = false, this.hasMore = true, this.nextCursor, this.error});

  // 기존 상태를 기반으로 일부 값만 변경한 새 상태를 반환합니다 (불변성 유지).
  // [clearError]: true이면 error를 null로 초기화
  // [clearCursor]: true이면 nextCursor를 null로 초기화
  InstagramFeedState copyWith({
    List<InstagramPost>? posts,
    bool? isLoading,
    bool? hasMore,
    String? nextCursor,
    String? error,
    bool clearError = false,
    bool clearCursor = false,
  }) {
    return InstagramFeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// InstagramRepository를 Riverpod Provider로 제공합니다.
// @riverpod 어노테이션으로 자동 생성된 instagramRepositoryProvider를 통해 접근합니다.
@riverpod
InstagramRepository instagramRepository(Ref ref) => InstagramRepository();

// @riverpod: riverpod_generator가 InstagramControllerProvider를 자동 생성합니다.
// int pageSize: 한 페이지당 불러올 게시물 수를 파라미터로 받습니다.
// 예: ref.watch(instagramControllerProvider(9))
@riverpod
class InstagramController extends _$InstagramController {
  late InstagramRepository _repository;

  @override
  InstagramFeedState build(int pageSize) {
    _repository = ref.watch(instagramRepositoryProvider);
    // 위젯 빌드 직후 비동기적으로 첫 페이지 데이터를 로드합니다.
    // Future.microtask: 현재 프레임이 끝난 직후 실행 (빌드 중 상태 변경 방지)
    Future.microtask(loadMore);
    return const InstagramFeedState();
  }

  // 다음 페이지의 게시물을 불러와 기존 목록에 추가합니다.
  // 이미 로딩 중이거나 더 불러올 데이터가 없으면 즉시 반환합니다.
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.fetchPage(afterCursor: state.nextCursor, pageSize: pageSize);
    result.fold(
      // 실패 케이스: 에러 메시지 저장, 로딩 종료
      (failure) => state = state.copyWith(isLoading: false, error: failure.error),
      // 성공 케이스: 기존 게시물에 새 게시물 추가, 다음 커서 업데이트
      (page) => state = state.copyWith(
        posts: [...state.posts, ...page.posts.take(pageSize)],
        isLoading: false,
        hasMore: page.nextCursor != null, // 다음 커서가 없으면 마지막 페이지
        nextCursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
      ),
    );
  }
}
