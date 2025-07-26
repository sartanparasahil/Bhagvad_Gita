import 'package:get/get.dart';
import '../../services/ads_service.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../Settings/settings_controller.dart';

class ChaptersController extends GetxController {
  final AdsService _adsService = AdsService();
  final ApiService _apiService = ApiService();
  
  // Public getter for ads service
  AdsService get adsService => _adsService;
  
  final RxList<Chapter> chapters = <Chapter>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _adsService.loadBannerAd();
    
    // Test API connection
    _apiService.testApiConnection();
    
    fetchChapters();
    
    // Listen to language changes
    final settingsController = Get.find<SettingsController>();
    ever(settingsController.selectedLanguage, (_) {
      // Refresh chapters when language changes to update display text
      if (chapters.isNotEmpty) {
        chapters.refresh();
      }
    });
  }

  Future<void> fetchChapters() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final List<Chapter> fetchedChapters = await _apiService.getChapters();
      chapters.assignAll(fetchedChapters);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

   refreshChapters() {
    fetchChapters();
  }
  
  // Force refresh from API (bypass cache)
  Future<void> forceRefreshChapters() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Clear cache first
      await StorageService().clearChaptersCache();
      
      final List<Chapter> fetchedChapters = await _apiService.getChapters();
      chapters.assignAll(fetchedChapters);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
} 