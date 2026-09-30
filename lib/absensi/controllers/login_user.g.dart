// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginUser)
final loginUserProvider = LoginUserProvider._();

final class LoginUserProvider
    extends $AsyncNotifierProvider<LoginUser, LoginResponseModel?> {
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

String _$loginUserHash() => r'b0410515df573d054790f7a9df828c0bc714984c';

abstract class _$LoginUser extends $AsyncNotifier<LoginResponseModel?> {
  FutureOr<LoginResponseModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<LoginResponseModel?>, LoginResponseModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoginResponseModel?>, LoginResponseModel?>,
              AsyncValue<LoginResponseModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
