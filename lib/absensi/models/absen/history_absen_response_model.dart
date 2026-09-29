// To parse this JSON data, do
//
//     final historyAbsenResponseModel = historyAbsenResponseModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'history_absen_response_model.g.dart';

HistoryAbsenResponseModel historyAbsenResponseModelFromJson(String str) =>
    HistoryAbsenResponseModel.fromJson(json.decode(str));

String historyAbsenResponseModelToJson(HistoryAbsenResponseModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class HistoryAbsenResponseModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final List<Data>? data;

  HistoryAbsenResponseModel({this.message, this.data});

  factory HistoryAbsenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryAbsenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryAbsenResponseModelToJson(this);
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
  final dynamic checkOut;
  @JsonKey(name: "check_out_location")
  final dynamic checkOutLocation;
  @JsonKey(name: "check_out_address")
  final dynamic checkOutAddress;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "alasan_izin")
  final dynamic alasanIzin;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;
  @JsonKey(name: "check_in_lat")
  final double? checkInLat;
  @JsonKey(name: "check_in_lng")
  final double? checkInLng;
  @JsonKey(name: "check_out_lat")
  final dynamic checkOutLat;
  @JsonKey(name: "check_out_lng")
  final dynamic checkOutLng;

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
