import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import '../../services/ads_service.dart';
import '../../services/remote_config_service.dart';
import '../../widgets/app_update_dialog.dart';

class Chapter {
  final int chapterNumber;
  final String name;
  final String summary;
  final int versesCount;
  final String translation;
  final String transliteration;

  Chapter({
    required this.chapterNumber,
    required this.name,
    required this.summary,
    required this.versesCount,
    required this.translation,
    required this.transliteration,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: json['chapter_number'],
      name: json['name'],
      summary: json['summary']['en'],
      versesCount: json['verses_count'],
      translation: json['translation'],
      transliteration: json['transliteration'],
    );
  }
}

class HomeController extends GetxController {
  var chapters = <Chapter>[].obs;
  var isLoading = true.obs;
  var error = ''.obs;
  final AdsService _adsService = AdsService();

  // Public getter for ads service
  AdsService get adsService => _adsService;

  @override
  void onInit() {
    super.onInit();
    fetchChapters();
    
    // Check for app updates after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      _checkForAppUpdate();
    });
  }

  Future<void> fetchChapters() async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await http.get(Uri.parse('https://vedicscriptures.github.io/chapters'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        chapters.value = data.map((e) => Chapter.fromJson(e)).toList();
      } else {
        error.value = 'Failed to load chapters';
      }
    } catch (e) {
      error.value = 'Error: \\${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void _checkForAppUpdate() async {
    try {
      print('=== APP UPDATE CHECK STARTED ===');
      
      final remoteConfigService = RemoteConfigService();
      final appUpdateService = AppUpdateService();
      
      // Reset dialog flag for testing
      appUpdateService.resetDialogFlag();
      
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      
      // Get remote version and update info
      final remoteVersion = remoteConfigService.getAppVersion;
      final updateMessage = remoteConfigService.getUpdateMessage;
      final isForceUpdate = remoteConfigService.isForceUpdateRequired;
      final updateUrl = remoteConfigService.getUpdateUrl;
      
      print('Checking for app updates...');
      print('Current version: $currentVersion');
      print('Remote version: $remoteVersion');
      print('Force update: $isForceUpdate');
      print('Update message: $updateMessage');
      print('Update URL: $updateUrl');
      
      // Force show update dialog for testing
      print('=== FORCING UPDATE DIALOG FOR TESTING ===');
      appUpdateService.forceShowUpdateDialog(
        currentVersion: '1.0.0', // Force lower version
        newVersion: '1.1.0',  // Force higher version
        updateMessage: 'Test update available! This is a test update dialog.',
        isForceUpdate: false,
        updateUrl: 'https://play.google.com/store/apps/details?id=com.example.bhagvat_geeta',
      );
      
    } catch (e) {
      print('Error checking for app updates: $e');
      print('Stack trace: ${e.toString()}');
    }
  }
}
