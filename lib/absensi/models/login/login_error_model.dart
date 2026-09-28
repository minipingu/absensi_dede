// To parse this JSON data, do
//
//     final loginErrorModel = loginErrorModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'login_error_model.g.dart';

LoginErrorModel loginErrorModelFromJson(String str) =>
    LoginErrorModel.fromJson(json.decode(str));

String loginErrorModelToJson(LoginErrorModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class LoginErrorModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final dynamic data;

  LoginErrorModel({this.message, this.data});

  factory LoginErrorModel.fromJson(Map<String, dynamic> json) =>
      _$LoginErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginErrorModelToJson(this);
}
