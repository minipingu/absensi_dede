// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInRequestModel _$CheckInRequestModelFromJson(Map<String, dynamic> json) =>
    CheckInRequestModel(
      checkInLat: json['check_in_lat'] as String?,
      checkInLng: json['check_in_lng'] as String?,
      checkInAddress: json['check_in_address'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$CheckInRequestModelToJson(
  CheckInRequestModel instance,
) => <String, dynamic>{
  'check_in_lat': instance.checkInLat,
  'check_in_lng': instance.checkInLng,
  'check_in_address': instance.checkInAddress,
  'status': instance.status,
};
