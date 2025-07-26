import 'package:get/get.dart';
import '../../services/ads_service.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../Settings/settings_controller.dart';

class SlokDetailController extends GetxController {
  final AdsService _adsService = AdsService();
  final ApiService _apiService = ApiService();
  
  // Public getter for ads service
  AdsService get adsService => _adsService;
  
  final Rx<SlokDetail?> slokDetail = Rx<SlokDetail?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _adsService.loadBannerAd();
    
    // Listen to language changes
    final settingsController = Get.find<SettingsController>();
    ever(settingsController.selectedLanguage, (_) {
      // Refresh slok detail when language changes to update display text
      if (slokDetail.value != null) {
        slokDetail.refresh();
      }
    });
  }

  Future<void> fetchSlokDetail(int chapterNumber, int slokNumber) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final SlokDetail detail = await _apiService.getSlokDetail(chapterNumber, slokNumber);
      slokDetail.value = detail;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clearDetail() {
    slokDetail.value = null;
    errorMessage.value = '';
  }
  
  // Force refresh from API (bypass cache)
  Future<void> forceRefreshSlokDetail(int chapterNumber, int slokNumber) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Clear cache first
      await StorageService().clearSlokDetailCache(chapterNumber, slokNumber);
      
      final SlokDetail detail = await _apiService.getSlokDetail(chapterNumber, slokNumber);
      slokDetail.value = detail;
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