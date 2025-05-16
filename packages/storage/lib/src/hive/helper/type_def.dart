import 'package:storage/src/hive/database.dart';
import 'package:storage/src/hive/preference.dart';

typedef OpenDatabase<T> = Future<Database<T>> Function({
  required String module,
  required String function,
  required Future<Database<T>> Function() call,
});

typedef OpenPreference = Future<Preference> Function({
  required String module,
  required String function,
  required Future<Preference> Function() call,
});