// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterErrorModel _$RegisterErrorModelFromJson(Map<String, dynamic> json) =>
    RegisterErrorModel(
      message: json['message'] as String?,
      errors: json['errors'] == null
          ? null
          : Errors.fromJson(json['errors'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterErrorModelToJson(RegisterErrorModel instance) =>
    <String, dynamic>{'message': instance.message, 'errors': instance.errors};

Errors _$ErrorsFromJson(Map<String, dynamic> json) => Errors(
  name: (json['name'] as List<dynamic>?)?.map((e) => e as String).toList(),
  email: (json['email'] as List<dynamic>?)?.map((e) => e as String).toList(),
  password: (json['password'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ErrorsToJson(Errors instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
};
