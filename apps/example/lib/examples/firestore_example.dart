// ignore_for_file: use_build_context_synchronously

import 'package:example/base_example/example_base.dart';
import 'package:exception/exception.dart';
import 'package:firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // For now, we'll use the same configuration for all platforms
    // You can add platform-specific configurations if needed
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBZX4pJisw4DxIqNFSyQzrX6Cwd3WBED6Q',
    appId: '1:456375300896:web:120ac067e762c6429b5d45',
    messagingSenderId: '456375300896',
    projectId: 'arkariz-flutter-example-app',
    authDomain: 'arkariz-flutter-example-app.firebaseapp.com',
    storageBucket: 'arkariz-flutter-example-app.firebasestorage.app',
  );
}

// Initialize Firebase
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class FirestoreExample extends ExampleBase {
  const FirestoreExample({super.key});

  @override
  String get title => 'FirestoreService Example';

  @override
  String get description => 'Demonstrates all FirestoreService methods.';

  @override
  IconData get icon => Icons.api;

  @override
  Widget buildExample(BuildContext context) {
    return FutureBuilder(
      future: initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const FirestoreServiceExampleScreen();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class FirestoreServiceExampleScreen extends StatefulWidget {
  const FirestoreServiceExampleScreen({super.key});
  @override
  State<FirestoreServiceExampleScreen> createState() => _FirestoreServiceExampleScreenState();
}

class _FirestoreServiceExampleScreenState extends State<FirestoreServiceExampleScreen> {
  // Controllers for input fields
  final TextEditingController _fooController = TextEditingController();
  final TextEditingController _updateController = TextEditingController();
  final FirestoreService _firestore = FirestoreModule.firestoreService();
  String _status = '';
  List<Map<String, dynamic>> _docs = [];
  Stream<List<Map<String, dynamic>>>? _realtimeStream;
  String? lastCreatedId;
  final String collection = 'examples';

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _fooController.dispose();
    _updateController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _status = 'Loading...');
    final docs = await _firestore.query<Map<String, dynamic>>(collection: collection);
    setState(() {
      _docs = docs;
      _status = 'Loaded ${docs.length} docs';
    });
  }

  Future<void> _create() async {
    final fooValue = _fooController.text.trim();
    if (fooValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a value for foo')),
      );
      return;
    }
    setState(() => _status = 'Creating...');
    final id = await _firestore.create(
      id: fooValue,
      collection: collection,
      data: {'foo': fooValue, 'createdAt': DateTime.now().toIso8601String()},
    );
    setState(() {
      lastCreatedId = id;
      _status = 'Created doc $id';
    });
    _fooController.clear();
    await _loadAll();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Created document: $id')),
    );
  }

  Future<void> _read() async {
    if (lastCreatedId == null) return;
    setState(() => _status = 'Reading...');
    final doc = await _firestore.read(
      path: '$collection/$lastCreatedId',
    );
    setState(() => _status = 'Read: ${doc?['foo']}');
  }

  Future<void> _update() async {
    if (lastCreatedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No document to update.')),
      );
      return;
    }
    final updateValue = _updateController.text.trim();
    if (updateValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a value to update.')),
      );
      return;
    }
    setState(() => _status = 'Updating...');
    await _firestore.update(
      path: '$collection/$lastCreatedId',
      data: {'foo': updateValue, 'updatedAt': DateTime.now().toIso8601String()},
    );
    setState(() => _status = 'Updated');
    _updateController.clear();
    await _loadAll();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updated document: $lastCreatedId')),
    );
  }

  Future<void> _delete() async {
    if (lastCreatedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No document to delete.')),
      );
      return;
    }
    setState(() => _status = 'Deleting...');
    await _firestore.delete(path: '$collection/$lastCreatedId');
    setState(() {
      _status = 'Deleted $lastCreatedId';
      lastCreatedId = null;
    });
    await _loadAll();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deleted document.')),
    );
  }

  Future<void> _queryFiltered() async {
    setState(() => _status = 'Querying...');
    try {
      final docs = await _firestore.query<Map<String, dynamic>>(
        collection: collection,
        options: QueryOptions(
          whereConditions: [WhereCondition(field: 'foo', operator: WhereOperator.isEqualTo, value: 'updated')],
          orderBy: [OrderByOption('createdAt', descending: true)],
          limit: 5,
        ),
      );

      setState(() {
        _docs = docs;
        _status = 'Filtered query: ${docs.length} found';
      });
    } on FirestoreException catch (e) {
      setState(() {
        _status = 'Error: ${e.code}';
      });
    }
  }

  Future<void> _queryPaginated() async {
    setState(() => _status = 'Paginated query...');
    final page = await _firestore.queryPaginated(
      collection: collection,
      pageSize: 2,
    );
    setState(() {
      _docs = page.items;
      _status = 'Page: ${page.items.length} docs, hasMore: ${page.hasMore}';
    });
  }

  Future<void> _batchWrite() async {
    setState(() => _status = 'Batch writing...');
    final ops = [
      WriteOperation.create(
        path: '$collection/batch1',
        data: {'foo': 'batch1', 'createdAt': DateTime.now().toIso8601String()},
      ),
      WriteOperation.create(
        path: '$collection/batch2',
        data: {'foo': 'batch2', 'createdAt': DateTime.now().toIso8601String()},
      ),
      WriteOperation.delete('$collection/batch2'),
      WriteOperation.update(
        path: '$collection/batch1',
        data: {'foo': 'updated', 'updatedAt': DateTime.now().toIso8601String()},
      ),
      WriteOperation.create(
        path: '$collection/batch3',
        data: {'foo': 'batch3', 'createdAt': DateTime.now().toIso8601String()},
      ),
    ];
    await _firestore.batchWrite(operations: ops);
    setState(() => _status = 'Batch write complete');
    await _loadAll();
  }

  Future<void> _runTransaction() async {
    setState(() => _status = 'Running transaction...');
    await _firestore.runTransaction(
      (transaction) async {
        try {
          await _firestore.query<Map<String, dynamic>>(collection: collection);
          await _queryFiltered();
        } catch (e) {
          setState(() => _status = 'Error: $e');
        }
      },
    );
    setState(() => _status = 'Transaction complete');
    await _loadAll();
  }

  void _watchDocument() {
    if (lastCreatedId == null) return;
    final stream = _firestore.watchDocument<Map<String, dynamic>>(
      path: '$collection/$lastCreatedId',
    );
    stream.listen((doc) {
      setState(() => _status = 'Doc stream: ${doc?['foo']}');
    });
  }

  void _watchCollection() {
    final stream = _firestore.watchCollection<Map<String, dynamic>>(
      collection: collection,
      options: QueryOptions(limit: 10),
    );
    setState(() {
      _realtimeStream = stream;
      _status = 'Watching collection...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FirestoreService Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Status
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(_status, style: const TextStyle(fontSize: 16)),
            ),
            // Create Section
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Create Document', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _fooController,
                            decoration: const InputDecoration(labelText: 'foo value'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: _create, child: const Text('Create')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Read/Update/Delete Section
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Read / Update / Delete', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        ElevatedButton(onPressed: _read, child: const Text('Read')),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _updateController,
                            decoration: const InputDecoration(labelText: 'new foo value'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: _update, child: const Text('Update')),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: _delete, child: const Text('Delete')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Query Section
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Queries', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        ElevatedButton(onPressed: _queryFiltered, child: const Text('Query Filtered')),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: _queryPaginated, child: const Text('Paginated')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Batch/Transaction Section
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Batch & Transaction', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        ElevatedButton(onPressed: _batchWrite, child: const Text('Batch')),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: _runTransaction, child: const Text('Transaction')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Real-time Section
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Real-time', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        ElevatedButton(onPressed: _watchDocument, child: const Text('Watch Doc')),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: _watchCollection, child: const Text('Watch Collection')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Data display
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _realtimeStream != null
                  ? StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _realtimeStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Text('Waiting for updates...');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Realtime Collection:'),
                            ...snapshot.data!.map((doc) => Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(doc.toString()),
                                  ),
                                )),
                          ],
                        );
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Documents:'),
                        ..._docs.map((doc) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(doc.toString()),
                              ),
                            )),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
