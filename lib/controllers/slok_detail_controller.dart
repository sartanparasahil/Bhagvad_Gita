import 'package:get/get.dart';
import '../services/api_service.dart';
import '../Screens/Settings/settings_controller.dart';

class SlokDetailController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final Rx<SlokDetail?> slokDetail = Rx<SlokDetail?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
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
} 