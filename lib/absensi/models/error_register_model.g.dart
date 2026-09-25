// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorRegisterModel _$ErrorRegisterModelFromJson(Map<String, dynamic> json) =>
    ErrorRegisterModel(
      message: json['message'] as String?,
      errors: json['errors'] == null
          ? null
          : Errors.fromJson(json['errors'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ErrorRegisterModelToJson(ErrorRegisterModel instance) =>
    <String, dynamic>{'message': instance.message, 'errors': instance.errors};

Errors _$ErrorsFromJson(Map<String, dynamic> json) => Errors(
  email: (json['email'] as List<dynamic>?)?.map((e) => e as String).toList(),
  password: (json['password'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ErrorsToJson(Errors instance) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
};
