import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationController.forward();
    Future.delayed(const Duration(seconds: 10), () {
      Get.offAllNamed('/login');
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
