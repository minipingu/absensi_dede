import 'package:absensi_dede/absensi/models/login_data.dart';
import 'package:json_annotation/json_annotation.dart';

export 'package:absensi_dede/absensi/models/login_data.dart';
export 'package:absensi_dede/absensi/models/login_user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final LoginData? data;

  LoginResponse({this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

typedef LoginModel = LoginResponse;
