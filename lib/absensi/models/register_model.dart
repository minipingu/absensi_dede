import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'register_model.g.dart';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str) as Map<String, dynamic>);

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

ErrorRegisterModel errorRegisterModelFromJson(String str) =>
    ErrorRegisterModel.fromJson(json.decode(str) as Map<String, dynamic>);

String errorRegisterModelToJson(ErrorRegisterModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "email")
  final String email;

  @JsonKey(name: "password")
  final String password;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class RegisterModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final Data? data;

  RegisterModel({this.message, this.data});

  factory RegisterModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "token")
  final String? token;
  @JsonKey(name: "user")
  final User? user;

  Data({this.token, this.user});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "id")
  final int? id;

  User({this.name, this.email, this.updatedAt, this.createdAt, this.id});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

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
