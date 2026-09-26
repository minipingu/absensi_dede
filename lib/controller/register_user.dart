import 'package:absensi_dede/absensi/models/register_model.dart';
import 'package:absensi_dede/absensi/services/api_services.dart';
import 'package:absensi_dede/absensi/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_user.g.dart';

@riverpod
class RegisterUser extends _$RegisterUser {
  late final ApiServices _apiServices;

  @override
  FutureOr<void> build() {
    final dio = createDioClient(); //  Gunakan konfigurasi Dio yang sudah benar
    _apiServices = ApiServices(dio);
  }

  Future<void> register(RegisterRequest requestBody) async {
    state = const AsyncLoading();

    try {
      final response = await _apiServices.registerUser(requestBody);
      print(response);

      state = AsyncData(response);
    } on DioException catch (e, st) {
      String errorMessage = 'Terjadi kesalahan saat registrasi';

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
