import 'package:get_it/get_it.dart';
import 'package:network/network.dart';

void provideNetworkModule() {
  GetIt.I.registerLazySingleton<DioService>(DioService.new);
}