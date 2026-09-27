import 'package:absensi_dede/absensi/models/login_request.dart';
import 'package:absensi_dede/absensi/models/register_model.dart';
import 'package:absensi_dede/absensi/services/api_services.dart';
import 'package:absensi_dede/absensi/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_user.g.dart';

@riverpod
class LoginUser extends _$LoginUser {
  late final ApiServices _apiServices;

  @override
  FutureOr<void> build() {
    final dio = createDioClient(); //  Gunakan konfigurasi Dio yang sudah benar
    _apiServices = ApiServices(dio);
  }

  Future<void> login(LoginRequest requestBody) async {
    state = const AsyncLoading();

    try {
      final response = await _apiServices.loginUser(requestBody);
      print(response);

      state = AsyncData(response);
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

      state = AsyncError(errorMessage, st);
    } catch (e, st) {
      state = AsyncError('Error: $e', st);
    }
  }
}
