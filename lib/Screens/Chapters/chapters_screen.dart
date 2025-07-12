import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chapters_controller.dart';
import '../../utils/app_theme.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../services/api_service.dart';

class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChaptersController controller = Get.put(ChaptersController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('भगवद्गीता के अध्याय'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshChapters(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'अध्याय लोड हो रहे हैं...');
        }

        if (controller.errorMessage.isNotEmpty) {
          return CustomErrorWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.refreshChapters(),
          );
        }

        if (controller.chapters.isEmpty) {
          return const CustomErrorWidget(
            message: 'कोई अध्याय नहीं मिला',
          );
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.lightCream, AppTheme.pureWhite],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () async => controller.refreshChapters(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75, // Adjusted for better fit
              ),
              itemCount: controller.chapters.length,
              itemBuilder: (context, index) {
                final chapter = controller.chapters[index];
                return ChapterCard(chapter: chapter);
              },
            ),
          ),
        );
      }),
    );
  }
}

class ChapterCard extends StatelessWidget {
  final Chapter chapter;

  const ChapterCard({Key? key, required this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/sloks', arguments: {'chapter': chapter});
      },
      child: Container(
        decoration: AppTheme.chapterCardDecoration,
        child: Padding(
          padding: const EdgeInsets.all(12), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50, // Reduced size
                height: 50, // Reduced size
                decoration: BoxDecoration(
                  color: AppTheme.pureWhite.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${chapter.id}',
                    style: AppTheme.chapterTitleStyle.copyWith(
                      color: AppTheme.pureWhite,
                      fontSize: 20, // Reduced font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8), // Reduced spacing
              Flexible(
                child: Text(
                  chapter.name,
                  style: AppTheme.chapterTitleStyle.copyWith(
                    color: AppTheme.pureWhite,
                    fontSize: 14, // Reduced font size
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6), // Reduced spacing
              Flexible(
                child: Text(
                  chapter.nameTranslated,
                  style: AppTheme.meaningTextStyle.copyWith(
                    color: AppTheme.pureWhite,
                    fontSize: 10, // Reduced font size
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6), // Reduced spacing
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Reduced padding
                decoration: BoxDecoration(
                  color: AppTheme.pureWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8), // Reduced radius
                ),
                child: Text(
                  '${chapter.versesCount} श्लोक',
                  style: AppTheme.meaningTextStyle.copyWith(
                    color: AppTheme.pureWhite,
                    fontSize: 8, // Reduced font size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 