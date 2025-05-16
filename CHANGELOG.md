# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-05-16

### Changed
- Restructured security package documentation
  - Updated key management patterns
  - Improved examples in README
  - Fixed changelog format

## [1.0.0] - 2025-05-16

### Added
- Added security package
  - AES encryption with CBC mode
  - HMAC hashing with multiple algorithms
  - Secure key management
  - String extensions for encryption/decryption
  - Platform-specific key support
  - Documentation and examples

- Added storage package (#8aeaf67)
  - Implemented storage with preferences
  - Added database support using Hive
  - Set up encryption for sensitive data

- Added example app (#c23a656, #3a36e1b, #e9206de)
  - Implemented base example framework
  - Added example menu navigation
  - Added storage example implementation
  - Updated example app documentation
  - Updated ndkVersion for Android compatibility (#85f9908)

- Added comprehensive documentation
  - Updated README.md
  - Added inline comments in code
  - Documented example structure and usage

### Changed
- Fixed lint warnings (#8dd51b1)
  - Resolved all lint warnings
  - Improved code style
  - Updated formatting

- Locked dependencies (#b331103)
  - Locked all package dependencies
  - Ensured consistent dependency versions

- Updated gitignore (#c2074fb)
  - Added Windows generated files
  - Ignored build artifacts and IDE files

### Fixed
- Fixed auth header assignment (#78d782c)
  - Fixed wrong assignment in requiredAuthApikey
  - Ensured proper API key handling

- Initial setup issues and linting problems

## [0.0.1] - 2025-05-16

### Added
- Initial release of Flutter Package Core monorepo (#b4e9408)
  - Set up monorepo structure
  - Added root pubspec
  - Configured melos for package management
  - Basic project structure
  - Initial README.md

[Unreleased]: https://github.com/arkariz/flutter-package-core/compare/1.0.1...HEAD
[1.0.1]: https://github.com/arkariz/flutter-package-core/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/arkariz/flutter-package-core/compare/0.0.1...1.0.0
[0.0.1]: https://github.com/arkariz/flutter-package-core/releases/tag/0.0.1
