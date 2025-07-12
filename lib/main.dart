import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Auth/login_screen.dart';
import 'Screens/Auth/signup_screen.dart';
import 'Screens/Home/home_screen.dart';
import 'Screens/Splash/splash_screen.dart';
import 'Screens/Chapters/chapters_screen.dart';
import 'Screens/Sloks/sloks_screen.dart';
import 'Screens/SlokDetail/slok_detail_screen.dart';
import 'Screens/Settings/settings_controller.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize settings controller
  final settingsController = Get.put(SettingsController());
  await settingsController.loadSettings();
  
  runApp(const BhagavadGitaApp());
}

class BhagavadGitaApp extends StatelessWidget {
  const BhagavadGitaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhagavad Gita',
      theme: AppTheme.theme,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignupScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/chapters', page: () => const ChaptersScreen()),
        GetPage(name: '/sloks', page: () => const SloksScreen()),
        GetPage(name: '/slok_detail', page: () => const SlokDetailScreen()),
      ],
    );
  }
}
