import 'package:exception/src/exception/core_exception.dart';

typedef ExceptionPredicate = bool Function(Object error);
typedef ExceptionTransformer = CoreException Function(Object error);

class ExceptionRule {
  final ExceptionPredicate predicate;
  final ExceptionTransformer transformer;

  ExceptionRule({required this.predicate, required this.transformer});
}