import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/ads_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AdsService _adsService = AdsService();
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isTermsAccepted = false.obs;

  // Public getter for ads service
  AdsService get adsService => _adsService;

  @override
  void onInit() {
    super.onInit();
    _adsService.loadBannerAd();
  }

  void login() async {
    if (!isTermsAccepted.value) {
      Get.snackbar('Terms', 'Please accept terms and conditions');
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Simulate login
    isLoading.value = false;
    Get.offAllNamed('/home');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
