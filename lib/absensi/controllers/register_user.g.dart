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
    extends $AsyncNotifierProvider<RegisterUser, RegisterResponseModel?> {
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

String _$registerUserHash() => r'3fda5a0ca1c75f22a9360bc8a15f1f3e075dd0f9';

abstract class _$RegisterUser extends $AsyncNotifier<RegisterResponseModel?> {
  FutureOr<RegisterResponseModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<RegisterResponseModel?>, RegisterResponseModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<RegisterResponseModel?>,
                RegisterResponseModel?
              >,
              AsyncValue<RegisterResponseModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
