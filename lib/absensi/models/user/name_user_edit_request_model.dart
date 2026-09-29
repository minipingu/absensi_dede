// To parse this JSON data, do
//
//     final nameUserEditRequestModel = nameUserEditRequestModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'name_user_edit_request_model.g.dart';

NameUserEditRequestModel nameUserEditRequestModelFromJson(String str) =>
    NameUserEditRequestModel.fromJson(json.decode(str));

String nameUserEditRequestModelToJson(NameUserEditRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class NameUserEditRequestModel {
  @JsonKey(name: "name")
  final String? name;

  NameUserEditRequestModel({this.name});

  factory NameUserEditRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NameUserEditRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$NameUserEditRequestModelToJson(this);
}
