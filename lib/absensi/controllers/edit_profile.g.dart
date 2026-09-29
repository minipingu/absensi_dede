// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditProfile)
final editProfileProvider = EditProfileProvider._();

final class EditProfileProvider
    extends $AsyncNotifierProvider<EditProfile, ProfilUserResponseModel?> {
  EditProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editProfileHash();

  @$internal
  @override
  EditProfile create() => EditProfile();
}

String _$editProfileHash() => r'0c03a94009fd80fd99357915ba73e82fb8dff3ea';

abstract class _$EditProfile extends $AsyncNotifier<ProfilUserResponseModel?> {
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
