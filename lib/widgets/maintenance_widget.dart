import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/remote_config_service.dart';
import '../utils/app_theme.dart';

class MaintenanceWidget extends StatelessWidget {
  final Widget child;
  final RemoteConfigService? remoteConfigService;

  const MaintenanceWidget({
    Key? key,
    required this.child,
    this.remoteConfigService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final configService = remoteConfigService ?? RemoteConfigService();

    return Obx(() {
      if (configService.isInMaintenanceMode) {
        return _buildMaintenanceScreen(configService.getMaintenanceMessage, configService);
      }
      return child;
    });
  }

  Widget _buildMaintenanceScreen(String message, RemoteConfigService configService) {
    return Scaffold(
      backgroundColor: AppTheme.lightCream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Maintenance icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.build_circle_outlined,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Title
                Text(
                  'Under Maintenance',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontFamily: 'Montserrat',
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textColor,
                    fontFamily: 'Montserrat',
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Retry button
                ElevatedButton.icon(
                  onPressed: () async {
                    await configService.forceRefresh();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Check Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // App version
                Text(
                  'Version: ${configService.getAppVersion}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textColor.withOpacity(0.6),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 