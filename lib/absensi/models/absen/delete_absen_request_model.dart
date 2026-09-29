// To parse this JSON data, do
//
//     final deleteAbsenRequestModel = deleteAbsenRequestModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'delete_absen_request_model.g.dart';

DeleteAbsenRequestModel deleteAbsenRequestModelFromJson(String str) =>
    DeleteAbsenRequestModel.fromJson(json.decode(str));

String deleteAbsenRequestModelToJson(DeleteAbsenRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class DeleteAbsenRequestModel {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "password")
  final String? password;

  DeleteAbsenRequestModel({this.name, this.email, this.password});

  factory DeleteAbsenRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteAbsenRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAbsenRequestModelToJson(this);
}
