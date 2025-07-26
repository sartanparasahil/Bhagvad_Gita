import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'remote_config_service.dart';
import '../models/app_config_model.dart';

class AdsService {
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  final RemoteConfigService _remoteConfigService = RemoteConfigService();
  
  // Ad instances
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  
  // Ad states
  final RxBool isBannerAdReady = false.obs;
  final RxBool isInterstitialAdReady = false.obs;
  final RxBool isRewardedAdReady = false.obs;
  final RxBool isLoadingAd = false.obs;

  // Interstitial ad counter
  int _interstitialAdCounter = 0;

  /// Initialize the ads service
  Future<void> init() async {
    try {
      // Initialize Google Mobile Ads
      await MobileAds.instance.initialize();
      
      // Listen to remote config changes
      ever(_remoteConfigService.appConfig, (AppConfigModel? config) {
        if (config != null) {
          if (config.showAds) {
            refreshAds();
          } else {
            disposeAllAds();
          }
        }
      });
      
      print('Ads service initialized successfully');
    } catch (e) {
      print('Error initializing ads service: $e');
    }
  }

  /// Load banner ad
  Future<void> loadBannerAd() async {
    if (!_remoteConfigService.shouldShowAds) {
      print('Ads disabled by remote config');
      return;
    }

    try {
      // Dispose existing ad if any
      _bannerAd?.dispose();
      
      final adUnitId = _remoteConfigService.getBannerAdUnitId();
      print('Loading banner ad with unit ID: $adUnitId');
      
      _bannerAd = BannerAd(
        adUnitId: adUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print('Banner ad loaded successfully');
            isBannerAdReady.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            print('Banner ad failed to load: $error');
            isBannerAdReady.value = false;
            ad.dispose();
          },
          onAdOpened: (ad) {
            print('Banner ad opened');
          },
          onAdClosed: (ad) {
            print('Banner ad closed');
          },
        ),
      );

      await _bannerAd!.load();
    } catch (e) {
      print('Error loading banner ad: $e');
      isBannerAdReady.value = false;
    }
  }

  /// Load interstitial ad
  Future<void> loadInterstitialAd() async {
    if (!_remoteConfigService.shouldShowAds) {
      print('Ads disabled by remote config');
      return;
    }

    try {
      isLoadingAd.value = true;
      
      final adUnitId = _remoteConfigService.getInterstitialAdUnitId();
      print('Loading interstitial ad with unit ID: $adUnitId');
      
      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            print('Interstitial ad loaded successfully');
            _interstitialAd = ad;
            isInterstitialAdReady.value = true;
            isLoadingAd.value = false;
            
            // Set up ad event listeners
            _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                print('Interstitial ad dismissed');
                isInterstitialAdReady.value = false;
                ad.dispose();
                // Load next interstitial ad
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                print('Interstitial ad failed to show: $error');
                isInterstitialAdReady.value = false;
                ad.dispose();
                isLoadingAd.value = false;
              },
              onAdShowedFullScreenContent: (ad) {
                print('Interstitial ad showed full screen content');
              },
            );
          },
          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');
            isInterstitialAdReady.value = false;
            isLoadingAd.value = false;
          },
        ),
      );
    } catch (e) {
      print('Error loading interstitial ad: $e');
      isInterstitialAdReady.value = false;
      isLoadingAd.value = false;
    }
  }

  /// Load rewarded ad
  Future<void> loadRewardedAd() async {
    if (!_remoteConfigService.shouldShowAds) {
      print('Ads disabled by remote config');
      return;
    }

    try {
      isLoadingAd.value = true;
      
      final adUnitId = _remoteConfigService.getRewardedAdUnitId();
      print('Loading rewarded ad with unit ID: $adUnitId');
      
      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            print('Rewarded ad loaded successfully');
            _rewardedAd = ad;
            isRewardedAdReady.value = true;
            isLoadingAd.value = false;
            
            // Set up ad event listeners
            _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                print('Rewarded ad dismissed');
                isRewardedAdReady.value = false;
                ad.dispose();
                // Load next rewarded ad
                loadRewardedAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                print('Rewarded ad failed to show: $error');
                isRewardedAdReady.value = false;
                ad.dispose();
                isLoadingAd.value = false;
              },
              onAdShowedFullScreenContent: (ad) {
                print('Rewarded ad showed full screen content');
              },
            );
          },
          onAdFailedToLoad: (error) {
            print('Rewarded ad failed to load: $error');
            isRewardedAdReady.value = false;
            isLoadingAd.value = false;
          },
        ),
      );
    } catch (e) {
      print('Error loading rewarded ad: $e');
      isRewardedAdReady.value = false;
      isLoadingAd.value = false;
    }
  }

  /// Show interstitial ad
  Future<bool> showInterstitialAd() async {
    if (!_remoteConfigService.shouldShowAds) {
      print('Ads disabled by remote config');
      return false;
    }

    if (_interstitialAd == null || !isInterstitialAdReady.value) {
      print('Interstitial ad not ready');
      return false;
    }

    try {
      await _interstitialAd!.show();
      return true;
    } catch (e) {
      print('Error showing interstitial ad: $e');
      return false;
    }
  }

  /// Show rewarded ad
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    Function()? onAdClosed,
    Function()? onAdFailedToShow,
  }) async {
    if (!_remoteConfigService.shouldShowAds) {
      print('Ads disabled by remote config');
      return false;
    }

    if (_rewardedAd == null || !isRewardedAdReady.value) {
      print('Rewarded ad not ready');
      return false;
    }

    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
          onRewarded();
        },
      );
      return true;
    } catch (e) {
      print('Error showing rewarded ad: $e');
      onAdFailedToShow?.call();
      return false;
    }
  }

  /// Get banner ad widget
  Widget? getBannerAdWidget() {
    if (!_remoteConfigService.shouldShowAds || !isBannerAdReady.value || _bannerAd == null) {
      return null;
    }

    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      width: _bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  /// Check if ads should be shown
  bool get shouldShowAds => _remoteConfigService.shouldShowAds;

  /// Check if banner ad is ready
  bool get isBannerReady => isBannerAdReady.value;

  /// Check if interstitial ad is ready
  bool get isInterstitialReady => isInterstitialAdReady.value;

  /// Check if rewarded ad is ready
  bool get isRewardedReady => isRewardedAdReady.value;

  /// Check if any ad is loading
  bool get isAdLoading => isLoadingAd.value;

  /// Refresh ads based on remote config changes
  void refreshAds() {
    if (_remoteConfigService.shouldShowAds) {
      loadBannerAd();
      loadInterstitialAd();
      loadRewardedAd();
    } else {
      // Dispose all ads if ads are disabled
      disposeAllAds();
    }
  }

  /// Dispose all ads
  void disposeAllAds() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    
    _bannerAd = null;
    _interstitialAd = null;
    _rewardedAd = null;
    
    isBannerAdReady.value = false;
    isInterstitialAdReady.value = false;
    isRewardedAdReady.value = false;
    isLoadingAd.value = false;
  }

  /// Dispose the service
  void dispose() {
    disposeAllAds();
  }

  /// Show interstitial ad at specific intervals
  Future<bool> showInterstitialAdAtInterval() async {
    _interstitialAdCounter++;
    
    final interval = _remoteConfigService.getInterstitialAdInterval;
    if (_interstitialAdCounter >= interval) {
      _interstitialAdCounter = 0;
      return await showInterstitialAd();
    }
    
    return false;
  }

  /// Reset interstitial ad counter
  void resetInterstitialAdCounter() {
    _interstitialAdCounter = 0;
  }

  /// Get ad loading widget
  Widget getAdLoadingWidget() {
    return Obx(() {
      if (!isLoadingAd.value) return const SizedBox.shrink();
      
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  /// Get ad status info
  Map<String, dynamic> getAdStatus() {
    return {
      'shouldShowAds': shouldShowAds,
      'isBannerReady': isBannerReady,
      'isInterstitialReady': isInterstitialReady,
      'isRewardedReady': isRewardedReady,
      'isAdLoading': isAdLoading,
      'bannerAdUnitId': _remoteConfigService.getBannerAdUnitId(),
      'interstitialAdUnitId': _remoteConfigService.getInterstitialAdUnitId(),
      'rewardedAdUnitId': _remoteConfigService.getRewardedAdUnitId(),
      'adRefreshInterval': _remoteConfigService.getAdRefreshInterval,
      'interstitialAdInterval': _remoteConfigService.getInterstitialAdInterval,
    };
  }
} 