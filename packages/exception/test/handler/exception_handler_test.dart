import 'package:exception/exception.dart';
import 'package:exception/src/handler/exception_handler.dart';
import 'package:exception/src/model/exception_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String module = 'TestModule';
  const ExceptionLayerCode layer = ExceptionLayerCode.repository;
  const String function = 'testFunction';

  group('process', () {
    test('should return the result when call succeeds', () async {
      // Arrange
      successCall() async => 'Success';

      // Act
      final result = await process(
        module: module,
        layer: layer,
        function: function,
        rules: [],
        call: successCall,
      );

      // Assert
      expect(result, 'Success');
    });

    test('should throw GeneralException when no matching rule is found', () async {
      // Arrange
      failureCall() async => throw Exception('Test error');

      // Act & Assert
      expect(
        () => process(
          module: module,
          layer: layer,
          function: function,
          rules: [],
          call: failureCall,
        ),
        throwsA(isA<GeneralException>()),
      );
    });

    test('should apply matching rule when exception matches predicate', () async {
      // Arrange
      final testException = Exception('Test error');
      failureCall() async => throw testException;

      final mockRule = ExceptionRule(
        predicate: (e) => e is Exception,
        transformer: (e) => NoInternetConnectionException(
          module: module,
          layer: layer.code,
          function: function,
        ),
      );

      // Act & Assert
      expect(
        () => process(
          module: module,
          layer: layer,
          function: function,
          rules: [mockRule],
          call: failureCall,
        ),
        throwsA(isA<NoInternetConnectionException>()),
      );
    });

    test('should apply appropriate rule based on predicate match', () async {
      // Arrange
      final testExceptionFirst = Exception('Test error');
      failureCallFirst() async => throw testExceptionFirst;

      final testExceptionSecond = Exception('Different error');
      failureCallSecond() async => throw testExceptionSecond;

      final firstRule = ExceptionRule(
        predicate: (e) => e is Exception && e.toString().contains('Test error'),
        transformer: (e) => NoInternetConnectionException(
          module: module,
          layer: layer.code,
          function: function,
        ),
      );

      final secondRule = ExceptionRule(
        predicate: (e) => e is Exception && e.toString().contains('Different error'),
        transformer: (e) => RequestTimeOutException(
          module: module,
          layer: layer.code,
          function: function,
        ),
      );

      // Act & Assert - First call should match first rule
      expect(
        () => process(
          module: module,
          layer: layer,
          function: function,
          rules: [firstRule, secondRule],
          call: failureCallFirst,
        ),
        throwsA(isA<NoInternetConnectionException>()),
      );

      // Act & Assert - Second call should match second rule
      expect(
        () => process(
          module: module,
          layer: layer,
          function: function,
          rules: [firstRule, secondRule],
          call: failureCallSecond,
        ),
        throwsA(isA<RequestTimeOutException>()),
      );
    });
  });
}
