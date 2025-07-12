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

    return Scaffold(
      appBar: AppBar(
        title: Text('श्लोक ${slok.verseNumber}'),
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
          return const LoadingWidget(message: 'श्लोक का विवरण लोड हो रहा है...');
        }

        if (controller.errorMessage.isNotEmpty) {
          return CustomErrorWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.fetchSlokDetail(slok.chapterNumber, slok.verseNumber),
          );
        }

        if (controller.slokDetail.value == null) {
          return const CustomErrorWidget(
            message: 'श्लोक का विवरण नहीं मिला',
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
                          'अध्याय ${chapter.id} - श्लोक ${slokDetail.verseNumber}',
                          style: AppTheme.chapterTitleStyle.copyWith(
                            color: AppTheme.pureWhite,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        chapter.name,
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
                  title: 'संस्कृत श्लोक',
                  icon: Icons.auto_stories,
                  child: Text(
                    slokDetail.text,
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
                    title: 'उच्चारण',
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
                    title: 'शब्दार्थ',
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