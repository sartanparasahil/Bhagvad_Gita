import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/slok_detail_controller.dart';
import '../../utils/app_theme.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../services/api_service.dart';
import '../Settings/settings_controller.dart';

class SlokDetailScreen extends StatelessWidget {
  const SlokDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SlokDetailController controller = Get.put(SlokDetailController());
    final SettingsController settingsController = Get.find<SettingsController>();
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final Slok slok = arguments['slok'];
    final Chapter chapter = arguments['chapter'];

    // Fetch slok detail when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSlokDetail(slok.chapterNumber, slok.verseNumber);
    });

    String getTitle() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Verse ${slok.verseNumber}';
      } else {
        return 'श्लोक ${slok.verseNumber}';
      }
    }

    String getLoadingMessage() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Loading verse details...';
      } else {
        return 'श्लोक का विवरण लोड हो रहा है...';
      }
    }

    String getNoDetailMessage() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Verse details not found';
      } else {
        return 'श्लोक का विवरण नहीं मिला';
      }
    }

    String getChapterVerseText() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Chapter ${chapter.id} - Verse ${slok.verseNumber}';
      } else {
        return 'अध्याय ${chapter.id} - श्लोक ${slok.verseNumber}';
      }
    }

    String getSanskritTextTitle() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Sanskrit Verse';
      } else {
        return 'संस्कृत श्लोक';
      }
    }

    String getTransliterationTitle() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Transliteration';
      } else {
        return 'उच्चारण';
      }
    }

    String getWordMeaningsTitle() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Word Meanings';
      } else {
        return 'शब्दार्थ';
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
            onPressed: () => controller.fetchSlokDetail(slok.chapterNumber, slok.verseNumber),
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
            onRetry: () => controller.fetchSlokDetail(slok.chapterNumber, slok.verseNumber),
          );
        }

        if (controller.slokDetail.value == null) {
          return CustomErrorWidget(
            message: getNoDetailMessage(),
          );
        }

        final slokDetail = controller.slokDetail.value!;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.lightCream, AppTheme.pureWhite],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  decoration: AppTheme.cardDecoration,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: AppTheme.sacredGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getChapterVerseText(),
                          style: AppTheme.chapterTitleStyle.copyWith(
                            color: AppTheme.pureWhite,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        chapter.nameMeaning,
                        style: AppTheme.chapterTitleStyle.copyWith(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chapter.nameTranslated,
                        style: AppTheme.meaningTextStyle.copyWith(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Sanskrit Text
                DetailSection(
                  title: getSanskritTextTitle(),
                  icon: Icons.auto_stories,
                  child: Text(
                    slokDetail.displayText,
                    style: AppTheme.sanskritTextStyle.copyWith(
                      fontSize: 18,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 20),

                // Transliteration
                if (slokDetail.transliteration.isNotEmpty) ...[
                  DetailSection(
                    title: getTransliterationTitle(),
                    icon: Icons.record_voice_over,
                    child: Text(
                      slokDetail.transliteration,
                      style: AppTheme.meaningTextStyle.copyWith(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Word Meanings
                if (slokDetail.wordMeanings.isNotEmpty) ...[
                  DetailSection(
                    title: getWordMeaningsTitle(),
                    icon: Icons.translate,
                    child: Text(
                      slokDetail.wordMeanings,
                      style: AppTheme.meaningTextStyle.copyWith(
                        fontSize: 16,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Translation
                Obx(() {
                  final translation = settingsController.getTranslation(slokDetail.commentaries);
                  if (translation.isNotEmpty && translation != 'Translation not available') {
                    return Column(
                      children: [
                        DetailSection(
                          title: settingsController.selectedLanguage.value == 'hindi' ? 'अनुवाद' : 'Translation',
                          icon: Icons.language,
                          child: Text(
                            translation,
                            style: AppTheme.meaningTextStyle.copyWith(
                              fontSize: 16,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Purport
                Obx(() {
                  final purport = settingsController.getPurport(slokDetail.commentaries);
                  if (purport.isNotEmpty && purport != 'Purport not available') {
                    return DetailSection(
                      title: settingsController.selectedLanguage.value == 'hindi' ? 'भावार्थ' : 'Purport',
                      icon: Icons.psychology,
                      child: Text(
                        purport,
                        style: AppTheme.meaningTextStyle.copyWith(
                          fontSize: 16,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const DetailSection({
    Key? key,
    required this.title,
    required this.icon,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primarySaffron.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primarySaffron,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTheme.chapterTitleStyle.copyWith(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
} 