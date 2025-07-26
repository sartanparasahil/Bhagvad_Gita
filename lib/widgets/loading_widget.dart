import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';
import '../Screens/Settings/settings_controller.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool showShimmer;
  final bool isCompact;
  
  const LoadingWidget({Key? key, this.message, this.showShimmer = true, this.isCompact = false}) : super(key: key);

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

    Widget logoWidget = Container(
      width: isCompact ? 40 : 80,
      height: isCompact ? 40 : 80,
      decoration: BoxDecoration(
        color: AppTheme.primarySaffron,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.auto_stories,
        size: isCompact ? 20 : 40,
        color: AppTheme.pureWhite,
      ),
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo with or without shimmer effect
          showShimmer 
            ? Shimmer.fromColors(
                baseColor: AppTheme.primarySaffron.withOpacity(0.3),
                highlightColor: AppTheme.primarySaffron,
                child: logoWidget,
              )
            : logoWidget,
          if (!isCompact) ...[
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
          ],
          SizedBox(
            width: isCompact ? 24 : 40,
            height: isCompact ? 24 : 40,
            child: CircularProgressIndicator(
              strokeWidth: isCompact ? 2 : 3,
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