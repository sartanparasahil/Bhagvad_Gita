import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../models/app_config_model.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  late final FirebaseRemoteConfig _remoteConfig;
  
  // Remote Config Keys
  static const String _showAdsKey = 'show_ads';
  static const String _bannerAdUnitIdKey = 'banner_ad_unit_id';
  static const String _androidBannerAdUnitIdKey = 'android_banner_ad_unit_id';
  static const String _iosBannerAdUnitIdKey = 'ios_banner_ad_unit_id';
  static const String _interstitialAdUnitIdKey = 'interstitial_ad_unit_id';
  static const String _androidInterstitialAdUnitIdKey = 'android_interstitial_ad_unit_id';
  static const String _iosInterstitialAdUnitIdKey = 'ios_interstitial_ad_unit_id';
  static const String _rewardedAdUnitIdKey = 'rewarded_ad_unit_id';
  static const String _androidRewardedAdUnitIdKey = 'android_rewarded_ad_unit_id';
  static const String _iosRewardedAdUnitIdKey = 'ios_rewarded_ad_unit_id';
  static const String _appVersionKey = 'app_version';
  static const String _maintenanceModeKey = 'maintenance_mode';
  static const String _maintenanceMessageKey = 'maintenance_message';
  static const String _featureFlagsKey = 'feature_flags';
  static const String _adRefreshIntervalKey = 'ad_refresh_interval';
  static const String _interstitialAdIntervalKey = 'interstitial_ad_interval';
  
  // App Update Keys
  static const String _forceUpdateKey = 'force_update';
  static const String _updateMessageKey = 'update_message';
  static const String _updateUrlKey = 'update_url';
  
  // Default values
  static const Map<String, dynamic> _defaultValues = {
    'show_ads': false,
    'banner_ad_unit_id': 'ca-app-pub-3940256099942544/9214589741', // Test ad unit ID
    'android_banner_ad_unit_id': 'ca-app-pub-3940256099942544/9214589741', // Test ad unit ID
    'ios_banner_ad_unit_id': 'ca-app-pub-3940256099942544/2934735716', // Test ad unit ID
    'interstitial_ad_unit_id': 'ca-app-pub-3940256099942544/1033173712', // Test ad unit ID
    'android_interstitial_ad_unit_id': 'ca-app-pub-3940256099942544/1033173712', // Test ad unit ID
    'ios_interstitial_ad_unit_id': 'ca-app-pub-3940256099942544/4411468910', // Test ad unit ID
    'rewarded_ad_unit_id': 'ca-app-pub-3940256099942544/5224354917', // Test ad unit ID
    'android_rewarded_ad_unit_id': 'ca-app-pub-3940256099942544/5224354917', // Test ad unit ID
    'ios_rewarded_ad_unit_id': 'ca-app-pub-3940256099942544/1712485313', // Test ad unit ID
    'app_version': '1.0.0',
    'maintenance_mode': false,
    'maintenance_message': 'App is under maintenance. Please try again later.',
    'feature_flags': '{}',
    'ad_refresh_interval': 300, // 5 minutes in seconds
    'interstitial_ad_interval': 5, // Show interstitial every 5 actions
    'force_update': false,
    'update_message': 'A new version of the app is available with bug fixes and improvements.',
    'update_url': '',
  };

  // Observable config model
  final Rx<AppConfigModel?> appConfig = Rx<AppConfigModel?>(null);

  /// Initialize Remote Config
  Future<void> init() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      
      // Set minimum fetch interval (for development)
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 10),
      ));

      // Set default values
      await _remoteConfig.setDefaults(_defaultValues);

      // Fetch and activate
      await fetchAndActivate();

      // Listen for config updates
      _remoteConfig.onConfigUpdated.listen((event) {
        _updateObservableValues();
      });

      print('Remote Config initialized successfully');
    } catch (e) {
      print('Error initializing Remote Config: $e');
      // Set default values if initialization fails
      _setDefaultObservableValues();
    }
  }

  /// Fetch and activate remote config values
  Future<bool> fetchAndActivate() async {
    try {
      final bool updated = await _remoteConfig.fetchAndActivate();
      if (updated) {
        print('Remote Config updated successfully');
      }
      
      _updateObservableValues();
      return updated;
    } catch (e) {
      print('Error fetching Remote Config: $e');
      _setDefaultObservableValues();
      return false;
    }
  }

  /// Update observable values from remote config
  void _updateObservableValues() {
    try {
      Map remoteJson = jsonDecode(_remoteConfig.getString(_showAdsKey));
      final Map<String, dynamic> configMap = {
        'show_ads': remoteJson["show_ads"],
        'banner_ad_unit_id': remoteJson['banner_ad_unit_id'],
        'android_banner_ad_unit_id': remoteJson['android_banner_ad_unit_id'],
        'ios_banner_ad_unit_id': remoteJson['ios_banner_ad_unit_id'],
        'interstitial_ad_unit_id': remoteJson['interstitial_ad_unit_id'],
        'android_interstitial_ad_unit_id': remoteJson['android_interstitial_ad_unit_id'],
        'ios_interstitial_ad_unit_id': remoteJson['ios_interstitial_ad_unit_id'],
        'rewarded_ad_unit_id': remoteJson['rewarded_ad_unit_id'],
        'android_rewarded_ad_unit_id': remoteJson['android_rewarded_ad_unit_id'],
        'ios_rewarded_ad_unit_id': remoteJson['ios_rewarded_ad_unit_id'],
        'app_version': remoteJson['app_version'],
        'maintenance_mode': remoteJson['maintenance_mode'],
        'maintenance_message': remoteJson['maintenance_message'],
        'ad_refresh_interval': remoteJson['ad_refresh_interval'],
        'interstitial_ad_interval': remoteJson['interstitial_ad_interval'],
        'feature_flags': remoteJson['feature_flags'],
        'force_update': remoteJson['force_update'],
        'update_message': remoteJson['update_message'],
        'update_url': remoteJson['update_url'],
      };
      // Create AppConfigModel from map
      appConfig.value = AppConfigModel.fromJson(configMap);
      
      print('Remote Config values updated with model');
    } catch (e) {
      print('Error updating observable values: $e');
      _setDefaultObservableValues();
    }
  }

  /// Set default observable values
  void _setDefaultObservableValues() {
    appConfig.value = AppConfigModel.fromJson(_defaultValues);
  }

  /// Get banner ad unit ID based on platform
  String getBannerAdUnitId() {
    final config = appConfig.value;
    if (config == null) return _defaultValues[_bannerAdUnitIdKey] as String;
    
    if (GetPlatform.isAndroid) {
      return config.getBannerAdUnitId('android');
    } else if (GetPlatform.isIOS) {
      return config.getBannerAdUnitId('ios');
    } else {
      return config.bannerAdUnitId;
    }
  }

  /// Get interstitial ad unit ID based on platform
  String getInterstitialAdUnitId() {
    final config = appConfig.value;
    if (config == null) return _defaultValues[_interstitialAdUnitIdKey] as String;
    
    if (GetPlatform.isAndroid) {
      return config.getInterstitialAdUnitId('android');
    } else if (GetPlatform.isIOS) {
      return config.getInterstitialAdUnitId('ios');
    } else {
      return config.interstitialAdUnitId;
    }
  }

  /// Get rewarded ad unit ID based on platform
  String getRewardedAdUnitId() {
    final config = appConfig.value;
    if (config == null) return _defaultValues[_rewardedAdUnitIdKey] as String;
    
    if (GetPlatform.isAndroid) {
      return config.getRewardedAdUnitId('android');
    } else if (GetPlatform.isIOS) {
      return config.getRewardedAdUnitId('ios');
    } else {
      return config.rewardedAdUnitId;
    }
  }

  /// Check if a specific feature is enabled
  bool isFeatureEnabled(String featureName) {
    final config = appConfig.value;
    if (config == null) return false;
    return config.getFeatureFlag(featureName);
  }

  /// Get feature flag value
  dynamic getFeatureFlag(String featureName) {
    final config = appConfig.value;
    if (config == null) return null;
    return config.getFeatureFlag(featureName);
  }

  /// Check if app is in maintenance mode
  bool get isInMaintenanceMode {
    final config = appConfig.value;
    return config?.maintenanceMode ?? false;
  }

  /// Get maintenance message
  String get getMaintenanceMessage {
    final config = appConfig.value;
    return config?.maintenanceMessage ?? 'App is under maintenance. Please try again later.';
  }

  /// Check if ads should be shown
  bool get shouldShowAds {
    final config = appConfig.value;
    final showAds = config?.showAds ?? false;
    
    // Log the show_ads value for debugging
    print('Remote Config show_ads value: $showAds');
    
    return showAds;
  }

  /// Get app version from remote config
  String get getAppVersion {
    final config = appConfig.value;
    return config?.appVersion ?? '1.0.0';
  }

  /// Get ad refresh interval in seconds
  int get getAdRefreshInterval {
    final config = appConfig.value;
    return config?.adRefreshInterval ?? 300;
  }

  /// Get interstitial ad interval
  int get getInterstitialAdInterval {
    final config = appConfig.value;
    return config?.interstitialAdInterval ?? 5;
  }

  /// Check if force update is required
  bool get isForceUpdateRequired {
    final config = appConfig.value;
    return config?.forceUpdate ?? false;
  }

  /// Get update message
  String get getUpdateMessage {
    final config = appConfig.value;
    return config?.updateMessage ?? 'A new version of the app is available with bug fixes and improvements.';
  }

  /// Get update URL
  String get getUpdateUrl {
    final config = appConfig.value;
    return config?.updateUrl ?? '';
  }

  /// Force refresh remote config
  Future<void> forceRefresh() async {
    await fetchAndActivate();
  }

  /// Get all remote config values as a map
  Map<String, dynamic> getAllValues() {
    final config = appConfig.value;
    if (config == null) return _defaultValues;
    
    return {
      'showAds': config.showAds,
      'bannerAdUnitId': config.bannerAdUnitId,
      'androidBannerAdUnitId': config.androidBannerAdUnitId,
      'iosBannerAdUnitId': config.iosBannerAdUnitId,
      'interstitialAdUnitId': config.interstitialAdUnitId,
      'androidInterstitialAdUnitId': config.androidInterstitialAdUnitId,
      'iosInterstitialAdUnitId': config.iosInterstitialAdUnitId,
      'rewardedAdUnitId': config.rewardedAdUnitId,
      'androidRewardedAdUnitId': config.androidRewardedAdUnitId,
      'iosRewardedAdUnitId': config.iosRewardedAdUnitId,
      'appVersion': config.appVersion,
      'maintenanceMode': config.maintenanceMode,
      'maintenanceMessage': config.maintenanceMessage,
      'featureFlags': config.featureFlags,
      'adRefreshInterval': config.adRefreshInterval,
      'interstitialAdInterval': config.interstitialAdInterval,
    };
  }

  /// Get raw JSON from Remote Config
  String getRawJson() {
    final config = appConfig.value;
    if (config == null) {
      // Return default values as JSON
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(_defaultValues);
    }
    
    // Return config model as JSON
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(config.toJson());
  }

  /// Get raw Remote Config values (before model conversion)
  Map<String, dynamic> getRawRemoteConfigValues() {
    try {
      return {
        'show_ads': _remoteConfig.getBool(_showAdsKey),
        'banner_ad_unit_id': _remoteConfig.getString(_bannerAdUnitIdKey),
        'android_banner_ad_unit_id': _remoteConfig.getString(_androidBannerAdUnitIdKey),
        'ios_banner_ad_unit_id': _remoteConfig.getString(_iosBannerAdUnitIdKey),
        'interstitial_ad_unit_id': _remoteConfig.getString(_interstitialAdUnitIdKey),
        'android_interstitial_ad_unit_id': _remoteConfig.getString(_androidInterstitialAdUnitIdKey),
        'ios_interstitial_ad_unit_id': _remoteConfig.getString(_iosInterstitialAdUnitIdKey),
        'rewarded_ad_unit_id': _remoteConfig.getString(_rewardedAdUnitIdKey),
        'android_rewarded_ad_unit_id': _remoteConfig.getString(_androidRewardedAdUnitIdKey),
        'ios_rewarded_ad_unit_id': _remoteConfig.getString(_iosRewardedAdUnitIdKey),
        'app_version': _remoteConfig.getString(_appVersionKey),
        'maintenance_mode': _remoteConfig.getBool(_maintenanceModeKey),
        'maintenance_message': _remoteConfig.getString(_maintenanceMessageKey),
        'ad_refresh_interval': _remoteConfig.getInt(_adRefreshIntervalKey),
        'interstitial_ad_interval': _remoteConfig.getInt(_interstitialAdIntervalKey),
        'feature_flags': _remoteConfig.getString(_featureFlagsKey),
      };
    } catch (e) {
      print('Error getting raw remote config values: $e');
      return _defaultValues;
    }
  }

  /// Validate show_ads key specifically
  bool validateShowAdsKey() {
    try {
      final rawShowAds = _remoteConfig.getBool(_showAdsKey);
      final configShowAds = appConfig.value?.showAds ?? false;
      
      print('Raw Remote Config show_ads: $rawShowAds');
      print('Model show_ads: $configShowAds');
      
      // Check if the values match
      if (rawShowAds != configShowAds) {
        print('WARNING: show_ads values do not match! Raw: $rawShowAds, Model: $configShowAds');
        return false;
      }
      
      print('show_ads validation passed: $rawShowAds');
      return true;
    } catch (e) {
      print('Error validating show_ads key: $e');
      return false;
    }
  }

  /// Get show_ads value with detailed logging
  Map<String, dynamic> getShowAdsDebugInfo() {
    try {
      final rawShowAds = _remoteConfig.getBool(_showAdsKey);
      final configShowAds = appConfig.value?.showAds ?? false;
      final shouldShowAds = this.shouldShowAds;
      
      return {
        'raw_remote_config_show_ads': rawShowAds,
        'model_show_ads': configShowAds,
        'should_show_ads_getter': shouldShowAds,
        'is_valid': rawShowAds == configShowAds,
        'default_value': _defaultValues[_showAdsKey] as bool,
        'key_name': _showAdsKey,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'key_name': _showAdsKey,
      };
    }
  }

  /// Dispose resources
  void dispose() {
    // Clean up any resources if needed
  }
} 