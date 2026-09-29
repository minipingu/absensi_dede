// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CheckInUser)
final checkInUserProvider = CheckInUserProvider._();

final class CheckInUserProvider
    extends $AsyncNotifierProvider<CheckInUser, AbsenResponseModel?> {
  CheckInUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkInUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkInUserHash();

  @$internal
  @override
  CheckInUser create() => CheckInUser();
}

String _$checkInUserHash() => r'446bccc50068cff1ac345c1f217ccfa0c210d77d';

abstract class _$CheckInUser extends $AsyncNotifier<AbsenResponseModel?> {
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
