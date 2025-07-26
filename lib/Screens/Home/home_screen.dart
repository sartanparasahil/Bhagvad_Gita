import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Settings/settings_controller.dart';
import '../Settings/settings_screen.dart';
import '../../services/ads_service.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find<SettingsController>();
  
    String getAppTitle() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Bhagavad Gita';
      } else {
        return 'भगवद्गीता';
      }
    }

    String getSubtitle() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'The Song of God';
      } else {
        return 'The Song of God';
      }
    }

    String getWelcomeTitle() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Ocean of Knowledge';
      } else {
        return 'ज्ञान का सागर';
      }
    }

    String getWelcomeMessage() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'The Bhagavad Gita contains 18 chapters and 700 verses. Each chapter illuminates different aspects of life.';
      } else {
        return 'भगवद्गीता में 18 अध्याय और 700 श्लोक हैं। प्रत्येक अध्याय जीवन के विभिन्न पहलुओं पर प्रकाश डालता है।';
      }
    }

    String getStartReadingText() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Start Reading Chapters';
      } else {
        return 'अध्याय पढ़ना शुरू करें';
      }
    }

    String getChaptersText() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Chapters';
      } else {
        return 'अध्याय';
      }
    }

    String getVersesText() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Verses';
      } else {
        return 'श्लोक';
      }
    }

    String getWisdomText() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Wisdom';
      } else {
        return 'ज्ञान';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppTheme.darkBrown),
            onPressed: () => Get.to(() => SettingsScreen()),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: Get.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.lightCream, AppTheme.pureWhite],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.darkBrown.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_stories,
                              color: AppTheme.primarySaffron,
                              size: 30,
                            ),
                            SizedBox(width: 15),
                            Obx(() => Text(
                              getAppTitle(),
                              style: TextStyle(
                                color: AppTheme.darkBrown,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),

                      // Welcome Card
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primarySaffron.withOpacity(0.1),
                              AppTheme.spiritualBlue.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.primarySaffron.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: AppTheme.primarySaffron,
                                  size: 28,
                                ),
                                SizedBox(width: 12),
                                Obx(() => Text(
                                  getWelcomeTitle(),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.spiritualBlue,
                                    fontFamily: 'Montserrat',
                                  ),
                                )),
                              ],
                            ),
                            SizedBox(height: 16),
                            Obx(() => Text(
                              getWelcomeMessage(),
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.darkBrown,
                                height: 1.6,
                                fontFamily: 'Montserrat',
                              ),
                              textAlign: TextAlign.center,
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Start Reading Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.toNamed('/chapters');
                          },
                          icon: const Icon(Icons.menu_book, size: 24),
                          label: Obx(() => Text(
                            getStartReadingText(),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.pureWhite,
                            ),
                          )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primarySaffron,
                            foregroundColor: AppTheme.pureWhite,
                            elevation: 8,
                            shadowColor: AppTheme.primarySaffron.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Quick Info
                      Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoCard('18', getChaptersText(), Icons.book),
                          _buildInfoCard('700', getVersesText(), Icons.auto_stories),
                          _buildInfoCard('1', getWisdomText(), Icons.lightbulb),
                        ],
                      )),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Fixed bottom banner ad
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              final bannerAdWidget = controller.adsService.getBannerAdWidget();
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

  Widget _buildInfoCard(String number, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkBrown.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primarySaffron,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.spiritualBlue,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppTheme.lightBrown,
            ),
          ),
        ],
      ),
    );
  }
}
