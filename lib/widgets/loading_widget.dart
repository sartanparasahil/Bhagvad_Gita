import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';
import '../Screens/Settings/settings_controller.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  
  const LoadingWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    
    String getLoadingMessage() {
      if (message != null) return message!;
      
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Loading...';
      } else {
        return 'लोड हो रहा है...';
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Shimmer effect with logo in center
          Shimmer.fromColors(
            baseColor: AppTheme.primarySaffron.withOpacity(0.3),
            highlightColor: AppTheme.primarySaffron,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primarySaffron,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_stories,
                size: 40,
                color: AppTheme.pureWhite,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            getLoadingMessage(),
            style: AppTheme.meaningTextStyle.copyWith(
              fontSize: 16,
              color: AppTheme.darkBrown,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primarySaffron),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double height;
  final double width;
  
  const ShimmerCard({
    Key? key,
    this.height = 100,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.lightCream,
      highlightColor: AppTheme.pureWhite,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
} 