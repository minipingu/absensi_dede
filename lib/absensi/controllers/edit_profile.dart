import 'dart:developer' as developer;

import 'package:absensi_dede/absensi/controllers/profile_user.dart';
import 'package:absensi_dede/absensi/models/login/login_response_model.dart'
    as login_model;
import 'package:absensi_dede/absensi/models/user/name_user_edit_request_model.dart';
import 'package:absensi_dede/absensi/models/user/profil_user_response_model.dart';
import 'package:absensi_dede/absensi/riverpod/user_riverpod.dart';
import 'package:absensi_dede/absensi/services/api_services.dart';
import 'package:absensi_dede/absensi/services/dio_client.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_profile.g.dart';

@riverpod
class EditProfile extends _$EditProfile {
  late final ApiServices _apiServices;

  @override
  FutureOr<ProfilUserResponseModel?> build() {
    final dio = createDioClient();
    _apiServices = ApiServices(dio);
    return null;
  }

  Future<ProfilUserResponseModel?> editProfile(
    NameUserEditRequestModel requestBody, {
    String? token,
  }) async {
    state = const AsyncLoading();

    try {
      final activeToken = token ?? await LoginPreferences.token;
      if (activeToken == null || activeToken.isEmpty) {
        const errorMsg = 'Token tidak ditemukan. Silakan login kembali.';
        state = AsyncError(errorMsg, StackTrace.current);
        return null;
      }

      final authHeader = activeToken.startsWith('Bearer ')
          ? activeToken
          : 'Bearer $activeToken';

      final response = await _apiServices.editProfile(authHeader, requestBody);
      developer.log('Edit profile response: ${response.toJson()}');

      if (response.data != null) {
        if (response.data?.name != null) {
          final currentUser = await LoginPreferences.user;
          final updatedUser = login_model.User(
            id: response.data!.id ?? currentUser?.id,
            name: response.data!.name,
            email: response.data!.email ?? currentUser?.email,
            createdAt: response.data!.createdAt ?? currentUser?.createdAt,
            updatedAt: response.data!.updatedAt ?? currentUser?.updatedAt,
          );
          await LoginPreferences.saveUser(updatedUser);
          ref.invalidate(userNameRiverpod);
        }

        // Invalidate ProfileUser agar UI ProfileScreen otomatis reload
        ref.invalidate(profileUserProvider);

        state = AsyncData(response);
        return response;
      } else {
        final errorMsg = response.message ?? 'Gagal memperbarui profil';
        state = AsyncError(errorMsg, StackTrace.current);
        return null;
      }
    } on DioException catch (e, st) {
      final errorMessage = _extractDioErrorMessage(e);
      developer.log('DioException during Edit Profile: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    } catch (e, st) {
      final errorMessage = 'Error: $e';
      developer.log('Error during Edit Profile: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    }
  }

  String _extractDioErrorMessage(DioException e) {
    String errorMessage = 'Terjadi kesalahan saat mengubah profil';

    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;

      if (data['message'] != null) {
        errorMessage = data['message'].toString();
      } else if (data['errors'] is Map) {
        final errors = data['errors'] as Map;

        if (errors.isNotEmpty) {
          final firstError = errors.values.first;

          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first.toString();
          }
        }
      }
    } else if (e.message != null && e.message!.isNotEmpty) {
      errorMessage = e.message!;
    }

    return errorMessage;
  }
}
