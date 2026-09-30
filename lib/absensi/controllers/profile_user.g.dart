// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileUser)
final profileUserProvider = ProfileUserProvider._();

final class ProfileUserProvider
    extends $AsyncNotifierProvider<ProfileUser, ProfilUserResponseModel?> {
  ProfileUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileUserHash();

  @$internal
  @override
  ProfileUser create() => ProfileUser();
}

String _$profileUserHash() => r'59b6b2a846dbd2c6de74b83b1aba92bd4f2068f5';

abstract class _$ProfileUser extends $AsyncNotifier<ProfilUserResponseModel?> {
  FutureOr<ProfilUserResponseModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ProfilUserResponseModel?>,
              ProfilUserResponseModel?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ProfilUserResponseModel?>,
                ProfilUserResponseModel?
              >,
              AsyncValue<ProfilUserResponseModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
