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

String _$loginUserHash() => r'f6a2386e392d01ef2c6570cd32334e48e4e0786a';

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
