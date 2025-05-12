import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    message('--- [DIO REQUEST] ---');
    message('URI: ${options.uri}');
    message('METHOD: ${options.method}');
    message('HEADERS: ${jsonEncode(options.headers)}');
    if (options.data != null) {
      message('BODY: ${jsonEncode(options.data)}');
    }
    message('----------------------');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    message('--- [DIO RESPONSE] ---');
    message('URI: ${response.requestOptions.uri}');
    message('STATUS CODE: ${response.statusCode}');
    message('HEADERS: ${jsonEncode(response.headers.map)}');
    message('BODY: ${jsonEncode(response.data)}');
    message('----------------------');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    message('--- [DIO ERROR] ---');
    message('URI: ${err.requestOptions.uri}');
    message('MESSAGE: ${err.message}');
    if (err.response != null) {
      message('STATUS CODE: ${err.response?.statusCode}');
      message('BODY: ${jsonEncode(err.response?.data)}');
    }
    message('----------------------');
    handler.next(err);
  }

  void message(String message) {
    if (!kDebugMode) {
      return;
    }

    if (kDebugMode) {
      print(message);
    }
  }
}
