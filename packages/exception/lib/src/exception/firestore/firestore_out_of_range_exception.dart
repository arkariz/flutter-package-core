import 'package:exception/exception.dart';

/// Thrown when operation was attempted past the valid range
class FirestoreOutOfRangeException extends FirestoreException {
  FirestoreOutOfRangeException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'Operation was attempted past the valid range',
          firesoteErrorCode: 'OUT_OF_RANGE',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Out of Range',
      description: message ?? 'The operation was attempted outside the valid range',
      type: type,
    );
  }
}
