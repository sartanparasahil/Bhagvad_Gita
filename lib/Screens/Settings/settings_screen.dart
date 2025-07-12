import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Home/home_screen.dart';
import 'settings_controller.dart';
import '../../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primarySaffron,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
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
                      Text(
                        'App Settings',
                        style: TextStyle(
                          color: AppTheme.darkBrown,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Language Settings
                _buildSettingsCard(
                  title: 'Language',
                  subtitle: 'Choose your preferred language',
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
                ),
                SizedBox(height: 20),



                // About Section
                _buildSettingsCard(
                  title: 'About',
                  subtitle: 'App information',
                  icon: Icons.info,
                  child: Column(
                    children: [
                      _buildInfoRow('App Version', '1.0.0'),
                      _buildInfoRow('Developer', 'Bhagavad Gita App'),
                      _buildInfoRow('API Source', 'Vedic Scriptures'),
                    ],
                  ),
                ),
                SizedBox(height: 30), // Extra space at bottom
              ],
            ),
          ),
        ),
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
} 