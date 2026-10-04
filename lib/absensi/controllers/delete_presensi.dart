import 'dart:developer' as developer;

import 'package:absensi_kopdes/absensi/models/absen/absen_response_model.dart';
import 'package:absensi_kopdes/absensi/models/absen/delete_absen_request_model.dart';
import 'package:absensi_kopdes/absensi/services/api_services.dart';
import 'package:absensi_kopdes/absensi/services/dio_client.dart';
import 'package:absensi_kopdes/absensi/services/login_preferences.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_presensi.g.dart';

@riverpod
class DeletePresensi extends _$DeletePresensi {
  late ApiServices _apiServices;

  @override
  FutureOr<AbsenResponseModel?> build() {
    final dio = createDioClient();
    _apiServices = ApiServices(dio);
    return null;
  }

  Future<AbsenResponseModel?> delete({
    int? id,
    DeleteAbsenRequestModel? requestBody,
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

      final activeUserId = id ?? await LoginPreferences.userId;
      if (activeUserId == null) {
        const errorMsg = 'User ID tidak ditemukan. Silakan login kembali.';
        state = AsyncError(errorMsg, StackTrace.current);
        return null;
      }

      final authHeader = activeToken.startsWith('Bearer ')
          ? activeToken
          : 'Bearer $activeToken';

      final body = requestBody ?? DeleteAbsenRequestModel();

      final response = await _apiServices.deletePresensi(
        activeUserId,
        authHeader,
        body,
      );
      developer.log('Delete presensi response: ${response.toJson()}');

      state = AsyncData(response);
      return response;
    } on DioException catch (e, st) {
      String errorMessage = 'Terjadi kesalahan saat menghapus presensi';

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

      developer.log('DioException during Delete Presensi: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    } catch (e, st) {
      final errorMessage = 'Error: $e';
      developer.log('Error during Delete Presensi: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    }
  }

  /// Alias method deletePresensi
  Future<AbsenResponseModel?> deletePresensi({
    int? id,
    DeleteAbsenRequestModel? requestBody,
    String? token,
  }) {
    return delete(id: id, requestBody: requestBody, token: token);
  }
}
