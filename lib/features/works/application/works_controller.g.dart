// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'works_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(worksRepository)
const worksRepositoryProvider = WorksRepositoryProvider._();

final class WorksRepositoryProvider
    extends
        $FunctionalProvider<WorksRepository, WorksRepository, WorksRepository>
    with $Provider<WorksRepository> {
  const WorksRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'worksRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$worksRepositoryHash();

  @$internal
  @override
  $ProviderElement<WorksRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorksRepository create(Ref ref) {
    return worksRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorksRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorksRepository>(value),
    );
  }
}

String _$worksRepositoryHash() => r'3a074bc856d1282ba677a915a5b14581bd2ffcef';

@ProviderFor(WorksController)
const worksControllerProvider = WorksControllerProvider._();

final class WorksControllerProvider
    extends $NotifierProvider<WorksController, WorksState> {
  const WorksControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'worksControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$worksControllerHash();

  @$internal
  @override
  WorksController create() => WorksController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorksState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorksState>(value),
    );
  }
}

String _$worksControllerHash() => r'03f5fa27c16024f0eefd4d06cee2d2013d52b386';

abstract class _$WorksController extends $Notifier<WorksState> {
  WorksState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WorksState, WorksState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorksState, WorksState>,
              WorksState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
