import 'dart:developer' as developer;

import 'package:absensi_dede/absensi/models/login/login_response_model.dart'
    as login_model;
import 'package:absensi_dede/absensi/models/user/profil_user_response_model.dart';
import 'package:absensi_dede/absensi/services/api_services.dart';
import 'package:absensi_dede/absensi/services/dio_client.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_user.g.dart';

@Riverpod(keepAlive: true)
class ProfileUser extends _$ProfileUser {
  late ApiServices _apiServices;

  @override
  FutureOr<ProfilUserResponseModel?> build() async {
    final dio = createDioClient();
    _apiServices = ApiServices(dio);
    return _fetchProfile();
  }

  Future<ProfilUserResponseModel?> _fetchProfile({String? token}) async {
    final activeToken = token ?? await LoginPreferences.token;

    // Jika token tidak ada, coba ambil data dari LoginPreferences (offline/fallback)
    if (activeToken == null || activeToken.isEmpty) {
      final cachedUser = await LoginPreferences.user;
      if (cachedUser != null) {
        return ProfilUserResponseModel(
          message: 'Data lokal',
          data: Data(
            id: cachedUser.id,
            name: cachedUser.name,
            email: cachedUser.email,
            emailVerifiedAt: cachedUser.emailVerifiedAt,
            createdAt: cachedUser.createdAt,
            updatedAt: cachedUser.updatedAt,
          ),
        );
      }
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final authHeader = activeToken.startsWith('Bearer ')
        ? activeToken
        : 'Bearer $activeToken';

    try {
      final response = await _apiServices.getProfile(token: authHeader);
      developer.log('Get profile response: ${response.toJson()}');

      if (response.data != null) {
        // Update data user di LoginPreferences agar selalu sinkron dan fresh
        final u = response.data!;
        final currentUser = await LoginPreferences.user;
        await LoginPreferences.saveUser(
          login_model.User(
            id: u.id ?? currentUser?.id,
            name: u.name ?? currentUser?.name,
            email: u.email ?? currentUser?.email,
            emailVerifiedAt: u.emailVerifiedAt ?? currentUser?.emailVerifiedAt,
            createdAt: u.createdAt ?? currentUser?.createdAt,
            updatedAt: u.updatedAt ?? currentUser?.updatedAt,
          ),
        );
        return response;
      } else {
        throw Exception(response.message ?? 'Gagal memuat profil pengguna');
      }
    } on DioException catch (e) {
      final errorMessage = _extractDioErrorMessage(e);
      developer.log('DioException during Get Profile: $errorMessage');

      // Coba fallback ke cached user jika ada gangguan koneksi/server
      final cachedUser = await LoginPreferences.user;
      if (cachedUser != null) {
        return ProfilUserResponseModel(
          message: 'Data lokal (offline)',
          data: Data(
            id: cachedUser.id,
            name: cachedUser.name,
            email: cachedUser.email,
            emailVerifiedAt: cachedUser.emailVerifiedAt,
            createdAt: cachedUser.createdAt,
            updatedAt: cachedUser.updatedAt,
          ),
        );
      }
      throw Exception(errorMessage);
    } catch (e) {
      developer.log('Error during Get Profile: $e');
      final cachedUser = await LoginPreferences.user;
      if (cachedUser != null) {
        return ProfilUserResponseModel(
          message: 'Data lokal',
          data: Data(
            id: cachedUser.id,
            name: cachedUser.name,
            email: cachedUser.email,
            emailVerifiedAt: cachedUser.emailVerifiedAt,
            createdAt: cachedUser.createdAt,
            updatedAt: cachedUser.updatedAt,
          ),
        );
      }
      rethrow;
    }
  }

  /// Memuat profil secara eksplisit
  Future<ProfilUserResponseModel?> getProfile({String? token}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProfile(token: token));
    return state.value;
  }

  /// Alias refresh untuk memuat ulang profil pengguna
  Future<ProfilUserResponseModel?> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProfile());
    return state.value;
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
