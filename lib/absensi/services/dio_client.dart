import 'package:absensi_kopdes/absensi/services/login_preferences.dart';
import 'package:dio/dio.dart';

Dio createDioClient({String? token}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://absensib1.mobileprojp.com',
      connectTimeout: const Duration(
        seconds: 10,
      ), // Timeout saat mencoba menghubungkan ke server
      receiveTimeout: const Duration(
        seconds: 10,
      ), // Timeout saat menunggu respon data
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    ),
  );

  // Otomatis menambahkan token dari LoginPreferences jika belum ada Authorization di header
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!options.headers.containsKey('Authorization') ||
            options.headers['Authorization'] == null) {
          final savedToken = await LoginPreferences.token;
          if (savedToken != null && savedToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $savedToken';
          }
        }
        return handler.next(options);
      },
    ),
  );

  // LogInterceptor mencetak detail request dan response di console/debugger
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
}
