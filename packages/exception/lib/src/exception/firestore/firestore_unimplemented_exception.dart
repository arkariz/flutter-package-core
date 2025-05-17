import 'package:exception/exception.dart';

/// Thrown when operation is not implemented or not supported
class FirestoreUnimplementedException extends FirestoreException {
  FirestoreUnimplementedException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'Operation is not implemented or not supported',
          firesoteErrorCode: 'UNIMPLEMENTED',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Not Implemented',
      description: message ?? 'This operation is not implemented or supported',
      type: type,
    );
  }
}
