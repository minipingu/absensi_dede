import 'package:absensi_dede/absensi/models/login_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_data.g.dart';

@JsonSerializable()
class LoginData {
  @JsonKey(name: 'token')
  final String? token;

  @JsonKey(name: 'user')
  final LoginUser? user;

  LoginData({this.token, this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}
