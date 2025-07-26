import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_theme.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../services/api_service.dart';
import '../Settings/settings_controller.dart';
import 'sloks_controller.dart';

class SloksScreen extends GetView<SloksController> {
  const SloksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SloksController controller = Get.find<SloksController>();
    final SettingsController settingsController = Get.find<SettingsController>();
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final Chapter chapter = arguments['chapter'];

    // Fetch sloks when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSloks(chapter.id);
    });

    String getTitle() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Chapter ${chapter.id}: ${chapter.nameMeaning}';
      } else {
        return 'अध्याय ${chapter.id}: ${chapter.nameMeaning}';
      }
    }

    String getLoadingMessage() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Loading verses...';
      } else {
        return 'श्लोक लोड हो रहे हैं...';
      }
    }

    String getNoSloksMessage() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'No verses found';
      } else {
        return 'कोई श्लोक नहीं मिला';
      }
    }

    String getVerseText() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Verse';
      } else {
        return 'श्लोक';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshSloks(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return LoadingWidget(message: getLoadingMessage(), showShimmer: false);
        }

        if (controller.errorMessage.isNotEmpty) {
          return CustomErrorWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.refreshSloks(),
          );
        }

        if (controller.sloks.isEmpty) {
          return CustomErrorWidget(
            message: getNoSloksMessage(),
          );
        }

        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.lightCream, AppTheme.pureWhite],
                ),
              ),
              child: RefreshIndicator(
                onRefresh: () async => controller.refreshSloks(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.sloks.length,
                  itemBuilder: (context, index) {
                    final slok = controller.sloks[index];
                    return SlokCard(
                      slok: slok, 
                      chapter: chapter, 
                      verseText: getVerseText()
                    );
                  },
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
        );
      }),
    );
  }
}

class SlokCard extends StatelessWidget {
  final Slok slok;
  final Chapter chapter;
  final String verseText;

  const SlokCard({
    Key? key,
    required this.slok,
    required this.chapter,
    required this.verseText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/slok_detail', arguments: {
          'slok': slok,
          'chapter': chapter,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: AppTheme.slokCardDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppTheme.spiritualGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$verseText ${slok.verseNumber}',
                      style: AppTheme.meaningTextStyle.copyWith(
                        color: AppTheme.pureWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.primarySaffron,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                slok.displayText,
                style: AppTheme.sanskritTextStyle.copyWith(
                  fontSize: 16,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              if (slok.transliteration.isNotEmpty) ...[
                Text(
                  slok.transliteration,
                  style: AppTheme.meaningTextStyle.copyWith(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 8),
              ],
              if (slok.wordMeanings.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.lightCream,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    slok.wordMeanings,
                    style: AppTheme.meaningTextStyle.copyWith(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
              if (slok.displayTranslation.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.spiritualBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    slok.displayTranslation,
                    style: AppTheme.meaningTextStyle.copyWith(
                      fontSize: 12,
                      color: AppTheme.spiritualBlue,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 