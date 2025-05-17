import 'package:exception/exception.dart';

/// Thrown when attempting to create a document that already exists
class FirestoreAlreadyExistsException extends FirestoreException {
  FirestoreAlreadyExistsException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'A document with this ID already exists',
          firesoteErrorCode: 'ALREADY_EXISTS',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Document Exists',
      description: message ?? 'A document with this ID already exists',
      type: type,
    );
  }
}
