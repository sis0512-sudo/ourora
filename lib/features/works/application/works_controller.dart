import 'package:ourora/features/works/domain/work_item.dart';
import 'package:ourora/features/works/infrastructure/works_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'works_controller.g.dart';

class WorksState {
  final List<WorkItem> works;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final Object? cursor;

  const WorksState({
    this.works = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.cursor,
  });

  WorksState copyWith({
    List<WorkItem>? works,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    bool clearError = false,
    Object? cursor,
    bool clearCursor = false,
  }) {
    return WorksState(
      works: works ?? this.works,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      cursor: clearCursor ? null : (cursor ?? this.cursor),
    );
  }
}

@riverpod
WorksRepository worksRepository(Ref ref) => WorksRepository();

@riverpod
class WorksController extends _$WorksController {
  late WorksRepository _repository;

  @override
  WorksState build() {
    _repository = ref.watch(worksRepositoryProvider);
    Future.microtask(fetch);
    return const WorksState();
  }

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true, clearError: true, clearCursor: true, hasMore: true);
    try {
      final result = await _repository.fetchWorksPage();
      state = state.copyWith(
        works: result.items,
        isLoading: false,
        hasMore: result.nextCursor != null,
        cursor: result.nextCursor,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final result = await _repository.fetchWorksPage(cursor: state.cursor);
      state = state.copyWith(
        works: [...state.works, ...result.items],
        isLoadingMore: false,
        hasMore: result.nextCursor != null,
        cursor: result.nextCursor,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }
}
