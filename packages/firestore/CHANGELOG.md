# Changelog

All notable changes to this package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-05-17

### Package Changes
- Refactored query, watchCollection, and queryPaginated to use a centralized private _buildQuery helper for maintainability and code deduplication.
- Updated README documentation to describe the new maintainability improvements.
- Updated pubspec.yaml to pin mocktail version for reproducible builds.

[Unreleased]: https://github.com/arkariz/flutter-package-core/compare/firestore%2F1.0.0...HEAD
[1.0.0]: https://github.com/arkariz/flutter-package-core/releases/tag/firestore%2F1.0.0

