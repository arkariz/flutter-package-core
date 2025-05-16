import 'package:hive_ce/hive.dart';
import 'package:storage/src/hive/helper/type_def.dart';

class Preference {
  late final Box box;

  Preference(this.box);

  static Future<Preference> init({
    required String name,
    required OpenPreference openPreference,
    HiveAesCipher? encryptionCipher,
  }) => openPreference(
    module: "STORAGE",
    function: "OPEN_PREFERENCE",
    call: () async {
      final box = await Hive.openBox(name, encryptionCipher: encryptionCipher);
      return Preference(box);
    },
  );
}
