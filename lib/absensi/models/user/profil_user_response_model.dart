// To parse this JSON data, do
//
//     final profilUserResponseModel = profilUserResponseModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'profil_user_response_model.g.dart';

ProfilUserResponseModel profilUserResponseModelFromJson(String str) =>
    ProfilUserResponseModel.fromJson(json.decode(str));

String profilUserResponseModelToJson(ProfilUserResponseModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class ProfilUserResponseModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final Data? data;

  ProfilUserResponseModel({this.message, this.data});

  factory ProfilUserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfilUserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilUserResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "email_verified_at")
  final dynamic emailVerifiedAt;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;

  Data({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
