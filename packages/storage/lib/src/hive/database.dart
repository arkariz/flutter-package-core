import 'package:hive_ce/hive.dart';
import 'package:storage/src/hive/helper/type_def.dart';

class Database<T> {
  late final Box<T> box;

  Database(this.box);

  static Future<Database<T>> init<T>({
    required String name,
    required OpenDatabase<T> openDatabase,
    TypeAdapter<T>? adapter,
    HiveAesCipher? encryptionCipher,
  }) => openDatabase(
    module: "STORAGE",
    function: "OPEN_DATABASE",
    call: () async {
      if (adapter != null && !Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }

      final box = await Hive.openBox<T>(
        name,
        encryptionCipher: encryptionCipher,
      );
      return Database(box);
    },
  );
}
