import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore/src/core/firestore_service.dart';
import 'package:get_it/get_it.dart';

/// A dependency injection module for setting up and accessing Firestore services.
/// 
/// This class provides static methods to configure and access Firestore instances
/// using the GetIt service locator. It simplifies the setup of Firestore services
/// throughout your application.
///
/// ## Usage
/// 
/// ### Basic Setup
/// ```dart
/// // In your app's initialization (e.g., main.dart)
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///   
///   // Configure Firestore module
///   FirestoreModule.configure();
///   
///   runApp(MyApp());
/// }
/// ```
///
/// ### Using a Custom Firestore Instance
/// ```dart
/// // For testing or custom configurations
/// final customFirestore = FirebaseFirestore.instance;
/// FirestoreModule.configure(firestore: customFirestore);
/// ```
///
/// ### Accessing Services
/// ```dart
/// // Get FirestoreService instance
/// final firestoreService = FirestoreModule.firestoreService();
/// 
/// // Get raw FirebaseFirestore instance
/// final firebaseFirestore = FirestoreModule.firebaseFirestore();
/// ```
class FirestoreModule {
  static final GetIt _getIt = GetIt.instance;
  
  /// Configures the Firestore module with optional custom instances.
  /// 
  /// This method should be called during app initialization to set up the
  /// required Firestore services. It registers both the [FirebaseFirestore]
  /// instance and the [FirestoreService] as lazy singletons.
  ///
  /// - [firestore]: An optional custom [FirebaseFirestore] instance. If not provided,
  ///   the default instance will be used.
  ///
  /// ### Example
  /// ```dart
  /// // Basic configuration
  /// FirestoreModule.configure();
  /// 
  /// // With custom Firestore instance
  /// final customFirestore = FirebaseFirestore.instance;
  /// FirestoreModule.configure(firestore: customFirestore);
  /// ```
  static void configure({FirebaseFirestore? firestore}) {
    // Register Firestore instance
    _getIt.registerLazySingleton<FirebaseFirestore>(
      () => firestore ?? FirebaseFirestore.instance,
    );

    // Register FirestoreService
    _getIt.registerLazySingleton<FirestoreService>(
      () => FirestoreService(firestore: _getIt<FirebaseFirestore>()),
    );
  }

  /// Returns the registered [FirestoreService] instance.
  /// 
  /// This method provides access to the application's [FirestoreService]
  /// singleton instance that was configured via [configure()].
  ///
  /// ### Example
  /// ```dart
  /// // Get the FirestoreService instance
  /// final firestoreService = FirestoreModule.firestoreService();
  /// 
  /// // Use the service
  /// final user = await firestoreService.read(path: 'users/user123');
  /// ```
  ///
  /// ### Throws
  /// - [StateError] if [configure()] hasn't been called first.
  static FirestoreService firestoreService() {
    try {
      return _getIt<FirestoreService>();
    } catch (e) {
      throw StateError(
        'FirestoreModule has not been initialized. Call FirestoreModule.configure() first.',
      );
    }
  }

  /// Returns the registered [FirebaseFirestore] instance.
  /// 
  /// This method provides direct access to the underlying [FirebaseFirestore]
  /// instance for advanced use cases where the raw Firestore API is needed.
  ///
  /// ### Example
  /// ```dart
  /// // Get the raw FirebaseFirestore instance
  /// final firestore = FirestoreModule.firebaseFirestore();
  /// 
  /// // Use raw Firestore API
  /// final doc = await firestore.collection('users').doc('123').get();
  /// ```
  ///
  /// ### Throws
  /// - [StateError] if [configure()] hasn't been called first.
  static FirebaseFirestore firebaseFirestore() {
    try {
      return _getIt<FirebaseFirestore>();
    } catch (e) {
      throw StateError(
        'FirestoreModule has not been initialized. Call FirestoreModule.configure() first.',
      );
    }
  }
}