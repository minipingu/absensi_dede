// To parse this JSON data, do
//
//     final izinRequestModel = izinRequestModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'izin_request_model.g.dart';

IzinRequestModel izinRequestModelFromJson(String str) =>
    IzinRequestModel.fromJson(json.decode(str));

String izinRequestModelToJson(IzinRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class IzinRequestModel {
  @JsonKey(name: "check_in_lat")
  final String? checkInLat;
  @JsonKey(name: "check_in_lng")
  final String? checkInLng;
  @JsonKey(name: "check_in_address")
  final String? checkInAddress;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "alasan_izin")
  final String? alasanIzin;

  IzinRequestModel({
    this.checkInLat,
    this.checkInLng,
    this.checkInAddress,
    this.status,
    this.alasanIzin,
  });

  factory IzinRequestModel.fromJson(Map<String, dynamic> json) =>
      _$IzinRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$IzinRequestModelToJson(this);
}
