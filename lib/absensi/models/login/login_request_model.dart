// To parse this JSON data, do
//
//     final loginRequestModel = loginRequestModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'login_request_model.g.dart';

LoginRequestModel loginRequestModelFromJson(String str) =>
    LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class LoginRequestModel {
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "password")
  final String? password;

  LoginRequestModel({this.email, this.password});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}
