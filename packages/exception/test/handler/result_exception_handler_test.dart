import 'package:flutter_test/flutter_test.dart';
import 'package:exception/exception.dart';

void main() {
  const String module = 'TestModule';
  const String function = 'testFunction';
  const ExceptionLayerCode layer = ExceptionLayerCode.useCase;

  group('processResult', () {
    test('should return the result when call succeeds', () async {
      // Arrange
      call() async => 'Success';
      
      // Act
      final result = await processResult(
        module: module,
        function: function,
        call: call,
      );
      
      // Assert
      expect(result, 'Success');
    });

    test('should rethrow CoreException instances', () async {
      // Arrange
      final coreException = NoInternetConnectionException(
        module: module,
        layer: layer.code,
        function: function,
      );
      call() async => throw coreException;
      
      // Act & Assert
      expect(
        () => processResult(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(same(coreException)), // Use same() to check it's the exact same instance
      );
    });

    test('should wrap non-CoreException errors in GeneralException', () async {
      // Arrange
      final error = Exception('Test error');
      call() async => throw error;
      
      // Act & Assert
      expect(
        () => processResult(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<GeneralException>()),
      );
    });

    test('should use provided layer in GeneralException', () async {
      // Arrange
      final error = Exception('Test error');
      call() async => throw error;
      const customLayer = ExceptionLayerCode.repository;
      
      // Act
      try {
        await processResult(
          module: module,
          function: function,
          layer: customLayer,
          call: call,
        );
      } catch (e) {
        // Assert
        expect(e, isA<GeneralException>());
        final generalException = e as GeneralException;
        expect(generalException.layer, equals(customLayer.code));
      }
    });
  });
}