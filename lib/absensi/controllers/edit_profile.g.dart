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
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editProfileHash();

  @$internal
  @override
  EditProfile create() => EditProfile();
}

String _$editProfileHash() => r'334612aea3dd55589f56ceb1f7b77edb0f43229e';

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
