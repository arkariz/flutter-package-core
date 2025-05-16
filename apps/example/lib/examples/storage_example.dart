import 'package:flutter/material.dart';
import 'package:storage/storage.dart';
import 'package:exception/exception.dart';
import 'package:hive_ce/hive.dart';
import '../base_example/example_base.dart';

// Model class for storing user data in Hive database
@HiveType(typeId: 1)
class User extends Entity<Map<String, dynamic>> {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;

  User({required this.id, required this.name});

  @override
  Map<String, dynamic> toModel() => {
    'id': id,
    'name': name,
  };
}

// Type adapter for serializing/deserializing User objects
// This is required for Hive to store User objects
// It converts User objects to/from binary format

class _UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    return User(id: id, name: name);
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
  }
}

// The main page widget that shows the storage example UI
// This is a stateful widget that manages the UI state

class StorageExamplePage extends StatefulWidget {
  const StorageExamplePage({super.key});

  @override
  State<StorageExamplePage> createState() => _StorageExamplePageState();
}

// State class that manages the storage example's state
// Handles saving/loading data and UI updates
class _StorageExamplePageState extends State<StorageExamplePage> {
  final _nameController = TextEditingController();
  String? _savedName;
  String? _databaseName;

  // Load name from preferences when widget initializes
  Future<void> _loadSavedName() async {
    final preference = await getPreference();
    setState(() {
      _savedName = preference.box.get('user_name');
    });
  }

  // Save name to preferences
  Future<void> _saveName(String name) async {
    final preference = await getPreference();
    await preference.box.put('user_name', name);
    setState(() {
      _savedName = name;
    });
  }

  // Save name to database
  Future<void> _saveToDatabase(String name) async {
    final database = await Database.init<User>(
      name: "users",
      openDatabase: ({required call, required function, required module}) => 
        openBox(module: module, function: function, call: call),
      adapter: _UserAdapter(),
      encryptionCipher: await getHiveAesCipher(),
    );

    // Create a new user with unique ID and save to database
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );

    await database.box.put(user.id, user);
    setState(() {
      _databaseName = name;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedName();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field for entering name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Button to save name to preferences
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                if (name.isNotEmpty) {
                  _saveName(name);
                }
              },
              child: const Text('Save to Preferences'),
            ),
            const SizedBox(height: 8),
            // Button to save name to database
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                if (name.isNotEmpty) {
                  _saveToDatabase(name);
                }
              },
              child: const Text('Save to Database'),
            ),
            const SizedBox(height: 16),
            // Display saved name from preferences
            if (_savedName != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Saved in Preferences: $_savedName',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            // Display saved name from database
            if (_databaseName != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Saved in Database: $_databaseName',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Implementation of ExampleBase that provides metadata about this example
class StorageExample extends StatelessWidget implements ExampleBase {
  const StorageExample({super.key});

  @override
  String get title => 'Storage Example';

  @override
  String get description => 'Demonstrates storage package usage with preferences and database';

  @override
  IconData get icon => Icons.storage;

  @override
  Widget buildExample(BuildContext context) {
    return const StorageExamplePage();
  }

  @override
  Widget build(BuildContext context) {
    return buildExample(context);
  }
}
