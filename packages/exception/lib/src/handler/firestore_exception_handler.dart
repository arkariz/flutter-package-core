import 'package:exception/exception.dart';
import 'package:exception/src/handler/exception_handler.dart';
import 'package:exception/src/model/exception_rule.dart';

/// Handles Firestore operations with proper exception handling
Future<T> processFirestoreCall<T>({
  required String module,
  required String function,
  required Future<T> Function() call,
}) async {
  final layer = ExceptionLayerCode.repository;

  return process(
    module: module,
    layer: layer,
    function: function,
    rules: _firestoreRules(
      module: module,
      function: function,
      layer: layer,
    ),
    call: call,
  );
}

/// Defines the exception handling rules for Firestore operations
List<ExceptionRule> _firestoreRules({
  required String module,
  required String function,
  required ExceptionLayerCode layer,
}) {
  return [
    // Firestore specific exceptions
    FirestoreException.rule(
      module: module,
      layer: layer.code,
      function: function,
      predicate: (e) => true, // This will be matched based on error code in the transformer
    ),
    
    // Network related exceptions
    NoInternetConnectionException.rule(
      module: module,
      layer: layer.code,
      function: function,
    ),

    DecodeFailedException.rule(
      module: module,
      layer: layer.code,
      function: function,
    ),
    
    // General exceptions as fallback
    GeneralException.rule(
      module: module,
      layer: layer.code,
      function: function,
    ),
  ];
}
