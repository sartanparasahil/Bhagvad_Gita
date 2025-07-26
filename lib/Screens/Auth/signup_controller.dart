import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/ads_service.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AdsService _adsService = AdsService();
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isTermsAccepted = false.obs;

  // Public getter for ads service
  AdsService get adsService => _adsService;

  @override
  void onInit() {
    super.onInit();
    _adsService.loadBannerAd();
  }

  void signup() async {
    if (!isTermsAccepted.value) {
      Get.snackbar('Terms', 'Please accept terms and conditions');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Password', 'Passwords do not match');
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Simulate signup
    isLoading.value = false;
    Get.offAllNamed('/home');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
