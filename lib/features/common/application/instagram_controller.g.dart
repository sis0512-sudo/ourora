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
const instagramControllerProvider = InstagramControllerFamily._();

final class InstagramControllerProvider
    extends $NotifierProvider<InstagramController, InstagramFeedState> {
  const InstagramControllerProvider._({
    required InstagramControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'instagramControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$instagramControllerHash();

  @override
  String toString() {
    return r'instagramControllerProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is InstagramControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$instagramControllerHash() =>
    r'ab9e20cb7144b65f0a359bd140abc79c05ecd2cd';

final class InstagramControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          InstagramController,
          InstagramFeedState,
          InstagramFeedState,
          InstagramFeedState,
          int
        > {
  const InstagramControllerFamily._()
    : super(
        retry: null,
        name: r'instagramControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InstagramControllerProvider call(int pageSize) =>
      InstagramControllerProvider._(argument: pageSize, from: this);

  @override
  String toString() => r'instagramControllerProvider';
}

abstract class _$InstagramController extends $Notifier<InstagramFeedState> {
  late final _$args = ref.$arg as int;
  int get pageSize => _$args;

  InstagramFeedState build(int pageSize);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
