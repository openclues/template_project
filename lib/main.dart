import 'package:flutter/material.dart';
import 'core/common/constants/app_strings.dart';
import 'core/services/local_storage.dart';
// import 'core/services/push_notifications_service.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'service_locator.dart' as di;
import 'util/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.instance.init();
  await di.init();
  // await di.sl<PushNotificationsService>().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: generateRouter,
      title: AppStrings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
