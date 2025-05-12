import 'package:dio/dio.dart';
class DioBuilder {
  final Dio _client;

  DioBuilder(String baseUrl) : _client = Dio(BaseOptions(baseUrl: baseUrl));

  DioBuilder setTimeouts({Duration? connectTimeout, Duration? receiveTimeout}) {
    _client.options.connectTimeout = connectTimeout;
    _client.options.receiveTimeout = receiveTimeout;
    return this;
  }

  DioBuilder addHeader(String key, String? value) {
    if (value != null) {
      _client.options.headers[key] = value;
    }
    return this;
  }

  DioBuilder addHeaders(Map<String, dynamic> headers) {
    _client.options.headers.addAll(headers);
    return this;
  }

  DioBuilder addInterceptor(Interceptor interceptor) {
    _client.interceptors.add(interceptor);
    return this;
  }

  DioBuilder timeOut({Duration? connectTimeout, Duration? receiveTimeout}) {
    _client.options.connectTimeout = connectTimeout;
    _client.options.receiveTimeout = receiveTimeout;
    return this;
  }

  Dio build() => _client;
}
