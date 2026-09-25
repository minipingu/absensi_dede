import 'package:dio/dio.dart';

Dio createDioClient() {
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
      },
    ),
  );

  // LogInterceptor mencetak detail request dan response di console/debugger
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
}
