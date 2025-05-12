import 'dart:io';

import 'package:dio/dio.dart';
import 'package:exception/exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String module = 'TestModule';
  const String function = 'testFunction';

  group('processApiCall', () {
    test('should return the result when call succeeds', () async {
      // Arrange
      call() async => 'Success';

      // Act
      final result = await processApiCall(
        module: module,
        function: function,
        call: call,
      );

      // Assert
      expect(result, 'Success');
    });

    test('should throw NoInternetConnectionException when DioException with connectionError', () async {
      // Arrange
      // This simulates a network error
      call() async => throw DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/test'),
        error: 'Connection error',
      );

      // Act & Assert
      expect(
        () => processApiCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<NoInternetConnectionException>()),
      );
    });

    test('should throw NoInternetConnectionException when SocketException', () async {
      // Arrange
      // This simulates a socket error
      call() async => throw SocketException('Failed to connect');

      // Act & Assert
      expect(
        () => processApiCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<NoInternetConnectionException>()),
      );
    });

    test('should throw RequestTimeOutException when DioException with receiveTimeout', () async {
      // Arrange
      // This simulates a receive timeout error
      call() async => throw DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(path: '/test'),
        error: 'Receive timeout',
      );

      // Act & Assert
      expect(
        () => processApiCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<RequestTimeOutException>()),
      );
    });

    test('should throw RequestTimeOutException when DioException with sendTimeout', () async {
      // Arrange
      // This simulates a send timeout error
      call() async => throw DioException(
        type: DioExceptionType.sendTimeout,
        requestOptions: RequestOptions(path: '/test'),
        error: 'Send timeout',
      );

      // Act & Assert
      expect(
        () => processApiCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<RequestTimeOutException>()),
      );
    });

    test('should throw DecodeFailedException when FormatException', () async {
      // Arrange
      // This simulates a decode error with FormatException
      call() async => throw FormatException('Invalid JSON format');

      // Act & Assert
      expect(
        () => processApiCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<DecodeFailedException>()),
      );
    });

    test('should throw DecodeFailedException when TypeError', () async {
      // Arrange
      // This simulates a decode error with TypeError
      call() async => throw TypeError();

      // Act & Assert
      expect(
        () => processApiCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<DecodeFailedException>()),
      );
    });

    test('should throw DecodeFailedException when RangeError', () async {
      // Arrange
      // This simulates a decode error with RangeError
      call() async => throw RangeError('Index out of range');

      // Act & Assert
      expect(
        () => processApiCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<DecodeFailedException>()),
      );
    });

    test('should throw ApiErrorException when appropriate', () async {
      // Arrange
      // This simulates an API error with a response containing data
      call() async => throw DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: <String, dynamic>{
            'code': 'ERROR_CODE',
            'message': 'Error message',
          },
        ),
      );

      // Act & Assert
      expect(
        () => processApiCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<ApiErrorException>()),
      );
    });

    test('should throw UndefinedErrorResponseException when appropriate', () async {
      // Arrange
      // This simulates an undefined error with a response containing non-map data
      call() async => throw DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
          data: 'Plain text error response',
        ),
      );

      // Act & Assert
      expect(
        () => processApiCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<UndefinedErrorResponseException>()),
      );
    });

    test('should throw GeneralException for unhandled exceptions', () async {
      // Arrange
      call() async => throw Exception('Some other error');

      // Act & Assert
      expect(
        () => processApiCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<GeneralException>()),
      );
    });
  });
}
