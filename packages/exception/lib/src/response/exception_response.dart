import 'package:json_annotation/json_annotation.dart';

part 'exception_response.g.dart';

@JsonSerializable()
class ExceptionResponse {
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "errors")
  final List<ExceptionResponse>? errors;

  ExceptionResponse({this.code, this.message, this.errors});

  factory ExceptionResponse.fromJson(Map<String, dynamic> json) =>
      _$ExceptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExceptionResponseToJson(this);
}
