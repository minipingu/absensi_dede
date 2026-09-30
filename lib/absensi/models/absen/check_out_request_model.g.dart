// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_out_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckOutRequestModel _$CheckOutRequestModelFromJson(
  Map<String, dynamic> json,
) => CheckOutRequestModel(
  checkOutLat: json['check_out_lat'] as String?,
  checkOutLng: json['check_out_lng'] as String?,
  checkOutLocation: json['check_out_location'] as String?,
  checkOutAddress: json['check_out_address'] as String?,
);

Map<String, dynamic> _$CheckOutRequestModelToJson(
  CheckOutRequestModel instance,
) => <String, dynamic>{
  'check_out_lat': instance.checkOutLat,
  'check_out_lng': instance.checkOutLng,
  'check_out_location': instance.checkOutLocation,
  'check_out_address': instance.checkOutAddress,
};
