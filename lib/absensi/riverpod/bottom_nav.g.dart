// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_nav.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BottomNav)
final bottomNavProvider = BottomNavProvider._();

final class BottomNavProvider extends $NotifierProvider<BottomNav, int> {
  BottomNavProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bottomNavProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bottomNavHash();

  @$internal
  @override
  BottomNav create() => BottomNav();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$bottomNavHash() => r'd0687d8557c2b6cf70e40033622ba403c0f85c16';

abstract class _$BottomNav extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
