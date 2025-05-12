import 'package:exception/exception.dart';
import 'package:exception/src/exception/core_exception.dart';
import 'package:exception/src/handler/exception_handler.dart';

Future<T> processResult<T>({
  required String module,
  required String function,
  ExceptionLayerCode layer = ExceptionLayerCode.useCase,
  required Call<T> call,
}) async {
  try {
    return await call();
  } on CoreException {
    rethrow;
  } catch (e, stackTrace) {
    throw GeneralException(
      module: module,
      layer: layer.code,
      function: function,
      stackTrace: stackTrace,
    );
  }
}