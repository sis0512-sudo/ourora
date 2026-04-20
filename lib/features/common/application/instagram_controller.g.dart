// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instagram_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(instagramRepository)
const instagramRepositoryProvider = InstagramRepositoryProvider._();

final class InstagramRepositoryProvider
    extends
        $FunctionalProvider<
          InstagramRepository,
          InstagramRepository,
          InstagramRepository
        >
    with $Provider<InstagramRepository> {
  const InstagramRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instagramRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instagramRepositoryHash();

  @$internal
  @override
  $ProviderElement<InstagramRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InstagramRepository create(Ref ref) {
    return instagramRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InstagramRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InstagramRepository>(value),
    );
  }
}

String _$instagramRepositoryHash() =>
    r'a2ed83137593999a48a16d8acca9b45b1430e478';

@ProviderFor(InstagramController)
const instagramControllerProvider = InstagramControllerProvider._();

final class InstagramControllerProvider
    extends $NotifierProvider<InstagramController, InstagramFeedState> {
  const InstagramControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instagramControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instagramControllerHash();

  @$internal
  @override
  InstagramController create() => InstagramController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InstagramFeedState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InstagramFeedState>(value),
    );
  }
}

String _$instagramControllerHash() =>
    r'cf2d77b61b69139b8e3572a6dd9025b97e29a6bf';

abstract class _$InstagramController extends $Notifier<InstagramFeedState> {
  InstagramFeedState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<InstagramFeedState, InstagramFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InstagramFeedState, InstagramFeedState>,
              InstagramFeedState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
