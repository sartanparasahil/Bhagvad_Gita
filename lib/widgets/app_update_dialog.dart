import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_theme.dart';

class AppUpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String newVersion;
  final String updateMessage;
  final bool isForceUpdate;
  final String? updateUrl;
  final VoidCallback? onUpdatePressed;
  final VoidCallback? onLaterPressed;

  const AppUpdateDialog({
    Key? key,
    required this.currentVersion,
    required this.newVersion,
    required this.updateMessage,
    this.isForceUpdate = false,
    this.updateUrl,
    this.onUpdatePressed,
    this.onLaterPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !isForceUpdate,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primarySaffron.withOpacity(0.1),
                AppTheme.spiritualBlue.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primarySaffron.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.system_update,
                  size: 48,
                  color: AppTheme.primarySaffron,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Title
              Text(
                'App Update Available',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Version info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.spiritualBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppTheme.spiritualBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Version $newVersion',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.spiritualBlue,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Current version info
              Text(
                'Current Version: $currentVersion',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.lightBrown,
                  fontFamily: 'Montserrat',
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Update message
              Text(
                updateMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textColor,
                  fontFamily: 'Montserrat',
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Force update warning
              if (isForceUpdate) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This is a required update to continue using the app.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange[700],
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              // Action buttons
              Row(
                children: [
                  if (!isForceUpdate) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onLaterPressed ?? () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: AppTheme.darkBrown,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Later',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: isForceUpdate ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: onUpdatePressed ?? _handleUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primarySaffron,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.download, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Update Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleUpdate() async {
    try {
      if (updateUrl != null && updateUrl!.isNotEmpty) {
        final Uri url = Uri.parse(updateUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          _showErrorSnackbar('Could not open update link');
        }
      } else {
        // Default app store URLs
        if (GetPlatform.isAndroid) {
          final Uri url = Uri.parse(
            'https://play.google.com/store/apps/details?id=com.example.bhagvat_geeta'
          );
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            _showErrorSnackbar('Could not open Play Store');
          }
        } else if (GetPlatform.isIOS) {
          final Uri url = Uri.parse(
            'https://apps.apple.com/app/id123456789'
          );
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            _showErrorSnackbar('Could not open App Store');
          }
        }
      }
    } catch (e) {
      _showErrorSnackbar('Error opening update link: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Update Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      duration: const Duration(seconds: 3),
    );
  }
}

// App Update Service
class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();
  factory AppUpdateService() => _instance;
  AppUpdateService._internal();

  bool _isUpdateDialogShown = false;

  /// Check if update is needed and show dialog
  void checkForUpdate({
    required String currentVersion,
    required String remoteVersion,
    required String updateMessage,
    bool isForceUpdate = false,
    String? updateUrl,
  }) {
    print('AppUpdateService.checkForUpdate called');
    print('Current version: $currentVersion');
    print('Remote version: $remoteVersion');
    print('Dialog already shown: $_isUpdateDialogShown');
    
    if (_isUpdateDialogShown) {
      print('Dialog already shown, returning early');
      return;
    }

    // Simple version comparison (you might want to use a proper version comparison library)
    final shouldUpdate = _shouldUpdate(currentVersion, remoteVersion);
    print('Should update: $shouldUpdate');
    
    if (shouldUpdate) {
      print('Showing update dialog...');
      _showUpdateDialog(
        currentVersion: currentVersion,
        newVersion: remoteVersion,
        updateMessage: updateMessage,
        isForceUpdate: isForceUpdate,
        updateUrl: updateUrl,
      );
    } else {
      print('No update needed');
    }
  }

  bool _shouldUpdate(String currentVersion, String newVersion) {
    try {
      final current = currentVersion.split('.').map(int.parse).toList();
      final newVer = newVersion.split('.').map(int.parse).toList();
      
      for (int i = 0; i < 3; i++) {
        final currentPart = i < current.length ? current[i] : 0;
        final newPart = i < newVer.length ? newVer[i] : 0;
        
        if (newPart > currentPart) return true;
        if (newPart < currentPart) return false;
      }
      return false;
    } catch (e) {
      print('Error comparing versions: $e');
      return false;
    }
  }

  void _showUpdateDialog({
    required String currentVersion,
    required String newVersion,
    required String updateMessage,
    bool isForceUpdate = false,
    String? updateUrl,
  }) {
    print('_showUpdateDialog called');
    _isUpdateDialogShown = true;
    print('Dialog flag set to: $_isUpdateDialogShown');
    
    Get.dialog(
      AppUpdateDialog(
        currentVersion: currentVersion,
        newVersion: newVersion,
        updateMessage: updateMessage,
        isForceUpdate: isForceUpdate,
        updateUrl: updateUrl,
        onLaterPressed: () {
          print('Later button pressed, resetting dialog flag');
          _isUpdateDialogShown = false;
          Get.back();
        },
      ),
      barrierDismissible: !isForceUpdate,
    );
    print('Dialog shown successfully');
  }

  /// Reset the dialog shown flag (useful for testing)
  void resetDialogFlag() {
    print('Resetting dialog flag');
    _isUpdateDialogShown = false;
  }

  /// Force show update dialog (for testing)
  void forceShowUpdateDialog({
    required String currentVersion,
    required String newVersion,
    required String updateMessage,
    bool isForceUpdate = false,
    String? updateUrl,
  }) {
    print('Force showing update dialog');
    _isUpdateDialogShown = false; // Reset flag
    _showUpdateDialog(
      currentVersion: currentVersion,
      newVersion: newVersion,
      updateMessage: updateMessage,
      isForceUpdate: isForceUpdate,
      updateUrl: updateUrl,
    );
  }
} 