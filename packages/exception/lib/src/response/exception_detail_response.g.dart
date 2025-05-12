// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExceptionDetailResponse _$ExceptionDetailResponseFromJson(
  Map<String, dynamic> json,
) => ExceptionDetailResponse(
  parameter: json['parameter'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$ExceptionDetailResponseToJson(
  ExceptionDetailResponse instance,
) => <String, dynamic>{
  'parameter': instance.parameter,
  'message': instance.message,
};
