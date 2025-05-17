import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exception/exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String module = 'TestModule';
  const String function = 'testFunction';

  group('processFirestoreCall', () {
    test('should return the result when call succeeds', () async {
      // Arrange
      call() async => 'Success';

      // Act
      final result = await processFirestoreCall(
        module: module,
        function: function,
        call: call,
      );

      // Assert
      expect(result, 'Success');
    });

    test('should throw NoInternetConnectionException when SocketException', () async {
      // Arrange
      call() async => throw SocketException('Failed to connect');

      // Act & Assert
      expect(
        () => processFirestoreCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<NoInternetConnectionException>()),
      );
    });

    test('should throw DecodeFailedException when FormatException', () async {
      // Arrange
      call() async => throw FormatException('Invalid format');

      // Act & Assert
      expect(
        () => processFirestoreCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<DecodeFailedException>()),
      );
    });

    group('Firestore specific exceptions', () {
      test('should throw FirestoreAbortedException for aborted error', () async {
        await _testFirestoreException(
          'aborted',
          isA<FirestoreAbortedException>(),
        );
      });

      test('should throw FirestoreAlreadyExistsException for already-exists error', () async {
        await _testFirestoreException(
          'already-exists',
          isA<FirestoreAlreadyExistsException>(),
        );
      });

      test('should throw FirestoreCancelledException for cancelled error', () async {
        await _testFirestoreException(
          'cancelled',
          isA<FirestoreCancelledException>(),
        );
      });

      test('should throw FirestoreDataLossException for data-loss error', () async {
        await _testFirestoreException(
          'data-loss',
          isA<FirestoreDataLossException>(),
        );
      });

      test('should throw FirestoreDeadlineExceededException for deadline-exceeded error', () async {
        await _testFirestoreException(
          'deadline-exceeded',
          isA<FirestoreDeadlineExceededException>(),
        );
      });

      test('should throw FirestoreFailedPreconditionException for failed-precondition error', () async {
        await _testFirestoreException(
          'failed-precondition',
          isA<FirestoreFailedPreconditionException>(),
        );
      });

      test('should throw FirestoreInternalException for internal error', () async {
        await _testFirestoreException(
          'internal',
          isA<FirestoreInternalException>(),
        );
      });

      test('should throw FirestoreInvalidArgumentException for invalid-argument error', () async {
        await _testFirestoreException(
          'invalid-argument',
          isA<FirestoreInvalidArgumentException>(),
        );
      });

      test('should throw FirestoreNotFoundException for not-found error', () async {
        await _testFirestoreException(
          'not-found',
          isA<FirestoreNotFoundException>(),
        );
      });

      test('should throw FirestoreOutOfRangeException for out-of-range error', () async {
        await _testFirestoreException(
          'out-of-range',
          isA<FirestoreOutOfRangeException>(),
        );
      });

      test('should throw FirestorePermissionDeniedException for permission-denied error', () async {
        await _testFirestoreException(
          'permission-denied',
          isA<FirestorePermissionDeniedException>(),
        );
      });

      test('should throw FirestoreResourceExhaustedException for resource-exhausted error', () async {
        await _testFirestoreException(
          'resource-exhausted',
          isA<FirestoreResourceExhaustedException>(),
        );
      });

      test('should throw FirestoreUnauthenticatedException for unauthenticated error', () async {
        await _testFirestoreException(
          'unauthenticated',
          isA<FirestoreUnauthenticatedException>(),
        );
      });

      test('should throw FirestoreUnavailableException for unavailable error', () async {
        await _testFirestoreException(
          'unavailable',
          isA<FirestoreUnavailableException>(),
        );
      });

      test('should throw FirestoreUnimplementedException for unimplemented error', () async {
        await _testFirestoreException(
          'unimplemented',
          isA<FirestoreUnimplementedException>(),
        );
      });

      test('should throw FirestoreUnknownException for unknown error codes', () async {
        await _testFirestoreException(
          'unknown-error-code',
          isA<FirestoreUnknownException>(),
        );
      });
    });

    test('should throw GeneralException for any other exception', () async {
      // Arrange
      call() async => throw Exception('Some unexpected error');

      // Act & Assert
      expect(
        () => processFirestoreCall(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<GeneralException>()),
      );
    });
  });
}

Future<void> _testFirestoreException(
  String errorCode,
  Matcher matcher,
) async {
  // Arrange
  call() async => throw FirebaseException(
    plugin: 'cloud_firestore',
    code: errorCode,
    message: 'Firestore error: $errorCode',
  );

  // Act & Assert
  expect(
    () => processFirestoreCall(
      module: "test module",
      function: "test function",
      call: call,
    ),
    throwsA(matcher),
  );
}
