import 'package:get/get.dart';
import '../Screens/Splash/splash_controller.dart';
import '../Screens/Home/home_controller.dart';
import '../Screens/Chapters/chapters_controller.dart';
import '../Screens/Sloks/sloks_controller.dart';
import '../Screens/SlokDetail/slok_detail_controller.dart';
import '../Screens/Settings/settings_controller.dart';
import '../Screens/Auth/login_controller.dart';
import '../Screens/Auth/signup_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core controllers
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
    
    // Screen-specific controllers
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<ChaptersController>(() => ChaptersController(), fenix: true);
    Get.lazyPut<SloksController>(() => SloksController(), fenix: true);
    Get.lazyPut<SlokDetailController>(() => SlokDetailController(), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
  }
}

// Individual bindings for each screen
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class ChaptersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChaptersController>(() => ChaptersController());
  }
}

class SloksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SloksController>(() => SloksController());
  }
}

class SlokDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SlokDetailController>(() => SlokDetailController());
  }
}

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
} 