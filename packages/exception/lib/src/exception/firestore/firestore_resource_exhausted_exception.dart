import 'package:exception/exception.dart';

/// Thrown when some resource has been exhausted
class FirestoreResourceExhaustedException extends FirestoreException {
  FirestoreResourceExhaustedException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'Some resource has been exhausted',
          firesoteErrorCode: 'RESOURCE_EXHAUSTED',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Resource Exhausted',
      description: message ?? 'A resource has been exhausted',
      type: type,
    );
  }
}
