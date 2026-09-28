// To parse this JSON data, do
//
//     final absenResponseModel = absenResponseModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'absen_response_model.g.dart';

AbsenResponseModel absenResponseModelFromJson(String str) =>
    AbsenResponseModel.fromJson(json.decode(str));

String absenResponseModelToJson(AbsenResponseModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class AbsenResponseModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final Data? data;

  AbsenResponseModel({this.message, this.data});

  factory AbsenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AbsenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AbsenResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "check_in")
  final String? checkIn;
  @JsonKey(name: "check_in_location")
  final String? checkInLocation;
  @JsonKey(name: "check_in_address")
  final String? checkInAddress;
  @JsonKey(name: "check_out")
  final String? checkOut;
  @JsonKey(name: "check_out_location")
  final String? checkOutLocation;
  @JsonKey(name: "check_out_address")
  final String? checkOutAddress;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "alasan_izin")
  final String? alasanIzin;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;
  @JsonKey(name: "check_in_lat")
  final double? checkInLat;
  @JsonKey(name: "check_in_lng")
  final double? checkInLng;
  @JsonKey(name: "check_out_lat")
  final double? checkOutLat;
  @JsonKey(name: "check_out_lng")
  final double? checkOutLng;

  Data({
    this.id,
    this.userId,
    this.checkIn,
    this.checkInLocation,
    this.checkInAddress,
    this.checkOut,
    this.checkOutLocation,
    this.checkOutAddress,
    this.status,
    this.alasanIzin,
    this.createdAt,
    this.updatedAt,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
