import 'package:get_it/get_it.dart';
import 'package:security/src/di/qualifier/aes_qualifier.dart';

void securityModule({
  required String aesKeyPlatform
}) {
  GetIt.I.registerLazySingleton(
    () => aesKeyPlatform, instanceName: AesQualifier.platform.name
  );
}