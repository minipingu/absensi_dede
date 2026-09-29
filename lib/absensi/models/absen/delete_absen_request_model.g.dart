// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_absen_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteAbsenRequestModel _$DeleteAbsenRequestModelFromJson(
  Map<String, dynamic> json,
) => DeleteAbsenRequestModel(
  name: json['name'] as String?,
  email: json['email'] as String?,
  password: json['password'] as String?,
);

Map<String, dynamic> _$DeleteAbsenRequestModelToJson(
  DeleteAbsenRequestModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
};
