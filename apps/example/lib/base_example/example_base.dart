import 'package:flutter/material.dart';

abstract class ExampleBase extends StatelessWidget {
  const ExampleBase({super.key});

  String get title;
  String get description;
  IconData get icon;
  
  @override
  Widget build(BuildContext context) {
    return buildExample(context);
  }
  
  Widget buildExample(BuildContext context);
}
