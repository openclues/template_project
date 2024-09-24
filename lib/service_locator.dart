import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'core/services/dio_service_impl.dart';
import 'core/services/http_service.dart';
import 'core/services/local_storage.dart';
import 'core/services/push_notifications_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services registration
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<HttpService>(() => DioServiceImpl(dio: sl()));
  sl.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesService.fromLocator());
  sl.registerLazySingleton<PushNotificationsService>(
      () => PushNotificationsService());
}
