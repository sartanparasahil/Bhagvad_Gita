import 'package:get/get.dart';
import '../services/api_service.dart';

class ChaptersController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final RxList<Chapter> chapters = <Chapter>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChapters();
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