import 'package:get/get.dart';
import '../services/api_service.dart';

class SloksController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final RxList<Slok> sloks = <Slok>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentChapter = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchSloks(int chapterNumber) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentChapter.value = chapterNumber;
      
      final List<Slok> fetchedSloks = await _apiService.getSloks(chapterNumber);
      sloks.assignAll(fetchedSloks);
    } catch (e) {
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
} 