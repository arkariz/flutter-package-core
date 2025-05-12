import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:network/network.dart';
import 'package:network/src/flavor/network_flavor.dart';

// Interceptor that handles expired tokens and calls the onTokenExpired method of the network flavor.
class ExpiredTokenInterceptor extends Interceptor {
  // Instance name for the network flavor.
  final InstanceName _instanceName;
  ExpiredTokenInterceptor(InstanceName instanceName) : _instanceName = instanceName;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: adjust conditional expression based on actual API response & code
    if (err.response?.statusCode == 401) {
      //  Get the network flavor from the GetIt container
      GetIt.I.get<NetworkFlavor>(instanceName: _instanceName.name).onTokenExpired();
    }

    // Continue with the request
    super.onError(err, handler);
  }
}
