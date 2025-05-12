// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExceptionResponse _$ExceptionResponseFromJson(Map<String, dynamic> json) =>
    ExceptionResponse(
      code: json['code'] as String?,
      message: json['message'] as String?,
      errors:
          (json['errors'] as List<dynamic>?)
              ?.map(
                (e) => ExceptionResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );

Map<String, dynamic> _$ExceptionResponseToJson(ExceptionResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'errors': instance.errors,
    };
