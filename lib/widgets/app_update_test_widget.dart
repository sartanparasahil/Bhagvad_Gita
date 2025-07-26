import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';
import 'app_update_dialog.dart';

class AppUpdateTestWidget extends StatelessWidget {
  const AppUpdateTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.lightBrown.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.system_update,
                color: AppTheme.primarySaffron,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'App Update Test',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Test the app update dialog functionality with different scenarios.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.lightBrown,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showUpdateDialog(false),
                  icon: const Icon(Icons.update, size: 18),
                  label: const Text('Optional Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.spiritualBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showUpdateDialog(true),
                  icon: const Icon(Icons.warning, size: 18),
                  label: const Text('Force Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _showCustomUpdateDialog,
            icon: const Icon(Icons.settings, size: 18),
            label: const Text('Custom Update Dialog'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primarySaffron,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(bool isForceUpdate) {
    Get.dialog(
      AppUpdateDialog(
        currentVersion: '1.0.0',
        newVersion: '1.1.0',
        updateMessage: isForceUpdate
            ? 'This is a critical update that fixes important security issues. You must update to continue using the app.'
            : 'A new version is available with bug fixes and new features. We recommend updating for the best experience.',
        isForceUpdate: isForceUpdate,
        updateUrl: 'https://play.google.com/store/apps/details?id=com.example.bhagvat_geeta',
      ),
      barrierDismissible: !isForceUpdate,
    );
  }

  void _showCustomUpdateDialog() {
    Get.dialog(
      AppUpdateDialog(
        currentVersion: '1.0.0',
        newVersion: '2.0.0',
        updateMessage: 'Major update with new features:\n\n• New chapter translations\n• Improved audio playback\n• Dark mode support\n• Offline reading\n• Bookmark functionality',
        isForceUpdate: false,
        updateUrl: 'https://apps.apple.com/app/id123456789',
        onUpdatePressed: () {
          Get.snackbar(
            'Update',
            'Opening App Store...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.primarySaffron.withOpacity(0.1),
            colorText: AppTheme.primarySaffron,
          );
          Get.back();
        },
        onLaterPressed: () {
          Get.snackbar(
            'Reminder',
            'You can update later from the app store',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey.withOpacity(0.1),
            colorText: Colors.grey[700],
          );
          Get.back();
        },
      ),
    );
  }
} 