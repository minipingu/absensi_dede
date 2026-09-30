// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'izin_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IzinRequestModel _$IzinRequestModelFromJson(Map<String, dynamic> json) =>
    IzinRequestModel(
      checkInLat: json['check_in_lat'] as String?,
      checkInLng: json['check_in_lng'] as String?,
      checkInAddress: json['check_in_address'] as String?,
      status: json['status'] as String?,
      alasanIzin: json['alasan_izin'] as String?,
    );

Map<String, dynamic> _$IzinRequestModelToJson(IzinRequestModel instance) =>
    <String, dynamic>{
      'check_in_lat': instance.checkInLat,
      'check_in_lng': instance.checkInLng,
      'check_in_address': instance.checkInAddress,
      'status': instance.status,
      'alasan_izin': instance.alasanIzin,
    };
