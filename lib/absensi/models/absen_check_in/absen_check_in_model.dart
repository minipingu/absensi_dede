// To parse this JSON data, do
//
//     final absenCheckInModel = absenCheckInModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'absen_check_in_model.g.dart';

AbsenCheckInModel absenCheckInModelFromJson(String str) =>
    AbsenCheckInModel.fromJson(json.decode(str));

String absenCheckInModelToJson(AbsenCheckInModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class AbsenCheckInModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final Data? data;

  AbsenCheckInModel({this.message, this.data});

  factory AbsenCheckInModel.fromJson(Map<String, dynamic> json) =>
      _$AbsenCheckInModelFromJson(json);

  Map<String, dynamic> toJson() => _$AbsenCheckInModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "check_in")
  final DateTime? checkIn;
  @JsonKey(name: "check_in_location")
  final String? checkInLocation;
  @JsonKey(name: "check_in_address")
  final String? checkInAddress;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "alasan_izin")
  final dynamic alasanIzin;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "check_in_lat")
  final double? checkInLat;
  @JsonKey(name: "check_in_lng")
  final double? checkInLng;
  @JsonKey(name: "check_out_lat")
  final double? checkOutLat;
  @JsonKey(name: "check_out_lng")
  final double? checkOutLng;

  Data({
    this.userId,
    this.checkIn,
    this.checkInLocation,
    this.checkInAddress,
    this.status,
    this.alasanIzin,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
