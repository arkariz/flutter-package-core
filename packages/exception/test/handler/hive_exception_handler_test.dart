import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:exception/exception.dart';

void main() {
  const String module = 'TestModule';
  const String function = 'testFunction';

  group('openBox', () {
    test('should return the result when call succeeds', () async {
      // Arrange
      call() async => 'Success';

      // Act
      final result = await openBox(
        module: module,
        function: function,
        call: call,
      );

      // Assert
      expect(result, 'Success');
    });

    test('should throw LocalStorageAlreadyOpenedException when "already open" message', () async {
      // Arrange
      // This simulates a HiveError with "already open" message
      call() async => throw HiveError('Box "myBox" is already open');

      // Act & Assert
      expect(
        () => openBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageAlreadyOpenedException>()),
      );
    });

    test('should throw LocalStorageAlreadyOpenedException when "already opened" message', () async {
      // Arrange
      // This simulates a HiveError with "already opened" message
      call() async => throw HiveError('Box is already opened');

      // Act & Assert
      expect(
        () => openBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageAlreadyOpenedException>()),
      );
    });

    test('should throw LocalStorageAlreadyOpenedException when "duplicate box name" message', () async {
      // Arrange
      // This simulates a HiveError with "duplicate box name" message
      call() async => throw HiveError('Duplicate box name. The box is already open or has been initialized.');

      // Act & Assert
      expect(
        () => openBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageAlreadyOpenedException>()),
      );
    });

    test('should throw LocalStorageAlreadyOpenedException when "cannot open the same box" message', () async {
      // Arrange
      // This simulates a HiveError with "cannot open the same box" message
      call() async => throw HiveError('You cannot open the same box multiple times.');

      // Act & Assert
      expect(
        () => openBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageAlreadyOpenedException>()),
      );
    });

    test('should throw GeneralException for unhandled exceptions', () async {
      // Arrange
      call() async => throw Exception('Some other error');

      // Act & Assert
      expect(
        () => openBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<GeneralException>()),
      );
    });
  });

  group('processBox', () {
    test('should return the result when call succeeds', () async {
      // Arrange
      call() async => 'Success';

      // Act
      final result = await processBox(
        module: module,
        function: function,
        call: call,
      );

      // Assert
      expect(result, 'Success');
    });

    test('should throw LocalStorageCorruptionException when "checksum does not match" message', () async {
      // Arrange
      // This simulates a HiveError with checksum corruption message
      call() async => throw HiveError('Checksum of the box does not match');

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageCorruptionException>()),
      );
    });

    test('should throw LocalStorageCorruptionException when "unexpected end of file" message', () async {
      // Arrange
      // This simulates a HiveError with unexpected end of file message
      call() async => throw HiveError('Unexpected end of file');

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageCorruptionException>()),
      );
    });

    test('should throw LocalStorageCorruptionException when "unknown type id" message', () async {
      // Arrange
      // This simulates a HiveError with unknown type id message
      call() async => throw HiveError('Box contains unknown type id');

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageCorruptionException>()),
      );
    });

    test('should throw LocalStorageCorruptionException when "wrong encryption key" message', () async {
      // Arrange
      // This simulates a HiveError with wrong encryption key message
      call() async => throw HiveError('Corrupted or used with wrong encryption key');

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageCorruptionException>()),
      );
    });

    test('should throw LocalStorageClosedException when "box has already been closed" message', () async {
      // Arrange
      // This simulates a HiveError with "box has already been closed" message
      call() async => throw HiveError('Box has already been closed');

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageClosedException>()),
      );
    });

    test('should throw LocalStorageClosedException when "cannot get value of a closed box" message', () async {
      // Arrange
      // This simulates a HiveError with "cannot get value of a closed box" message
      call() async => throw HiveError('Cannot get value of a closed box');

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageClosedException>()),
      );
    });

    test('should throw LocalStorageClosedException when "cannot perform operation on a closed box" message', () async {
      // Arrange
      // This simulates a HiveError with "cannot perform operation on a closed box" message
      call() async => throw HiveError('Cannot perform operation on a closed box');

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageClosedException>()),
      );
    });

    test('should throw LocalStorageClosedException when "cannot read from a closed box" message', () async {
      // Arrange
      // This simulates a HiveError with "cannot read from a closed box" message
      call() async => throw HiveError('Cannot read from a closed box');

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<LocalStorageClosedException>()),
      );
    });

    test('should throw StorageFullException when appropriate', () async {
      // Arrange
      // This simulates a FileSystemException with "No space left" message
      call() async => throw FileSystemException(
        'write',
        '/path/to/file',
        OSError('No space left on device', 28),
      );

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<StorageFullException>()),
      );
    });

    test('should throw DecodeFailedException when appropriate', () async {
      // Arrange
      // This simulates a FormatException which is one of the acceptable exceptions
      call() async => throw FormatException('Invalid format');

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<DecodeFailedException>()),
      );
    });

    test('should throw GeneralException for unhandled exceptions', () async {
      // Arrange
      call() async => throw Exception('Some other error');

      // Act & Assert
      expect(
        () => processBox(
          module: module,
          function: function,
          call: call,
        ),
        throwsA(isA<GeneralException>()),
      );
    });
  });
}
