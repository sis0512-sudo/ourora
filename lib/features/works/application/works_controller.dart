import 'package:ourora/features/works/domain/work_item.dart';
import 'package:ourora/features/works/infrastructure/works_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'works_controller.g.dart';

class WorksState {
  final List<WorkItem> works;
  final bool isLoading;
  final String? error;

  const WorksState({this.works = const [], this.isLoading = false, this.error});

  WorksState copyWith({List<WorkItem>? works, bool? isLoading, String? error, bool clearError = false}) {
    return WorksState(
      works: works ?? this.works,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
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
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final works = await _repository.fetchWorks();
      state = state.copyWith(works: works, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
