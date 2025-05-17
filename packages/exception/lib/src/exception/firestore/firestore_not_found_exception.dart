import 'package:exception/exception.dart';

/// Thrown when a requested document was not found
class FirestoreNotFoundException extends FirestoreException {
  FirestoreNotFoundException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'The requested document was not found',
          firesoteErrorCode: 'NOT_FOUND',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Not Found',
      description: message ?? 'The requested document does not exist',
      type: type,
    );
  }
}
