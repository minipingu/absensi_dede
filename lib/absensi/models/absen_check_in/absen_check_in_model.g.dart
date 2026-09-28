// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absen_check_in_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbsenCheckInModel _$AbsenCheckInModelFromJson(Map<String, dynamic> json) =>
    AbsenCheckInModel(
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AbsenCheckInModelToJson(AbsenCheckInModel instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  userId: (json['user_id'] as num?)?.toInt(),
  checkIn: json['check_in'] == null
      ? null
      : DateTime.parse(json['check_in'] as String),
  checkInLocation: json['check_in_location'] as String?,
  checkInAddress: json['check_in_address'] as String?,
  status: json['status'] as String?,
  alasanIzin: json['alasan_izin'],
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  id: (json['id'] as num?)?.toInt(),
  checkInLat: (json['check_in_lat'] as num?)?.toDouble(),
  checkInLng: (json['check_in_lng'] as num?)?.toDouble(),
  checkOutLat: (json['check_out_lat'] as num?)?.toDouble(),
  checkOutLng: (json['check_out_lng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'user_id': instance.userId,
  'check_in': instance.checkIn?.toIso8601String(),
  'check_in_location': instance.checkInLocation,
  'check_in_address': instance.checkInAddress,
  'status': instance.status,
  'alasan_izin': instance.alasanIzin,
  'updated_at': instance.updatedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'id': instance.id,
  'check_in_lat': instance.checkInLat,
  'check_in_lng': instance.checkInLng,
  'check_out_lat': instance.checkOutLat,
  'check_out_lng': instance.checkOutLng,
};
