import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:storage/storage.dart';
import 'package:exception/exception.dart';
import 'base_example/example_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await provideStorageModule(
    appPreferenceName: "app_preference",
    keySecureStorage: "key_secure_storage",
    openPreference: ({required call, required function, required module}) => openBox(module: module, function: function, call: call),
  );

  await GetIt.I.allReady();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Package Examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ExampleMenu(),
    );
  }
}
