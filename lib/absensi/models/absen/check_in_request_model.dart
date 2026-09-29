// To parse this JSON data, do
//
//     final checkInRequestModel = checkInRequestModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'check_in_request_model.g.dart';

CheckInRequestModel checkInRequestModelFromJson(String str) =>
    CheckInRequestModel.fromJson(json.decode(str));

String checkInRequestModelToJson(CheckInRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class CheckInRequestModel {
  @JsonKey(name: "check_in_lat")
  final String? checkInLat;
  @JsonKey(name: "check_in_lng")
  final String? checkInLng;
  @JsonKey(name: "check_in_address")
  final String? checkInAddress;
  @JsonKey(name: "status")
  final String? status;

  CheckInRequestModel({
    this.checkInLat,
    this.checkInLng,
    this.checkInAddress,
    this.status,
  });

  factory CheckInRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CheckInRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInRequestModelToJson(this);
}
