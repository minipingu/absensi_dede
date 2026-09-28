// To parse this JSON data, do
//
//     final registerRequestModel = registerRequestModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'register_request_model.g.dart';

RegisterRequestModel registerRequestModelFromJson(String str) =>
    RegisterRequestModel.fromJson(json.decode(str));

String registerRequestModelToJson(RegisterRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class RegisterRequestModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "password")
  final String? password;

  RegisterRequestModel({this.name, this.email, this.password});

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
