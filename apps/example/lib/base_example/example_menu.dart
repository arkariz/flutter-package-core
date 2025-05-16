import 'package:flutter/material.dart';
import '../examples/storage_example.dart';
import 'example_base.dart';

class ExampleMenu extends StatelessWidget {
  const ExampleMenu({super.key});

  List<ExampleBase> get examples => [
    const StorageExample(),
    // Add more examples here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Package Examples'),
      ),
      body: ListView(
        children: examples.map((example) => 
          ListTile(
            leading: Icon(example.icon),
            title: Text(example.title),
            subtitle: Text(example.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => example.buildExample(context),
                ),
              );
            },
          )
        ).toList(),
      ),
    );
  }
}
