import 'dart:developer' as developer;

import 'package:absensi_dede/absensi/models/login/login_request_model.dart';
import 'package:absensi_dede/absensi/models/login/login_response_model.dart';
import 'package:absensi_dede/absensi/services/api_services.dart';
import 'package:absensi_dede/absensi/services/dio_client.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_user.g.dart';

@riverpod
class LoginUser extends _$LoginUser {
  late final ApiServices _apiServices;

  @override
  FutureOr<LoginResponseModel?> build() {
    final dio = createDioClient();
    _apiServices = ApiServices(dio);
    return null;
  }

  Future<LoginResponseModel?> login(LoginRequestModel requestBody) async {
    state = const AsyncLoading();

    try {
      final response = await _apiServices.loginUser(requestBody);
      developer.log('Login response: ${response.toJson()}');

      if (response.data != null) {
        await LoginPreferences.saveLoginResponse(response);
        state = AsyncData(response);
        return response;
      } else {
        final errorMsg = response.message ?? 'Email atau password salah';
        state = AsyncError(errorMsg, StackTrace.current);
        return null;
      }
    } on DioException catch (e, st) {
      String errorMessage = 'Terjadi kesalahan saat login';

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
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      developer.log('DioException during login: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    } catch (e, st) {
      final errorMessage = 'Error: $e';
      developer.log('Error during login: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    }
  }
}
