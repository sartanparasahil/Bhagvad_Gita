import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void onInit() {
    super.onInit();
    fetchChapters();
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
}
