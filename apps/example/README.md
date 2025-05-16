# Flutter Package Examples

This Flutter application showcases various package implementations in a modular and extensible way. Each package example demonstrates specific functionality and usage patterns.

## Project Structure

```
lib/
├── base_example/        # Base example structure
│   ├── example_base.dart  # Abstract base class for all examples
│   └── example_menu.dart  # Navigation menu for all examples
├── examples/           # Individual package examples
│   └── storage_example.dart  # Storage package example
└── main.dart          # Application entry point
```

## Features

- Modular example structure
- Easy addition of new examples
- Consistent example interface
- Clean separation of concerns

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Hive database
- Secure storage

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

### Running the App

```bash
flutter run
```

## Adding New Examples

To add a new example:

1. Create a new file in the `examples/` directory
2. Implement the `ExampleBase` interface:
   ```dart
   class YourExample extends StatelessWidget implements ExampleBase {
     const YourExample({super.key});
     
     @override
     String get title => 'Your Example Title';
     
     @override
     String get description => 'Description of your example';
     
     @override
     IconData get icon => Icons.your_icon;
     
     @override
     Widget buildExample(BuildContext context) {
       return YourExamplePage();
     }
   }
   ```
3. Add your example to the `examples` list in `base_example/example_menu.dart`

## Available Examples

- Storage Example: Demonstrates usage of the storage package with preferences and database

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details
