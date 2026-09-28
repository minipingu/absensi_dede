// To parse this JSON data, do
//
//     final registerErrorModel = registerErrorModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'register_error_model.g.dart';

RegisterErrorModel registerErrorModelFromJson(String str) =>
    RegisterErrorModel.fromJson(json.decode(str));

String registerErrorModelToJson(RegisterErrorModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class RegisterErrorModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "errors")
  final Errors? errors;

  RegisterErrorModel({this.message, this.errors});

  factory RegisterErrorModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterErrorModelToJson(this);
}

@JsonSerializable()
class Errors {
  @JsonKey(name: "name")
  final List<String>? name;
  @JsonKey(name: "email")
  final List<String>? email;
  @JsonKey(name: "password")
  final List<String>? password;

  Errors({this.name, this.email, this.password});

  factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorsToJson(this);
}
