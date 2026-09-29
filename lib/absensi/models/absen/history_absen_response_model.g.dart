// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_absen_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryAbsenResponseModel _$HistoryAbsenResponseModelFromJson(
  Map<String, dynamic> json,
) => HistoryAbsenResponseModel(
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HistoryAbsenResponseModelToJson(
  HistoryAbsenResponseModel instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  checkIn: json['check_in'] as String?,
  checkInLocation: json['check_in_location'] as String?,
  checkInAddress: json['check_in_address'] as String?,
  checkOut: json['check_out'],
  checkOutLocation: json['check_out_location'],
  checkOutAddress: json['check_out_address'],
  status: json['status'] as String?,
  alasanIzin: json['alasan_izin'],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  checkInLat: (json['check_in_lat'] as num?)?.toDouble(),
  checkInLng: (json['check_in_lng'] as num?)?.toDouble(),
  checkOutLat: json['check_out_lat'],
  checkOutLng: json['check_out_lng'],
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'check_in': instance.checkIn,
  'check_in_location': instance.checkInLocation,
  'check_in_address': instance.checkInAddress,
  'check_out': instance.checkOut,
  'check_out_location': instance.checkOutLocation,
  'check_out_address': instance.checkOutAddress,
  'status': instance.status,
  'alasan_izin': instance.alasanIzin,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'check_in_lat': instance.checkInLat,
  'check_in_lng': instance.checkInLng,
  'check_out_lat': instance.checkOutLat,
  'check_out_lng': instance.checkOutLng,
};
