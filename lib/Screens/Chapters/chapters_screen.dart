import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../controllers/chapters_controller.dart';
import '../../utils/app_theme.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../Settings/settings_controller.dart';
import 'package:shimmer/shimmer.dart';


class ChaptersScreen extends StatefulWidget {
  const ChaptersScreen({Key? key}) : super(key: key);

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  bool showAds = false;
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _fetchRemoteConfig();
  }

  Future<void> _fetchRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    final ads = remoteConfig.getBool('show_ads');
    setState(() {
      showAds = ads;
    });
    if (showAds) {
      _loadBannerAd();
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _getAdUnitId(),
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  String _getAdUnitId() {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return 'ca-app-pub-5157769145271323/8841881966'; // iOS Banner Ad Unit ID
    } else {
      return 'ca-app-pub-5157769145271323/8841881966'; // Android Banner Ad Unit ID
    }
  }

  @override
  void dispose() {
    if (_isBannerAdReady) {
      _bannerAd.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChaptersController controller = Get.put(ChaptersController());
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshChapters(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                // Shimmer effect while loading
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: AppTheme.lightCream,
                      highlightColor: AppTheme.sacredGold.withOpacity(0.3),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.pureWhite,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    );
                  },
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

              return ListView.builder(
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
              );
            }),
          ),
          if (showAds && _isBannerAdReady)
            SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
    );
  }
} 