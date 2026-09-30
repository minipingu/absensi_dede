import 'dart:developer' as developer;

import 'package:absensi_dede/absensi/models/absen/absen_response_model.dart';
import 'package:absensi_dede/absensi/models/absen/izin_request_model.dart';
import 'package:absensi_dede/absensi/services/api_services.dart';
import 'package:absensi_dede/absensi/services/dio_client.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'izin_user.g.dart';

@Riverpod(keepAlive: true)
class IzinUser extends _$IzinUser {
  late ApiServices _apiServices;

  @override
  FutureOr<AbsenResponseModel?> build() {
    final dio = createDioClient();
    _apiServices = ApiServices(dio);
    return null;
  }

  Future<AbsenResponseModel?> submitIzin(
    IzinRequestModel requestBody, {
    String? token,
  }) async {
    state = const AsyncLoading();

    try {
      final activeToken = token ?? await LoginPreferences.token;
      if (activeToken == null || activeToken.isEmpty) {
        const errorMsg = 'Token tidak ditemukan. Silakan login kembali.';
        if (ref.mounted) {
          state = AsyncError(errorMsg, StackTrace.current);
        }
        return null;
      }

      final authHeader = activeToken.startsWith('Bearer ')
          ? activeToken
          : 'Bearer $activeToken';

      final response = await _apiServices.submitIzin(authHeader, requestBody);
      developer.log('Submit izin response: ${response.toJson()}');

      if (response.data != null) {
        if (ref.mounted) {
          state = AsyncData(response);
        }
        return response;
      } else {
        final errorMsg =
            response.message ??
            'Terjadi kesalahan saat membuat izin, tidak ada pesan dari server';
        if (ref.mounted) {
          state = AsyncError(errorMsg, StackTrace.current);
        }
        return null;
      }
    } on DioException catch (e, st) {
      String errorMessage = 'Terjadi kesalahan saat membuat izin';

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

      developer.log('DioException during submit izin: $errorMessage');
      if (ref.mounted) {
        state = AsyncError(errorMessage, st);
      }
      return null;
    } catch (e, st) {
      final errorMessage = 'Error: $e';
      developer.log('Error during submit izin: $errorMessage');
      if (ref.mounted) {
        state = AsyncError(errorMessage, st);
      }
      return null;
    }
  }
}
