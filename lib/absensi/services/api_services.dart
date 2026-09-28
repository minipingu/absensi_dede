import 'package:absensi_dede/absensi/models/login/login_request_model.dart';
import 'package:absensi_dede/absensi/models/login/login_response_model.dart';
import 'package:absensi_dede/absensi/models/register/register_request_model.dart';
import 'package:absensi_dede/absensi/models/register/register_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: 'https://absensib1.mobileprojp.com')
abstract class ApiServices {
  factory ApiServices(Dio dio, {String? baseUrl}) = _ApiServices;

  @POST('/api/register')
  Future<RegisterResponseModel> registerUser(@Body() RegisterRequestModel user);

  @POST('/api/login')
  Future<LoginResponseModel> loginUser(@Body() LoginRequestModel user);
}
