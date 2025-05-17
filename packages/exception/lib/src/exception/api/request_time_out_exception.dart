import 'package:dio/dio.dart';
import 'package:exception/exception.dart';
// ignore: unnecessary_import
import 'package:exception/src/exception/core/core_exception.dart';
import 'package:exception/src/model/exception_rule.dart';

class RequestTimeOutException extends CoreException {
  RequestTimeOutException({
    required this.module,
    required this.layer,
    required this.function,
    this.stackTrace,
  });

  @override
  String module;

  @override
  String layer;

  @override
  String function;

  @override
  String get code => generatedCode(code: ExceptionCode.requestTimeOut.code);

  @override
  String get message => "Request Timeout";

  @override
  Object? stackTrace;

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? "",
      description: "Terjadi kesalahan pada proses $function $code",
      type: type,
    );
  }

  static ExceptionRule rule({
    required String module,
    required String layer,
    required String function,
    Object? stackTrace,
  }) => ExceptionRule(
    predicate: (exception) => exception is DioException 
      && (exception.type == DioExceptionType.receiveTimeout 
      || exception.type == DioExceptionType.sendTimeout),
    transformer:
      (exception) => RequestTimeOutException(
        module: module,
        layer: layer,
        function: function,
        stackTrace: stackTrace,
      ),
  );
}
