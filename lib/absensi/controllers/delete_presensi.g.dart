// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_presensi.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeletePresensi)
final deletePresensiProvider = DeletePresensiProvider._();

final class DeletePresensiProvider
    extends $AsyncNotifierProvider<DeletePresensi, AbsenResponseModel?> {
  DeletePresensiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deletePresensiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deletePresensiHash();

  @$internal
  @override
  DeletePresensi create() => DeletePresensi();
}

String _$deletePresensiHash() => r'a61c2734dbbb53c7519d790690a5f223a7e0d5d3';

abstract class _$DeletePresensi extends $AsyncNotifier<AbsenResponseModel?> {
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
