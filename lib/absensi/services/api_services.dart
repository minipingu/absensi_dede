import 'package:absensi_dede/absensi/models/login_data.dart';
import 'package:absensi_dede/absensi/models/login_request.dart';
import 'package:absensi_dede/absensi/models/register_model.dart';
import 'package:absensi_dede/controller/register_user.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: 'https://absensib1.mobileprojp.com')
abstract class ApiServices {
  factory ApiServices(Dio dio, {String? baseUrl}) = _ApiServices;

  @POST('/api/register')
  Future<RegisterModel> registerUser(@Body() RegisterRequest user);

  @POST('/api/login')
  Future<LoginData> loginUser(@Body() LoginRequest user);
}
