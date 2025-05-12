import 'package:json_annotation/json_annotation.dart';

part 'exception_detail_response.g.dart';

@JsonSerializable()
class ExceptionDetailResponse {
  @JsonKey(name: "parameter")
  final String? parameter;
  @JsonKey(name: "message")
  final String? message;

  ExceptionDetailResponse({this.parameter, this.message});

  factory ExceptionDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ExceptionDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExceptionDetailResponseToJson(this);
}
