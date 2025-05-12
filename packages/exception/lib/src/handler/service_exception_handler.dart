import 'package:exception/exception.dart';
import 'package:exception/src/handler/exception_handler.dart';
import 'package:exception/src/model/exception_rule.dart';

Future<T> processApiCall<T>({
  required String module,
  required String function,
  required Call<T> call,
}) {
  final layer = ExceptionLayerCode.repository;

  return process(
    module: module,
    layer: layer,
    function: function,
    rules: _rules(module: module, function: function, layer: layer),
    call: call,
  );
}

List<ExceptionRule> _rules({
  required String module,
  required String function,
  required ExceptionLayerCode layer,
}) => [
  NoInternetConnectionException.rule(
    module: module,
    layer: layer.code,
    function: function,
  ),
  RequestTimeOutException.rule(
    module: module,
    layer: layer.code,
    function: function,
  ),
  DecodeFailedException.rule(
    module: module,
    layer: layer.code,
    function: function,
  ),
  ApiErrorException.rule(module: module, layer: layer.code, function: function),
  UndefinedErrorResponseException.rule(
    module: module,
    layer: layer.code,
    function: function,
  ),
  GeneralException.rule(module: module, layer: layer.code, function: function),
];
