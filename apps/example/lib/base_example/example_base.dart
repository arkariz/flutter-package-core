import 'package:flutter/material.dart';

abstract class ExampleBase {
  String get title;
  String get description;
  IconData get icon;
  Widget buildExample(BuildContext context);
}
