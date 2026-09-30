import 'dart:developer' as developer;

import 'package:absensi_dede/absensi/models/user/profil_user_response_model.dart';
import 'package:absensi_dede/absensi/services/api_services.dart';
import 'package:absensi_dede/absensi/services/dio_client.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_user.g.dart';

@riverpod
class ProfileUser extends _$ProfileUser {
  late ApiServices _apiServices;

  @override
  FutureOr<ProfilUserResponseModel?> build() async {
    final dio = createDioClient();
    _apiServices = ApiServices(dio);
    return getProfile();
  }

  Future<ProfilUserResponseModel?> getProfile({String? token}) async {
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

      final response = await _apiServices.getProfile(token: authHeader);
      developer.log('Get profile response: ${response.toJson()}');

      if (response.data != null) {
        state = AsyncData(response);
        return response;
      } else {
        final errorMsg = response.message ?? 'Gagal memuat profil pengguna';
        state = AsyncError(errorMsg, StackTrace.current);
        return null;
      }
    } on DioException catch (e, st) {
      final errorMessage = _extractDioErrorMessage(e);
      developer.log('DioException during Get Profile: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    } catch (e, st) {
      final errorMessage = 'Error: $e';
      developer.log('Error during Get Profile: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    }
  }

  /// Alias refresh untuk memuat ulang profil pengguna
  Future<ProfilUserResponseModel?> refresh() async {
    return getProfile();
  }

  String _extractDioErrorMessage(DioException e) {
    String errorMessage = 'Terjadi kesalahan saat memuat profil';

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
