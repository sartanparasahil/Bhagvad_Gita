import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'signup_controller.dart';
import '../../widgets/loading_widget.dart';
import '../../services/ads_service.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                // Animated logo
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) => Transform.scale(
                    scale: value,
                    child: child,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_stories,
                      color: const Color(0xFFFF9933),
                      size: 56,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Create your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 32),
                // Email field (NO Obx needed)
                TextField(
                  controller: Get.find<SignupController>().emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF1A237E)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                // Password field
                Obx(() => TextField(
                      controller: Get.find<SignupController>().passwordController,
                      obscureText: !Get.find<SignupController>().isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1A237E)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Get.find<SignupController>().isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF1A237E),
                          ),
                          onPressed: () => Get.find<SignupController>().isPasswordVisible.toggle(),
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
                // Confirm Password field
                Obx(() => TextField(
                      controller: Get.find<SignupController>().confirmPasswordController,
                      obscureText: !Get.find<SignupController>().isConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1A237E)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Get.find<SignupController>().isConfirmPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF1A237E),
                          ),
                          onPressed: () => Get.find<SignupController>().isConfirmPasswordVisible.toggle(),
                        ),
                      ),
                    )),
                const SizedBox(height: 12),
                // Terms and conditions
                Obx(() => Row(
                      children: [
                        Checkbox(
                          value: Get.find<SignupController>().isTermsAccepted.value,
                          onChanged: (val) => Get.find<SignupController>().isTermsAccepted.value = val ?? false,
                          activeColor: const Color(0xFFFF9933),
                        ),
                        const Expanded(
                          child: Text(
                            'I accept the Terms and Conditions',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 12),
                // Signup button
                Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9933),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: Get.find<SignupController>().isLoading.value ? null : Get.find<SignupController>().signup,
                      child: Get.find<SignupController>().isLoading.value
                          ? const LoadingWidget(isCompact: true, showShimmer: false)
                          : const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    )),
                const SizedBox(height: 16),
                // Or divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('or', style: TextStyle(color: Colors.grey[700])),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                // Social signup buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialButton(
                      icon: FontAwesomeIcons.google,
                      label: 'Google',
                      color: Colors.white,
                      borderColor: const Color(0xFF1A237E),
                      textColor: const Color(0xFF1A237E),
                      onTap: () {
                        // TODO: Implement Google signup
                        Get.snackbar('Google Signup', 'Coming soon!');
                      },
                    ),
                    const SizedBox(width: 16),
                    _SocialButton(
                      icon: FontAwesomeIcons.facebookF,
                      label: 'Facebook',
                      color: const Color(0xFF1877F3),
                      borderColor: const Color(0xFF1877F3),
                      textColor: Colors.white,
                      onTap: () {
                        // TODO: Implement Facebook signup
                        Get.snackbar('Facebook Signup', 'Coming soon!');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Get.toNamed('/login'),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFF1A237E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),),
          // Fixed bottom banner ad
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              final bannerAdWidget = Get.find<SignupController>().adsService.getBannerAdWidget();
              if (bannerAdWidget != null) {
                return Container(
                  color: Colors.white,
                  child: bannerAdWidget,
                );
              }
              return const SizedBox.shrink();
            }),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        side: BorderSide(color: borderColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      icon: Icon(icon, color: textColor, size: 22),
      label: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
      onPressed: onTap,
    );
  }
}
