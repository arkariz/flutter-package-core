import 'package:exception/exception.dart';

/// Thrown when the service is currently unavailable
class FirestoreUnavailableException extends FirestoreException {
  FirestoreUnavailableException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'The service is currently unavailable',
          firesoteErrorCode: 'UNAVAILABLE',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Service Unavailable',
      description: message ?? 'The service is currently unavailable. Please try again later.',
      type: type,
    );
  }
}
