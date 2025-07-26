import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/storage_service.dart';
import 'services/remote_config_service.dart';
import 'services/ads_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/notification_service.dart';
import 'services/background_service.dart';
import 'widgets/app_update_dialog.dart';
import 'bindings/app_bindings.dart';

import 'Screens/Auth/login_screen.dart';
import 'Screens/Auth/signup_screen.dart';
import 'Screens/Home/home_screen.dart';
import 'Screens/Splash/splash_screen.dart';
import 'Screens/Chapters/chapters_screen.dart';
import 'Screens/Sloks/sloks_screen.dart';
import 'Screens/SlokDetail/slok_detail_screen.dart';
import 'Screens/Settings/settings_controller.dart';
import 'firebase_options.dart';
import 'utils/app_theme.dart';
import 'widgets/maintenance_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize storage service
  await StorageService().init();

  // Initialize remote config service
  await RemoteConfigService().init();

  // Initialize JSON config controller with GetX

  // Initialize ads service
  await AdsService().init();

  // Initialize app bindings
  Get.put(AppBindings());
  
  // Initialize settings controller
  final settingsController = Get.put(SettingsController());
  await settingsController.loadSettings();

  runApp(const BhagavadGitaApp());

  // Initialize background service for persistent notifications
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final backgroundService = BackgroundService();
    await backgroundService.initialize();
    print('Background service initialized');

    final notificationService = NotificationService();
    await notificationService.initialize();
    print('Notification service initialized');
    await notificationService.requestPermissions();
    print('Notification permissions requested');
    await notificationService.scheduleDailyNotification();
    print('Daily notification scheduled');
  });
}



class BhagavadGitaApp extends StatelessWidget {
  const BhagavadGitaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaintenanceWidget(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bhagavad Gita',
        theme: AppTheme.theme,
        initialRoute: '/splash',
        getPages: [
          GetPage(
            name: '/splash', 
            page: () => const SplashScreen(),
            binding: SplashBinding(),
          ),
          GetPage(
            name: '/login', 
            page: () => const LoginScreen(),
            binding: LoginBinding(),
          ),
          GetPage(
            name: '/signup', 
            page: () => const SignupScreen(),
            binding: SignupBinding(),
          ),
          GetPage(
            name: '/home', 
            page: () => const HomeScreen(),
            binding: HomeBinding(),
          ),
          GetPage(
            name: '/chapters', 
            page: () => const ChaptersScreen(),
            binding: ChaptersBinding(),
          ),
          GetPage(
            name: '/sloks', 
            page: () => const SloksScreen(),
            binding: SloksBinding(),
          ),
          GetPage(
            name: '/slok_detail', 
            page: () => const SlokDetailScreen(),
            binding: SlokDetailBinding(),
          ),
        ],
      ),
    );
  }
}
