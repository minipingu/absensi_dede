import 'package:absensi_dede/absensi/models/absen/absen_response_model.dart';
import 'package:absensi_dede/absensi/models/absen/check_in_request_model.dart';
import 'package:absensi_dede/absensi/models/absen/check_out_request_model.dart';
import 'package:absensi_dede/absensi/models/absen/delete_absen_request_model.dart';
import 'package:absensi_dede/absensi/models/absen/history_absen_response_model.dart';
import 'package:absensi_dede/absensi/models/login/login_request_model.dart';
import 'package:absensi_dede/absensi/models/login/login_response_model.dart';
import 'package:absensi_dede/absensi/models/register/register_request_model.dart';
import 'package:absensi_dede/absensi/models/register/register_response_model.dart';
import 'package:absensi_dede/absensi/models/user/name_user_edit_request_model.dart';
import 'package:absensi_dede/absensi/models/user/profil_user_response_model.dart';
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

  @GET('/api/absen/history')
  Future<HistoryAbsenResponseModel> getAbsenHistory({
    @Header('Authorization') String? token,
  });

  @POST('/api/absen/check-in')
  Future<AbsenResponseModel> checkInUser(
    @Header('Authorization') String? token,
    @Body() CheckInRequestModel checkIn,
  );

  @POST('/api/absen/check-out')
  Future<AbsenResponseModel> checkOutUser(
    @Header('Authorization') String? token,
    @Body() CheckOutRequestModel checkOut,
  );

  //Delete Absen
  @DELETE('/api/absen/{id}')
  Future<AbsenResponseModel> deletePresensi(
    @Path('id') int id,
    @Header('Authorization') String? token,
    @Body() DeleteAbsenRequestModel delete,
  );

  @POST('/api/profile')
  Future<ProfilUserResponseModel> getProfile({
    @Header('Authorization') String? token,
  });

  @PUT('/api/profile')
  Future<ProfilUserResponseModel> editProfile(
    @Header('Authorization') String? token,
    @Body() NameUserEditRequestModel userName,
  );
}
