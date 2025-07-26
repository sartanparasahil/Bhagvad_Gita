import 'package:get/get.dart';
import '../../services/ads_service.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../Settings/settings_controller.dart';

class SloksController extends GetxController {
  final AdsService _adsService = AdsService();
  final ApiService _apiService = ApiService();
  
  // Public getter for ads service
  AdsService get adsService => _adsService;
  
  final RxList<Slok> sloks = <Slok>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentChapter = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _adsService.loadBannerAd();
    
    // Listen to language changes
    final settingsController = Get.find<SettingsController>();
    ever(settingsController.selectedLanguage, (_) {
      // Refresh sloks when language changes to update display text
      if (sloks.isNotEmpty) {
        sloks.refresh();
      }
    });
  }

  Future<void> fetchSloks(int chapterNumber) async {
    try {
      print('Fetching sloks for chapter $chapterNumber');
      isLoading.value = true;
      errorMessage.value = '';
      currentChapter.value = chapterNumber;
      
      final List<Slok> fetchedSloks = await _apiService.getSloks(chapterNumber);
      print('Successfully fetched ${fetchedSloks.length} sloks for chapter $chapterNumber');
      sloks.assignAll(fetchedSloks);
    } catch (e) {
      print('Error in fetchSloks for chapter $chapterNumber: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void refreshSloks() {
    if (currentChapter.value > 0) {
      fetchSloks(currentChapter.value);
    }
  }
  
  // Force refresh from API (bypass cache)
  Future<void> forceRefreshSloks() async {
    if (currentChapter.value > 0) {
      try {
        isLoading.value = true;
        errorMessage.value = '';
        
        // Clear cache first
        await StorageService().clearSloksCache(currentChapter.value);
        
        final List<Slok> fetchedSloks = await _apiService.getSloks(currentChapter.value);
        sloks.assignAll(fetchedSloks);
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
} 