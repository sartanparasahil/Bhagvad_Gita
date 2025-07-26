import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_theme.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../Settings/settings_controller.dart';
import '../../services/ads_service.dart';
import 'package:shimmer/shimmer.dart';
import 'chapters_controller.dart';


class ChaptersScreen extends GetView<ChaptersController> {
  const ChaptersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChaptersController controller = Get.find<ChaptersController>();
    final SettingsController settingsController = Get.find<SettingsController>();

    String getTitle() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Chapters of Bhagavad Gita';
      } else {
        return 'भगवद्गीता के अध्याय';
      }
    }

    String getLoadingMessage() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'Loading chapters...';
      } else {
        return 'अध्याय लोड हो रहे हैं...';
      }
    }

    String getNoChaptersMessage() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'No chapters found';
      } else {
        return 'कोई अध्याय नहीं मिला';
      }
    }

    String getVersesText() {
      if (settingsController.selectedLanguage.value == 'english') {
        return 'verses';
      } else {
        return 'श्लोक';
      }
    }

    // Sanskrit shloka/quote
    final String shloka =
        'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन ।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि ॥';
    final String shlokaMeaning =
        'You have the right to perform your actions, but not to the fruits of your actions.';

    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.refresh),
            onSelected: (value) {
              if (value == 'refresh') {
                controller.refreshChapters();
              } else if (value == 'force_refresh') {
                controller.forceRefreshChapters();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    const Icon(Icons.refresh, size: 20),
                    const SizedBox(width: 8),
                    Text(settingsController.selectedLanguage.value == 'english'
                      ? 'Refresh'
                      : 'रिफ्रेश'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'force_refresh',
                child: Row(
                  children: [
                    const Icon(Icons.cloud_download, size: 20),
                    const SizedBox(width: 8),
                    Text(settingsController.selectedLanguage.value == 'english'
                      ? 'Force Refresh'
                      : 'फोर्स रिफ्रेश'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Obx(() {
              if (controller.isLoading.value) {
                // Loading widget without shimmer effect for adhyat loading
                return LoadingWidget(
                  message: getLoadingMessage(),
                  showShimmer: false,
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return CustomErrorWidget(
                  message: controller.errorMessage.value,
                  onRetry: () => controller.refreshChapters(),
                );
              }

              if (controller.chapters.isEmpty) {
                return CustomErrorWidget(
                  message: getNoChaptersMessage(),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.refreshChapters();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  itemCount: controller.chapters.length,
                  itemBuilder: (context, index) {
                  final chapter = controller.chapters[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/sloks', arguments: {'chapter': chapter});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.15 + (index % 2) * 0.1),
                              AppTheme.primaryColor.withOpacity(0.35 + (index % 2) * 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Decorative chapter number with lotus icon
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.sacredGold,
                                          AppTheme.primaryColor,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryColor.withOpacity(0.18),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${chapter.id}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Icon(
                                      Icons.spa, // Lotus icon
                                      size: 18,
                                      color: AppTheme.sacredGold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 18),
                              // Chapter info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chapter.nameMeaning,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E),
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      chapter.nameTranslated,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF616161),
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.menu_book, size: 20, color: AppTheme.primarySaffron, weight: 800),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${chapter.versesCount} ' + (settingsController.selectedLanguage.value == 'english' ? 'Verses' : 'श्लोक'),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: AppTheme.primarySaffron,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Montserrat',
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
            }),
          ),
        ],
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
      ),
    );
  }
} 