import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:storage/src/di/storage_qualifier.dart';
import 'package:storage/src/hive/preference.dart';
import 'package:storage/src/hive/helper/secure_storage.dart';
import 'package:storage/src/hive/helper/type_def.dart';

Future<void> provideStorageModule({
  required String appPreferenceName,
  required String keySecureStorage,
  required OpenPreference openPreference,
}) async {
  // setup hive local storage
  await Hive.initFlutter();

  // setup secure storage
  final secureStorage = SecureStorage(key: keySecureStorage);

  //inject secure storage for database
  GetIt.I.registerLazySingletonAsync<HiveAesCipher>(() async => await secureStorage.generateKey());

  // setup preference
  GetIt.I.registerLazySingletonAsync<Preference>(
    () async => await Preference.init(
      name: appPreferenceName,
      encryptionCipher: await getHiveAesCipher(),
      openPreference: openPreference,
    ),
    instanceName: StorageQualifier.appPreference.name,
  );
}

Future<Preference> getPreference() => GetIt.I.getAsync<Preference>(instanceName: StorageQualifier.appPreference.name);
Future<HiveAesCipher> getHiveAesCipher() => GetIt.I.getAsync<HiveAesCipher>();