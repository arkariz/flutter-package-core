# Networking

The networking module provides a Dio-based HTTP client with built-in interceptors:

## Configuration
In the network module, there are two main components: the DioService and the DioBuilder.
```dart
  // Create a Dio instance with certain configuration
  Dio createApiGee(NetworkFlavor flavor) {
    return DioBuilder(flavor.baseUrl)
        .timeOut(
          connectTimeout: flavor.connectTimeout,
          receiveTimeout: flavor.receiveTimeout,
        )
        .build();
  }
```

Provide the DioService in the GetIt container at network_module.dart.
By calling the provideNetworkModule() function, the DioService will be registered as a singleton in the GetIt container and will be available for injection in other parts of the application. e.g. Data Layer, Repository, etc.
```dart
  void provideNetworkModule() {
    GetIt.I.registerLazySingleton<DioService>(DioService.new);
  }
```

## Usage
In data layer, inject the DioService and use it to make HTTP requests.
```dart
void provideDataMdmInfoModule() {
  GetIt.I.registerLazySingleton<DataSource>(
    () => DataSource(
      GetIt.I<DioService>()
        .createApiGee(
          GetIt.I<NetworkFlavor>(instanceName: InstanceName.apiGee.name),
        ),
    )
  );
}

class DataSource {
  final DioService _dioService;

  DataSource(this._dioService);

  Future<void> fetchData() async {
    final response = await _dioService.get('/endpoint');
    // Process response
  }
}
```

In Application, inject the NetwotkFlavor, DioService, DataSource and use it to make HTTP requests.
```dart
  void main() async {
    // Provide network flavor
    GetIt.I.registerSingleton<NetworkFlavor>(ApigeeNetwork(), instanceName: InstanceName.apiGee.name);

    // Provide network module
    provideNetworkModule();

    // Provide data module
    provideDataMdmInfoModule();

    runApp(MyApp());
  }
```

## Auhtorization
Create a Dio instance with AuthHeaderInterceptor for providing apikey and authorization header based on the network flavor & ExpiredTokenInterceptor for handling expired token
```dart
  Dio createApiGee(NetworkFlavor flavor) {
    return DioBuilder(flavor.baseUrl)
      .timeOut(
        connectTimeout: flavor.connectTimeout,
        receiveTimeout: flavor.receiveTimeout,
      )
      .addInterceptor(ExpiredTokenInterceptor(InstanceName.apiGee))
      .addInterceptor(AuthHeaderInterceptor(InstanceName.apiGee))
      .build();
  }
```

In data layer, mark endpoint with @Headers annotation and provide the required auth header.
```dart
@Headers(AuthHeader.requiredApikey)
@GET("/endpoint")
Future<Response> getEndpoint();

@Headers(AuthHeader.requiredAuthorization)
@GET("/endpoint2")
Future<Response> getEndpoint2();

@Headers(AuthHeader.requiredAuthApikey)
@GET("/endpoint3")
Future<Response> getEndpoint3();
```

Implement the NetworkFlavor class
```dart
  class ApigeeNetwork extends NetworkFlavor {
    @override
    String? accessToken = "";

    /// Api key for authentication
    @override
    String get key => "apikey";

    /// Method to be called when token is expired
    @override
    Future<void> onTokenExpired() async {
      /// Implement logic to handle token expiration
    }

    /// Method to be called tok set access token
    @override
    void setAccessToken(String token) {
      accessToken = token;
    }

    /// other configurations
  }
```

In Application, inject the NetwotkFlavor, DioService, DataSource and use it to make HTTP requests.
```dart
  void main() async {
    // Provide network flavor
    GetIt.I.registerSingleton<NetworkFlavor>(ApigeeNetwork(), instanceName: InstanceName.apiGee.name);

    // Provide network module
    provideNetworkModule();

    // Provide data module
    provideDataMdmInfoModule();

    runApp(MyApp());
  }


  void doLogin() {
    final flavor = GetIt.I.get<NetworkFlavor>(instanceName: _instanceName.name);
    flavor.setAccessToken("access_token");
  }
```
