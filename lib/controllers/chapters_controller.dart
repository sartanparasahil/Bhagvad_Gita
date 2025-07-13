import 'package:get/get.dart';
import '../services/api_service.dart';
import '../Screens/Settings/settings_controller.dart';

class ChaptersController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final RxList<Chapter> chapters = <Chapter>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
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

  void refreshChapters() {
    fetchChapters();
  }
} 