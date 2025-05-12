import 'package:exception/exception.dart';
import 'package:exception/src/handler/exception_handler.dart';
import 'package:exception/src/model/exception_rule.dart';

Future<T> openBox<T>({
  required String module,
  required String function,
  required Call<T> call,
}) {
  final layer = ExceptionLayerCode.repository;

  return process(
    module: module,
    layer: layer,
    function: function,
    rules: _openRules(module: module, function: function, layer: layer),
    call: call,
  );
}

Future<T> processBox<T>({
  required String module,
  required String function,
  required Call<T> call,
}) {
  final layer = ExceptionLayerCode.repository;

  return process(
    module: module,
    layer: layer,
    function: function,
    rules: _operationRules(module: module, function: function, layer: layer),
    call: call,
  );
}

List<ExceptionRule> _openRules({
  required String module,
  required String function,
  required ExceptionLayerCode layer,
}) => [
  LocalStorageAlreadyOpenedException.rule(
    module: module,
    layer: layer.code,
    function: function,
  ),
];

List<ExceptionRule> _operationRules({
  required String module,
  required String function,
  required ExceptionLayerCode layer,
}) => [
  LocalStorageCorruptionException.rule(
    module: module,
    layer: layer.code,
    function: function,
  ),
  LocalStorageClosedException.rule(
    module: module,
    layer: layer.code,
    function: function,
  ),
  StorageFullException.rule(
    module: module,
    layer: layer.code,
    function: function,
  ),
  DecodeFailedException.rule(
    module: module,
    layer: layer.code,
    function: function,
  ),
  GeneralException.rule(module: module, layer: layer.code, function: function),
];
