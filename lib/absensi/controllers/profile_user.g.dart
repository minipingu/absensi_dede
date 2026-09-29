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
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileUserHash();

  @$internal
  @override
  ProfileUser create() => ProfileUser();
}

String _$profileUserHash() => r'6b4189b6e660defb70c561138f5c2edbc71edb6c';

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
