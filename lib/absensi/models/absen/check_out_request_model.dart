// To parse this JSON data, do
//
//     final checkOutRequestModel = checkOutRequestModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'check_out_request_model.g.dart';

CheckOutRequestModel checkOutRequestModelFromJson(String str) =>
    CheckOutRequestModel.fromJson(json.decode(str));

String checkOutRequestModelToJson(CheckOutRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class CheckOutRequestModel {
  @JsonKey(name: "check_out_lat")
  final String? checkOutLat;
  @JsonKey(name: "check_out_lng")
  final String? checkOutLng;
  @JsonKey(name: "check_out_location")
  final String? checkOutLocation;
  @JsonKey(name: "check_out_address")
  final String? checkOutAddress;

  CheckOutRequestModel({
    this.checkOutLat,
    this.checkOutLng,
    this.checkOutLocation,
    this.checkOutAddress,
  });

  factory CheckOutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CheckOutRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckOutRequestModelToJson(this);
}
