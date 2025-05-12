import 'package:get_it/get_it.dart';
import 'package:security/src/di/qualifier/aes_qualifier.dart';

class AesKey {
  static String platform = GetIt.I.get<String>(instanceName: AesQualifier.platform.name);
}