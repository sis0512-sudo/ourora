// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(youtubeRepository)
const youtubeRepositoryProvider = YoutubeRepositoryProvider._();

final class YoutubeRepositoryProvider
    extends
        $FunctionalProvider<
          YoutubeRepository,
          YoutubeRepository,
          YoutubeRepository
        >
    with $Provider<YoutubeRepository> {
  const YoutubeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'youtubeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$youtubeRepositoryHash();

  @$internal
  @override
  $ProviderElement<YoutubeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  YoutubeRepository create(Ref ref) {
    return youtubeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(YoutubeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<YoutubeRepository>(value),
    );
  }
}

String _$youtubeRepositoryHash() => r'3c950d769524ac122b96afe5e1a11401f706b312';

@ProviderFor(YoutubeController)
const youtubeControllerProvider = YoutubeControllerProvider._();

final class YoutubeControllerProvider
    extends
        $NotifierProvider<YoutubeController, AsyncValue<List<YoutubeVideo>>> {
  const YoutubeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'youtubeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$youtubeControllerHash();

  @$internal
  @override
  YoutubeController create() => YoutubeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<YoutubeVideo>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<YoutubeVideo>>>(
        value,
      ),
    );
  }
}

String _$youtubeControllerHash() => r'84748c7e8ea90d85e6297cb879eccff547ff280c';

abstract class _$YoutubeController
    extends $Notifier<AsyncValue<List<YoutubeVideo>>> {
  AsyncValue<List<YoutubeVideo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<YoutubeVideo>>,
              AsyncValue<List<YoutubeVideo>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<YoutubeVideo>>,
                AsyncValue<List<YoutubeVideo>>
              >,
              AsyncValue<List<YoutubeVideo>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
