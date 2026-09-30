// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_absen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HistoryAbsen)
final historyAbsenProvider = HistoryAbsenProvider._();

final class HistoryAbsenProvider
    extends $AsyncNotifierProvider<HistoryAbsen, HistoryAbsenResponseModel?> {
  HistoryAbsenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyAbsenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyAbsenHash();

  @$internal
  @override
  HistoryAbsen create() => HistoryAbsen();
}

String _$historyAbsenHash() => r'157349ab8f3ca1c837d76ec854610cd7e32d3570';

abstract class _$HistoryAbsen
    extends $AsyncNotifier<HistoryAbsenResponseModel?> {
  FutureOr<HistoryAbsenResponseModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<HistoryAbsenResponseModel?>,
              HistoryAbsenResponseModel?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<HistoryAbsenResponseModel?>,
                HistoryAbsenResponseModel?
              >,
              AsyncValue<HistoryAbsenResponseModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
