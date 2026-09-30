// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'izin_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IzinUser)
final izinUserProvider = IzinUserProvider._();

final class IzinUserProvider
    extends $AsyncNotifierProvider<IzinUser, AbsenResponseModel?> {
  IzinUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'izinUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$izinUserHash();

  @$internal
  @override
  IzinUser create() => IzinUser();
}

String _$izinUserHash() => r'33803cf7feebc743037bc7df1f7aaffaab2a11d8';

abstract class _$IzinUser extends $AsyncNotifier<AbsenResponseModel?> {
  FutureOr<AbsenResponseModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AbsenResponseModel?>, AbsenResponseModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AbsenResponseModel?>, AbsenResponseModel?>,
              AsyncValue<AbsenResponseModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
