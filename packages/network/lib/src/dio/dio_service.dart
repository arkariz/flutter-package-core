import 'package:dio/dio.dart';
import 'package:network/network.dart';
import 'package:network/src/flavor/network_flavor.dart';
import 'package:network/src/interceptors/auth_header_interceptor.dart';
import 'package:network/src/interceptors/expired_token_interceptor.dart';
import 'package:network/src/interceptors/logging_inteceptor.dart';

class DioService {
  DioService();

  Dio createApiGee(NetworkFlavor flavor) {
    return DioBuilder(flavor.baseUrl)
        .timeOut(
          connectTimeout: flavor.connectTimeout,
          receiveTimeout: flavor.receiveTimeout,
        )
        .addHeaders(AuthHeader.requiredApikey)
        .addInterceptor(ExpiredTokenInterceptor(InstanceName.apiGee))
        .addInterceptor(AuthHeaderInterceptor(InstanceName.apiGee))
        .addInterceptor(LoggingInterceptor())
        .build();
  }
}

