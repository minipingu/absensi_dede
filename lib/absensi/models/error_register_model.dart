// To parse this JSON data, do
//
//     final errorRegisterModel = errorRegisterModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'error_register_model.g.dart';

ErrorRegisterModel errorRegisterModelFromJson(String str) =>
    ErrorRegisterModel.fromJson(json.decode(str));

String errorRegisterModelToJson(ErrorRegisterModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class ErrorRegisterModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "errors")
  final Errors? errors;

  ErrorRegisterModel({this.message, this.errors});

  factory ErrorRegisterModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorRegisterModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorRegisterModelToJson(this);
}

@JsonSerializable()
class Errors {
  @JsonKey(name: "email")
  final List<String>? email;
  @JsonKey(name: "password")
  final List<String>? password;

  Errors({this.email, this.password});

  factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorsToJson(this);
}
