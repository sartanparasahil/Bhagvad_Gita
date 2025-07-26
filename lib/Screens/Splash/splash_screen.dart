import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFE0B2), // Soft saffron
                  Color(0xFF1A237E), // Spiritual blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Background image placeholder (Krishna & Arjuna)
          Opacity(
            opacity: 0.15,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/krishna_arjuna.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
          // Logo and title with fade-in
          Center(
            child: FadeTransition(
              opacity: controller.fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App logo placeholder (can be replaced with real asset)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_stories,
                      color: Color(0xFFFF9933),
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bhagavad Gita',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A Journey Within',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFF9933),
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}