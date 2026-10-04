import 'dart:developer' as developer;

import 'package:absensi_kopdes/absensi/models/absen/history_absen_response_model.dart';
import 'package:absensi_kopdes/absensi/services/api_services.dart';
import 'package:absensi_kopdes/absensi/services/dio_client.dart';
import 'package:absensi_kopdes/absensi/services/login_preferences.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_absen.g.dart';

@riverpod
class HistoryAbsen extends _$HistoryAbsen {
  late ApiServices _apiServices;

  @override
  FutureOr<HistoryAbsenResponseModel?> build() async {
    final dio = createDioClient();
    _apiServices = ApiServices(dio);

    final token = await LoginPreferences.token;
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final response = await _apiServices.getAbsenHistory(
        token: 'Bearer $token',
      );
      developer.log('History Absen build loaded: ${response.toJson()}');
      return response;
    } on DioException catch (e) {
      final errorMsg = _extractDioErrorMessage(e);
      developer.log('DioException during build history absen: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      developer.log('Error during build history absen: $e');
      rethrow;
    }
  }

  /// Alias refresh untuk memuat ulang riwayat absensi (digunakan di RefreshIndicator / tombol Coba Lagi)
  Future<HistoryAbsenResponseModel?> refresh() async {
    return getHistoryAbsen();
  }

  /// Memuat ulang / mengambil riwayat absensi secara manual.
  Future<HistoryAbsenResponseModel?> getHistoryAbsen() async {
    state = const AsyncLoading();

    try {
      final token = await LoginPreferences.token;
      if (token == null || token.isEmpty) {
        const errorMsg = 'Token tidak ditemukan. Silakan login kembali.';
        state = AsyncError(errorMsg, StackTrace.current);
        return null;
      }

      final response = await _apiServices.getAbsenHistory(
        token: 'Bearer $token',
      );
      developer.log('History Absen response: ${response.toJson()}');

      state = AsyncData(response);
      return response;
    } on DioException catch (e, st) {
      final errorMessage = _extractDioErrorMessage(e);
      developer.log('DioException during getHistoryAbsen: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    } catch (e, st) {
      final errorMessage = 'Terjadi kesalahan: $e';
      developer.log('Error during getHistoryAbsen: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    }
  }

  /// Ekstraksi pesan error dari DioException.
  String _extractDioErrorMessage(DioException e) {
    String errorMessage = 'Terjadi kesalahan saat memuat riwayat absensi';

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
