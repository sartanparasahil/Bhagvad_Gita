import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  
  const CustomErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: AppTheme.errorRed,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops!',
              style: AppTheme.chapterTitleStyle.copyWith(
                fontSize: 24,
                color: AppTheme.errorRed,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTheme.meaningTextStyle.copyWith(
                fontSize: 16,
                color: AppTheme.darkBrown,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primarySaffron,
                  foregroundColor: AppTheme.pureWhite,
                ),
              ),
          ],
        ),
      ),
    );
  }
} 