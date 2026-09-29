// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_out_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CheckOutUser)
final checkOutUserProvider = CheckOutUserProvider._();

final class CheckOutUserProvider
    extends $AsyncNotifierProvider<CheckOutUser, AbsenResponseModel?> {
  CheckOutUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkOutUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkOutUserHash();

  @$internal
  @override
  CheckOutUser create() => CheckOutUser();
}

String _$checkOutUserHash() => r'3c4067695d5d28e59cae26710481b6e3cbd6a6b4';

abstract class _$CheckOutUser extends $AsyncNotifier<AbsenResponseModel?> {
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
