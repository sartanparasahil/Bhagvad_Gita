import 'package:get/get.dart';
import '../services/api_service.dart';

class SlokDetailController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final Rx<SlokDetail?> slokDetail = Rx<SlokDetail?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
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