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
  final WorkType? selectedType;
  final String searchQuery;

  const WorksState({
    this.works = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.cursor,
    this.selectedType,
    this.searchQuery = '',
  });

  List<WorkItem> get displayedWorks {
    if (searchQuery.isEmpty) return works;
    final q = searchQuery.toLowerCase();
    return works.where((w) => w.title.toLowerCase().contains(q) || w.description.toLowerCase().contains(q)).toList();
  }

  WorksState copyWith({
    List<WorkItem>? works,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    bool clearError = false,
    Object? cursor,
    bool clearCursor = false,
    WorkType? selectedType,
    bool clearSelectedType = false,
    String? searchQuery,
  }) {
    return WorksState(
      works: works ?? this.works,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      cursor: clearCursor ? null : (cursor ?? this.cursor),
      selectedType: clearSelectedType ? null : (selectedType ?? this.selectedType),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

@Riverpod(keepAlive: true)
WorksRepository worksRepository(Ref ref) => WorksRepository();

@Riverpod(keepAlive: true)
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
      final result = await _repository.fetchWorksPage(type: state.selectedType);
      state = state.copyWith(works: result.items, isLoading: false, hasMore: result.nextCursor != null, cursor: result.nextCursor);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.searchQuery.isNotEmpty) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final result = await _repository.fetchWorksPage(cursor: state.cursor, type: state.selectedType);
      state = state.copyWith(works: [...state.works, ...result.items], isLoadingMore: false, hasMore: result.nextCursor != null, cursor: result.nextCursor);
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<void> setType(WorkType? type) async {
    if (state.selectedType == type) return;

    if (type == null) {
      // ALL: revert to paginated mode
      state = state.copyWith(clearSelectedType: true, searchQuery: '', works: [], isLoading: true, clearError: true, clearCursor: true, hasMore: true);
      await fetch();
      return;
    }

    // Specific type: fetch all matching works client-sorted (avoids Firestore composite index)
    state = state.copyWith(selectedType: type, searchQuery: '', works: [], isLoading: true, clearError: true, clearCursor: true, hasMore: false);
    try {
      final items = await _repository.fetchAllWorks(type: state.selectedType);
      state = state.copyWith(works: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setSearchQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed == state.searchQuery) return;

    if (trimmed.isEmpty) {
      state = state.copyWith(searchQuery: '', works: [], clearCursor: true, hasMore: true);
      await fetch();
      return;
    }

    state = state.copyWith(searchQuery: trimmed, isLoading: true, clearError: true, works: [], hasMore: false);
    try {
      final all = await _repository.fetchAllWorks(type: state.selectedType);
      state = state.copyWith(works: all, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
