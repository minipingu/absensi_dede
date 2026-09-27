// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginUser)
final loginUserProvider = LoginUserProvider._();

final class LoginUserProvider extends $AsyncNotifierProvider<LoginUser, void> {
  LoginUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginUserHash();

  @$internal
  @override
  LoginUser create() => LoginUser();
}

String _$loginUserHash() => r'4a73b9679790dcb4c8a31a360d2ee9dd22e8209f';

abstract class _$LoginUser extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
