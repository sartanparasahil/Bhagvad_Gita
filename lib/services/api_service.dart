import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:get/get.dart';
import '../Screens/Settings/settings_controller.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.bhagvatgeeta.ashutechline.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  final StorageService _storageService = StorageService();

  // Test method to verify API connection
  Future<void> testApiConnection() async {
    try {
      print('Testing API connection...');
      final response = await _dio.get('/api/chapters');
      print('Chapters API response: ${response.statusCode}');
      print('Chapters data: ${response.data}');
      
      final versesResponse = await _dio.get('/api/chapters/1/verses');
      print('Verses API response: ${versesResponse.statusCode}');
      print('Verses data: ${versesResponse.data}');
    } catch (e) {
      print('API connection test failed: $e');
    }
  }

  // Get all chapters
  Future<List<Chapter>> getChapters() async {
    try {
      // First, check if we have valid cached data
      if (_storageService.isChaptersCacheValid()) {
        final cachedChapters = _storageService.getCachedChapters();
        if (cachedChapters != null && cachedChapters.isNotEmpty) {
          print('Loading chapters from cache');
          return cachedChapters;
        }
      }
      
      print('Fetching chapters from API');
      final response = await _dio.get('/api/chapters');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        
        // Check if response has success and data fields
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          final chapters = data.map((json) => Chapter.fromJson(Map<String, dynamic>.from(json))).toList();
          
          // Cache the chapters
          await _storageService.cacheChapters(chapters);
          return chapters;
        } else {
          // Fallback: try to parse as direct array
          if (response.data is List) {
            final List<dynamic> data = response.data;
            final chapters = data.map((json) => Chapter.fromJson(Map<String, dynamic>.from(json))).toList();
            
            // Cache the chapters
            await _storageService.cacheChapters(chapters);
            return chapters;
          }
          throw Exception('Invalid response format');
        }
      }
      throw Exception('Failed to load chapters');
    } catch (e) {
      // If API call fails, try to return cached data even if expired
      print('API call failed, trying to load from cache: $e');
      final cachedChapters = _storageService.getCachedChapters();
      if (cachedChapters != null && cachedChapters.isNotEmpty) {
        print('Loading chapters from expired cache');
        return cachedChapters;
      }
      throw Exception('Error: $e');
    }
  }

  // Get all sloks for a chapter
  Future<List<Slok>> getSloks(int chapterNumber) async {
    try {
      // First, check if we have valid cached data
      if (_storageService.isSloksCacheValid(chapterNumber)) {
        final cachedSloks = _storageService.getCachedSloks(chapterNumber);
        if (cachedSloks != null && cachedSloks.isNotEmpty) {
          print('Loading sloks for chapter $chapterNumber from cache');
          return cachedSloks;
        }
      }
      
      print('Fetching sloks for chapter $chapterNumber from API');
      
      // Get the total verse count for this chapter first
      final chaptersResponse = await _dio.get('/api/chapters');
      int totalVerses = 0;
      
      if (chaptersResponse.statusCode == 200) {
        final Map<String, dynamic> chaptersData = chaptersResponse.data;
        if (chaptersData['success'] == true && chaptersData['data'] != null) {
          final List<dynamic> chapters = chaptersData['data'];
          final chapter = chapters.firstWhere(
            (ch) => ch['chapter_number'] == chapterNumber,
            orElse: () => null,
          );
          if (chapter != null) {
            totalVerses = chapter['verses_count'] ?? 0;
          }
        }
      }
      
      print('Making API call to: /api/chapters/$chapterNumber/verses with count: $totalVerses');
      
      // Try different approaches to get all verses
      List<Slok> allSloks = [];
      
      // Method 1: Try with query parameters
      try {
        final response = await _dio.get(
          '/api/chapters/$chapterNumber/verses',
          queryParameters: {
            'count': totalVerses,
            'limit': totalVerses,
            'verses_count': totalVerses,
            'all': true,
          },
        );
        
        print('Response status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          print('API Response for chapter $chapterNumber: ${response.data}');
          
          // Handle different response formats
          if (response.data is Map<String, dynamic>) {
            final Map<String, dynamic> responseData = response.data;
            
            // Check if response has success and data fields
            if (responseData['success'] == true && responseData['data'] != null) {
              final List<dynamic> data = responseData['data'];
              print('Found ${data.length} verses in chapter $chapterNumber');
              allSloks = data.map((json) => Slok.fromJson(Map<String, dynamic>.from(json))).toList();
            } else if (responseData['data'] != null) {
              // Some APIs might not have success field
              final List<dynamic> data = responseData['data'];
              print('Found ${data.length} verses in chapter $chapterNumber (no success field)');
              allSloks = data.map((json) => Slok.fromJson(Map<String, dynamic>.from(json))).toList();
            }
          }
          
          // Fallback: try to parse as direct array
          if (response.data is List) {
            final List<dynamic> data = response.data;
            print('Found ${data.length} verses in chapter $chapterNumber (direct array)');
            allSloks = data.map((json) => Slok.fromJson(Map<String, dynamic>.from(json))).toList();
          }
        }
      } catch (e) {
        print('Method 1 failed: $e');
      }
      
      // Method 2: If we didn't get all verses, try without parameters
      if (allSloks.length < totalVerses) {
        try {
          print('Trying without parameters to get all verses...');
          final response = await _dio.get('/api/chapters/$chapterNumber/verses');
          
          if (response.statusCode == 200) {
            if (response.data is Map<String, dynamic>) {
              final Map<String, dynamic> responseData = response.data;
              if (responseData['success'] == true && responseData['data'] != null) {
                final List<dynamic> data = responseData['data'];
                print('Found ${data.length} verses in chapter $chapterNumber (method 2)');
                allSloks = data.map((json) => Slok.fromJson(Map<String, dynamic>.from(json))).toList();
              }
            } else if (response.data is List) {
              final List<dynamic> data = response.data;
              print('Found ${data.length} verses in chapter $chapterNumber (method 2, direct array)');
              allSloks = data.map((json) => Slok.fromJson(Map<String, dynamic>.from(json))).toList();
            }
          }
        } catch (e) {
          print('Method 2 failed: $e');
        }
      }
      
      if (allSloks.isNotEmpty) {
        print('Successfully loaded ${allSloks.length} verses for chapter $chapterNumber');
        
        // Cache the sloks
        await _storageService.cacheSloks(chapterNumber, allSloks);
        return allSloks;
      }
      
      print('Failed to load any verses for chapter $chapterNumber');
      throw Exception('Failed to load sloks - no verses found');
    } catch (e) {
      print('Error loading sloks for chapter $chapterNumber: $e');
      
      // If API call fails, try to return cached data even if expired
      final cachedSloks = _storageService.getCachedSloks(chapterNumber);
      if (cachedSloks != null && cachedSloks.isNotEmpty) {
        print('Loading sloks for chapter $chapterNumber from expired cache');
        return cachedSloks;
      }
      
      throw Exception('Error: $e');
    }
  }

  // Get random slok from any chapter
  Future<Map<String, dynamic>> getRandomSlok() async {
    try {
      // Generate random chapter number (1-18)
      final random = DateTime.now().millisecondsSinceEpoch;
      final chapterNumber = (random % 18) + 1;
      
      final response = await _dio.get('/api/random?chapter=$chapterNumber');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return responseData['data'];
        } else {
          throw Exception('Invalid response format');
        }
      }
      throw Exception('Failed to load random slok');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get specific slok details
  Future<SlokDetail> getSlokDetail(int chapterNumber, int slokNumber) async {
    try {
      // First, check if we have valid cached data
      if (_storageService.isSlokDetailCacheValid(chapterNumber, slokNumber)) {
        final cachedDetail = _storageService.getCachedSlokDetail(chapterNumber, slokNumber);
        if (cachedDetail != null) {
          print('Loading slok detail for chapter $chapterNumber, slok $slokNumber from cache');
          return cachedDetail;
        }
      }
      
      print('Fetching slok detail for chapter $chapterNumber, slok $slokNumber from API');
      final response = await _dio.get('/api/verses/$chapterNumber/$slokNumber');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        
        // Check if response has success and data fields
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          final slokDetail = SlokDetail.fromJson(Map<String, dynamic>.from(data));
          
          // Cache the slok detail
          await _storageService.cacheSlokDetail(chapterNumber, slokNumber, slokDetail);
          return slokDetail;
        } else {
          // Fallback: try to parse as direct object
          if (response.data is Map) {
            final slokDetail = SlokDetail.fromJson(Map<String, dynamic>.from(response.data));
            
            // Cache the slok detail
            await _storageService.cacheSlokDetail(chapterNumber, slokNumber, slokDetail);
            return slokDetail;
          } else if (response.data is String) {
            try {
              final parsed = Map<String, dynamic>.from(jsonDecode(response.data));
              final slokDetail = SlokDetail.fromJson(parsed);
              
              // Cache the slok detail
              await _storageService.cacheSlokDetail(chapterNumber, slokNumber, slokDetail);
              return slokDetail;
            } catch (e) {
              throw Exception('Failed to parse string response: $e');
            }
          } else {
            throw Exception('Unexpected response format: ${response.data.runtimeType}');
          }
        }
      }
      throw Exception('Failed to load slok details');
    } catch (e) {
      // If API call fails, try to return cached data even if expired
      print('API call failed, trying to load from cache: $e');
      final cachedDetail = _storageService.getCachedSlokDetail(chapterNumber, slokNumber);
      if (cachedDetail != null) {
        print('Loading slok detail for chapter $chapterNumber, slok $slokNumber from expired cache');
        return cachedDetail;
      }
      throw Exception('Error: $e');
    }
  }
}

// Data Models
class Chapter {
  final int chapterNumber;
  final String name;
  final String translation;
  final String transliteration;
  final String meaningEn;
  final String meaningHi;
  final String summaryEn;
  final String summaryHi;
  final int versesCount;

  Chapter({
    required this.chapterNumber,
    required this.name,
    required this.translation,
    required this.transliteration,
    required this.meaningEn,
    required this.meaningHi,
    required this.summaryEn,
    required this.summaryHi,
    required this.versesCount,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: _parseInt(json['chapter_number']) ?? 0,
      name: json['name'] ?? '',
      translation: json['translation'] ?? '',
      transliteration: json['transliteration'] ?? '',
      meaningEn: json['meaning_en'] ?? '',
      meaningHi: json['meaning_hi'] ?? '',
      summaryEn: json['summary_en'] ?? '',
      summaryHi: json['summary_hi'] ?? '',
      versesCount: _parseInt(json['verses_count']) ?? 0,
    );
  }

  // Helper method to safely parse integers from dynamic values
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Getter for name meaning based on language
  String get nameMeaning {
    final settingsController = Get.find<SettingsController>();
    if (settingsController.selectedLanguage.value == 'english') {
      return meaningEn.isNotEmpty ? meaningEn : name;
    } else {
      return meaningHi.isNotEmpty ? meaningHi : name;
    }
  }

  // Getter for name translated
  String get nameTranslated => translation;

  // Getter for id (same as chapter number)
  int get id => chapterNumber;
}

class Slok {
  final int id;
  final int chapterNumber;
  final int verseNumber;
  final String text;
  final String transliteration;
  final String wordMeanings;
  final String translation;
  final String purport;
  final String? textHindi;
  final String? textEnglish;
  final String? translationHindi;
  final String? translationEnglish;

  Slok({
    required this.id,
    required this.chapterNumber,
    required this.verseNumber,
    required this.text,
    required this.transliteration,
    required this.wordMeanings,
    required this.translation,
    required this.purport,
    this.textHindi,
    this.textEnglish,
    this.translationHindi,
    this.translationEnglish,
  });

  factory Slok.fromJson(Map<String, dynamic> json) {
    return Slok(
      id: _parseInt(json['id']) ?? _parseInt(json['verse_number']) ?? 0,
      chapterNumber: _parseInt(json['chapter_number']) ?? 0,
      verseNumber: _parseInt(json['verse_number']) ?? 0,
      text: json['slok'] ?? json['text'] ?? json['verse'] ?? '',
      transliteration: json['transliteration'] ?? '',
      wordMeanings: json['word_meanings'] ?? '',
      translation: json['translation'] ?? '',
      purport: json['purport'] ?? '',
      textHindi: json['text_hindi'],
      textEnglish: json['text_english'],
      translationHindi: json['translation_hindi'],
      translationEnglish: json['translation_english'],
    );
  }

  // Helper method to safely parse integers from dynamic values
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Getter for text based on language
  String get displayText {
    final settingsController = Get.find<SettingsController>();
    if (settingsController.selectedLanguage.value == 'english') {
      return textEnglish ?? text;
    } else {
      return textHindi ?? text;
    }
  }

  // Getter for translation based on language
  String get displayTranslation {
    final settingsController = Get.find<SettingsController>();
    if (settingsController.selectedLanguage.value == 'english') {
      return translationEnglish ?? translation;
    } else {
      return translationHindi ?? translation;
    }
  }
}

class SlokDetail {
  final int id;
  final int chapterNumber;
  final int verseNumber;
  final String text;
  final String transliteration;
  final String wordMeanings;
  final String translation;
  final String purport;
  final Map<String, dynamic> commentaries;
  final String? textHindi;
  final String? textEnglish;
  final String? translationHindi;
  final String? translationEnglish;

  SlokDetail({
    required this.id,
    required this.chapterNumber,
    required this.verseNumber,
    required this.text,
    required this.transliteration,
    required this.wordMeanings,
    required this.translation,
    required this.purport,
    required this.commentaries,
    this.textHindi,
    this.textEnglish,
    this.translationHindi,
    this.translationEnglish,
  });

  factory SlokDetail.fromJson(Map<String, dynamic> json) {
    return SlokDetail(
      id: _parseInt(json['_id']) ?? _parseInt(json['verse_number']) ?? 0,
      chapterNumber: _parseInt(json['chapter']) ?? 0,
      verseNumber: _parseInt(json['verse']) ?? 0,
      text: json['slok'] ?? '',
      transliteration: json['transliteration'] ?? '',
      wordMeanings: '', // Not available in this API
      translation: _extractTranslation(json),
      purport: _extractPurport(json),
      commentaries: Map<String, dynamic>.from(json),
      textHindi: json['text_hindi'],
      textEnglish: json['text_english'],
      translationHindi: json['translation_hindi'],
      translationEnglish: json['translation_english'],
    );
  }

  // Helper method to safely parse integers from dynamic values
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Extract translation from commentaries
  static String _extractTranslation(Map<String, dynamic> json) {
    // This will be handled by SettingsController
    return '';
  }

  // Extract purport from commentaries
  static String _extractPurport(Map<String, dynamic> json) {
    // This will be handled by SettingsController
    return '';
  }

  // Getter for text based on language
  String get displayText {
    final settingsController = Get.find<SettingsController>();
    if (settingsController.selectedLanguage.value == 'english') {
      return textEnglish ?? text;
    } else {
      return textHindi ?? text;
    }
  }

  // Getter for translation based on language
  String get displayTranslation {
    final settingsController = Get.find<SettingsController>();
    if (settingsController.selectedLanguage.value == 'english') {
      return translationEnglish ?? translation;
    } else {
      return translationHindi ?? translation;
    }
  }
} 