import 'package:exception/exception.dart';

class ExceptionInfo {
  final String title;
  final String description;
  final ExceptionDisplayType type;
  final String sourceAppName;

  ExceptionInfo({
    this.title = "",
    required this.description,
    required this.type,
    this.sourceAppName = "",
  });
}
