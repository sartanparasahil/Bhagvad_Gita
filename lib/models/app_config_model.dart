import 'dart:convert';

class AppConfigModel {
  final bool showAds;
  final String bannerAdUnitId;
  final String androidBannerAdUnitId;
  final String iosBannerAdUnitId;
  final String interstitialAdUnitId;
  final String androidInterstitialAdUnitId;
  final String iosInterstitialAdUnitId;
  final String rewardedAdUnitId;
  final String androidRewardedAdUnitId;
  final String iosRewardedAdUnitId;
  final String appVersion;
  final bool maintenanceMode;
  final String maintenanceMessage;
  final int adRefreshInterval;
  final int interstitialAdInterval;
  final Map<String, dynamic> featureFlags;
  
  // App Update fields
  final bool forceUpdate;
  final String updateMessage;
  final String updateUrl;

  AppConfigModel({
    required this.showAds,
    required this.bannerAdUnitId,
    required this.androidBannerAdUnitId,
    required this.iosBannerAdUnitId,
    required this.interstitialAdUnitId,
    required this.androidInterstitialAdUnitId,
    required this.iosInterstitialAdUnitId,
    required this.rewardedAdUnitId,
    required this.androidRewardedAdUnitId,
    required this.iosRewardedAdUnitId,
    required this.appVersion,
    required this.maintenanceMode,
    required this.maintenanceMessage,
    required this.adRefreshInterval,
    required this.interstitialAdInterval,
    required this.featureFlags,
    required this.forceUpdate,
    required this.updateMessage,
    required this.updateUrl,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      showAds: json['show_ads'] ?? false,
      bannerAdUnitId: json['banner_ad_unit_id'] ?? '',
      androidBannerAdUnitId: json['android_banner_ad_unit_id'] ?? '',
      iosBannerAdUnitId: json['ios_banner_ad_unit_id'] ?? '',
      interstitialAdUnitId: json['interstitial_ad_unit_id'] ?? '',
      androidInterstitialAdUnitId: json['android_interstitial_ad_unit_id'] ?? '',
      iosInterstitialAdUnitId: json['ios_interstitial_ad_unit_id'] ?? '',
      rewardedAdUnitId: json['rewarded_ad_unit_id'] ?? '',
      androidRewardedAdUnitId: json['android_rewarded_ad_unit_id'] ?? '',
      iosRewardedAdUnitId: json['ios_rewarded_ad_unit_id'] ?? '',
      appVersion: json['app_version'] ?? '1.0.0',
      maintenanceMode: json['maintenance_mode'] ?? false,
      maintenanceMessage: json['maintenance_message'] ?? 'App is under maintenance. Please try again later.',
      adRefreshInterval: json['ad_refresh_interval'] ?? 300,
      interstitialAdInterval: json['interstitial_ad_interval'] ?? 5,
      featureFlags: json['feature_flags'] is String 
          ? _parseFeatureFlags(json['feature_flags'])
          : json['feature_flags'] ?? {},
      forceUpdate: json['force_update'] ?? false,
      updateMessage: json['update_message'] ?? 'A new version of the app is available with bug fixes and improvements.',
      updateUrl: json['update_url'] ?? '',
    );
  }

  static Map<String, dynamic> _parseFeatureFlags(String featureFlagsJson) {
    try {
      return Map<String, dynamic>.from(
        jsonDecode(featureFlagsJson) as Map,
      );
    } catch (e) {
      print('Error parsing feature flags: $e');
      return {};
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'show_ads': showAds,
      'banner_ad_unit_id': bannerAdUnitId,
      'android_banner_ad_unit_id': androidBannerAdUnitId,
      'ios_banner_ad_unit_id': iosBannerAdUnitId,
      'interstitial_ad_unit_id': interstitialAdUnitId,
      'android_interstitial_ad_unit_id': androidInterstitialAdUnitId,
      'ios_interstitial_ad_unit_id': iosInterstitialAdUnitId,
      'rewarded_ad_unit_id': rewardedAdUnitId,
      'android_rewarded_ad_unit_id': androidRewardedAdUnitId,
      'ios_rewarded_ad_unit_id': iosRewardedAdUnitId,
      'app_version': appVersion,
      'maintenance_mode': maintenanceMode,
      'maintenance_message': maintenanceMessage,
      'ad_refresh_interval': adRefreshInterval,
      'interstitial_ad_interval': interstitialAdInterval,
      'feature_flags': featureFlags,
      'force_update': forceUpdate,
      'update_message': updateMessage,
      'update_url': updateUrl,
    };
  }

  // Platform-specific getters
  String getBannerAdUnitId(String platform) {
    switch (platform.toLowerCase()) {
      case 'android':
        return androidBannerAdUnitId.isNotEmpty ? androidBannerAdUnitId : bannerAdUnitId;
      case 'ios':
        return iosBannerAdUnitId.isNotEmpty ? iosBannerAdUnitId : bannerAdUnitId;
      default:
        return bannerAdUnitId;
    }
  }

  String getInterstitialAdUnitId(String platform) {
    switch (platform.toLowerCase()) {
      case 'android':
        return androidInterstitialAdUnitId.isNotEmpty ? androidInterstitialAdUnitId : interstitialAdUnitId;
      case 'ios':
        return iosInterstitialAdUnitId.isNotEmpty ? iosInterstitialAdUnitId : interstitialAdUnitId;
      default:
        return interstitialAdUnitId;
    }
  }

  String getRewardedAdUnitId(String platform) {
    switch (platform.toLowerCase()) {
      case 'android':
        return androidRewardedAdUnitId.isNotEmpty ? androidRewardedAdUnitId : rewardedAdUnitId;
      case 'ios':
        return iosRewardedAdUnitId.isNotEmpty ? iosRewardedAdUnitId : rewardedAdUnitId;
      default:
        return rewardedAdUnitId;
    }
  }

  // Feature flag getter
  bool getFeatureFlag(String key, {bool defaultValue = false}) {
    return featureFlags[key] ?? defaultValue;
  }

  // Copy with method for updates
  AppConfigModel copyWith({
    bool? showAds,
    String? bannerAdUnitId,
    String? androidBannerAdUnitId,
    String? iosBannerAdUnitId,
    String? interstitialAdUnitId,
    String? androidInterstitialAdUnitId,
    String? iosInterstitialAdUnitId,
    String? rewardedAdUnitId,
    String? androidRewardedAdUnitId,
    String? iosRewardedAdUnitId,
    String? appVersion,
    bool? maintenanceMode,
    String? maintenanceMessage,
    int? adRefreshInterval,
    int? interstitialAdInterval,
    Map<String, dynamic>? featureFlags,
    bool? forceUpdate,
    String? updateMessage,
    String? updateUrl,
  }) {
    return AppConfigModel(
      showAds: showAds ?? this.showAds,
      bannerAdUnitId: bannerAdUnitId ?? this.bannerAdUnitId,
      androidBannerAdUnitId: androidBannerAdUnitId ?? this.androidBannerAdUnitId,
      iosBannerAdUnitId: iosBannerAdUnitId ?? this.iosBannerAdUnitId,
      interstitialAdUnitId: interstitialAdUnitId ?? this.interstitialAdUnitId,
      androidInterstitialAdUnitId: androidInterstitialAdUnitId ?? this.androidInterstitialAdUnitId,
      iosInterstitialAdUnitId: iosInterstitialAdUnitId ?? this.iosInterstitialAdUnitId,
      rewardedAdUnitId: rewardedAdUnitId ?? this.rewardedAdUnitId,
      androidRewardedAdUnitId: androidRewardedAdUnitId ?? this.androidRewardedAdUnitId,
      iosRewardedAdUnitId: iosRewardedAdUnitId ?? this.iosRewardedAdUnitId,
      appVersion: appVersion ?? this.appVersion,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      maintenanceMessage: maintenanceMessage ?? this.maintenanceMessage,
      adRefreshInterval: adRefreshInterval ?? this.adRefreshInterval,
              interstitialAdInterval: interstitialAdInterval ?? this.interstitialAdInterval,
        featureFlags: featureFlags ?? this.featureFlags,
        forceUpdate: forceUpdate ?? this.forceUpdate,
        updateMessage: updateMessage ?? this.updateMessage,
        updateUrl: updateUrl ?? this.updateUrl,
    );
  }

  @override
  String toString() {
    return 'AppConfigModel(showAds: $showAds, bannerAdUnitId: $bannerAdUnitId, appVersion: $appVersion, maintenanceMode: $maintenanceMode)';
  }
} 