import 'dart:developer' as developer;

import 'package:absensi_dede/absensi/models/register/register_request_model.dart';
import 'package:absensi_dede/absensi/models/register/register_response_model.dart';
import 'package:absensi_dede/absensi/services/api_services.dart';
import 'package:absensi_dede/absensi/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_user.g.dart';

@riverpod
class RegisterUser extends _$RegisterUser {
  late final ApiServices _apiServices;

  @override
  FutureOr<RegisterResponseModel?> build() {
    final dio = createDioClient();
    _apiServices = ApiServices(dio);
    return null;
  }

  Future<RegisterResponseModel?> register(
    RegisterRequestModel requestBody,
  ) async {
    state = const AsyncLoading();

    try {
      final response = await _apiServices.registerUser(requestBody);
      developer.log('Register response: ${response.toJson()}');

      state = AsyncData(response);
      return response;
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

      developer.log('DioException during register: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    } catch (e, st) {
      final errorMessage = 'Error: $e';
      developer.log('Error during register: $errorMessage');
      state = AsyncError(errorMessage, st);
      return null;
    }
  }
}
