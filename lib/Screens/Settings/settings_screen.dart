import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Home/home_screen.dart';
import 'settings_controller.dart';
import '../../utils/app_theme.dart';
import '../../services/notification_service.dart';
import '../../services/ads_service.dart';
import '../../widgets/app_update_test_widget.dart';

class SettingsScreen extends GetView<SettingsController> {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.find<SettingsController>();
    String getTitle() {
      if (controller.selectedLanguage.value == 'english') {
        return 'Settings';
      } else {
        return 'सेटिंग्स';
      }
    }

    String getAppSettingsText() {
      if (controller.selectedLanguage.value == 'english') {
        return 'App Settings';
      } else {
        return 'ऐप सेटिंग्स';
      }
    }

    String getLanguageText() {
      if (controller.selectedLanguage.value == 'english') {
        return 'Language';
      } else {
        return 'भाषा';
      }
    }

    String getLanguageSubtitle() {
      if (controller.selectedLanguage.value == 'english') {
        return 'Choose your preferred language';
      } else {
        return 'अपनी पसंदीदा भाषा चुनें';
      }
    }

    String getAboutText() {
      if (controller.selectedLanguage.value == 'english') {
        return 'About';
      } else {
        return 'के बारे में';
      }
    }

    String getAboutSubtitle() {
      if (controller.selectedLanguage.value == 'english') {
        return 'App information';
      } else {
        return 'ऐप की जानकारी';
      }
    }

    String getAppVersionText() {
      if (controller.selectedLanguage.value == 'english') {
        return 'App Version';
      } else {
        return 'ऐप संस्करण';
      }
    }

    String getDeveloperText() {
      if (controller.selectedLanguage.value == 'english') {
        return 'Developer';
      } else {
        return 'डेवलपर';
      }
    }

    String getApiSourceText() {
      if (controller.selectedLanguage.value == 'english') {
        return 'API Source';
      } else {
        return 'एपीआई स्रोत';
      }
    }

    String getNotificationText() {
      if (controller.selectedLanguage.value == 'english') {
        return 'Daily Notifications';
      } else {
        return 'दैनिक सूचनाएं';
      }
    }

    String getNotificationSubtitle() {
      if (controller.selectedLanguage.value == 'english') {
        return 'Get daily random slok at 9 AM';
      } else {
        return 'सुबह 9 बजे दैनिक रैंडम श्लोक प्राप्त करें';
      }
    }



    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          getTitle(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )),
        backgroundColor: AppTheme.primarySaffron,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: AppTheme.lightCream,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
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
                            Icons.settings,
                            color: AppTheme.primarySaffron,
                            size: 30,
                          ),
                          SizedBox(width: 15),
                          Obx(() => Text(
                            getAppSettingsText(),
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

                // Language Settings
                Obx(() => _buildSettingsCard(
                  title: getLanguageText(),
                  subtitle: getLanguageSubtitle(),
                  icon: Icons.language,
                  child: Column(
                    children: [
                      _buildLanguageOption(
                        'Hindi',
                        'हिंदी',
                        'hindi',
                        Icons.flag,
                      ),
                      SizedBox(height: 10),
                      _buildLanguageOption(
                        'English',
                        'English',
                        'english',
                        Icons.flag_outlined,
                      ),
                    ],
                  ),
                )),
                SizedBox(height: 20),

                // Notification Settings
                Obx(() => _buildSettingsCard(
                  title: getNotificationText(),
                  subtitle: getNotificationSubtitle(),
                  icon: Icons.notifications,
                  child: Column(
                    children: [
                      _buildNotificationToggle(),
                    ],
                  ),
                )),
                SizedBox(height: 20),

                    // About Section
                    Obx(() => _buildSettingsCard(
                      title: getAboutText(),
                      subtitle: getAboutSubtitle(),
                      icon: Icons.info,
                      child: Column(
                        children: [
                          _buildInfoRow(getAppVersionText(), '1.0.0'),
                          _buildInfoRow(getDeveloperText(), 'Bhagavad Gita App'),
                          _buildInfoRow(getApiSourceText(), 'Vedic Scriptures'),
                        ],
                      ),
                    )),
                    SizedBox(height: 20),

                    // App Update Test Section
                    const AppUpdateTestWidget(),
                    SizedBox(height: 20),

                  ],
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

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkBrown.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primarySaffron, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.lightBrown,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String title, String subtitle, String value, IconData icon) {
    return Obx(() => InkWell(
      onTap: () => controller.setLanguage(value),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: controller.selectedLanguage.value == value
              ? AppTheme.primarySaffron.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: controller.selectedLanguage.value == value
                ? AppTheme.primarySaffron
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: controller.selectedLanguage.value == value
                  ? AppTheme.primarySaffron
                  : Colors.grey,
              size: 24,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: controller.selectedLanguage.value == value
                          ? AppTheme.primarySaffron
                          : AppTheme.darkBrown,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.lightBrown,
                    ),
                  ),
                ],
              ),
            ),
            if (controller.selectedLanguage.value == value)
              Icon(
                Icons.check_circle,
                color: AppTheme.primarySaffron,
                size: 24,
              ),
          ],
        ),
      ),
    ));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.darkBrown,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primarySaffron,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          controller.selectedLanguage.value == 'english' ? 'Enable Notifications' : 'सूचनाएं सक्षम करें',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.darkBrown,
          ),
        ),
        Switch(
          value: controller.notificationsEnabled.value,
          onChanged: (value) async {
            controller.setNotificationsEnabled(value);
            final notificationService = NotificationService();
            if (value) {
              await notificationService.scheduleDailyNotification();
              Get.snackbar(
                'Notifications Enabled',
                'Daily notifications scheduled for 9 AM',
                backgroundColor: AppTheme.primarySaffron,
                colorText: Colors.white,
              );
            } else {
              await notificationService.cancelAllNotifications();
              Get.snackbar(
                'Notifications Disabled',
                'Daily notifications cancelled',
                backgroundColor: Colors.grey,
                colorText: Colors.white,
              );
            }
          },
          activeColor: AppTheme.primarySaffron,
        ),
      ],
    ));
  }
}