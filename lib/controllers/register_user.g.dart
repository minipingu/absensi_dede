// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterUser)
final registerUserProvider = RegisterUserProvider._();

final class RegisterUserProvider
    extends $AsyncNotifierProvider<RegisterUser, RegisterModel?> {
  RegisterUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerUserHash();

  @$internal
  @override
  RegisterUser create() => RegisterUser();
}

String _$registerUserHash() => r'7cd4ccaeeee352f208bae13c304c1804828063a9';

abstract class _$RegisterUser extends $AsyncNotifier<RegisterModel?> {
  FutureOr<RegisterModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RegisterModel?>, RegisterModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RegisterModel?>, RegisterModel?>,
              AsyncValue<RegisterModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
