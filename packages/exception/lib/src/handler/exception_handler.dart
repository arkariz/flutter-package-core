import 'package:exception/exception.dart';
import 'package:exception/src/model/exception_rule.dart';

typedef Call<T> = Future<T> Function();

Future<T> process<T>({
  required String module,
  required ExceptionLayerCode layer,
  required String function,
  required List<ExceptionRule> rules,
  required Call<T> call,
}) async {
  try {
    return await call();
  } catch (e, stackTrace) {
    throw rules
        .firstWhere(
          (rule) => rule.predicate(e),
          orElse:
              () => GeneralException.rule(
                module: module,
                layer: layer.code,
                function: function,
                stackTrace: stackTrace,
              ),
        )
        .transformer(e);
  }
}
