import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://vedicscriptures.github.io',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // Get all chapters
  Future<List<Chapter>> getChapters() async {
    try {
      final response = await _dio.get('/chapters');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Chapter.fromJson(Map<String, dynamic>.from(json))).toList();
      }
      throw Exception('Failed to load chapters');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get all sloks for a chapter by looping through verses
  Future<List<Slok>> getSloks(int chapterNumber) async {
    try {
      List<Slok> sloks = [];
      
      // Get the total number of verses for this chapter
      final versesCount = _getChapterVersesCount(chapterNumber);
      
      // Loop through each verse in the chapter
      for (int verseNumber = 1; verseNumber <= versesCount; verseNumber++) {
        try {
          final slokDetail = await getSlokDetail(chapterNumber, verseNumber);
          sloks.add(Slok(
            id: slokDetail.id,
            chapterNumber: slokDetail.chapterNumber,
            verseNumber: slokDetail.verseNumber,
            text: slokDetail.text,
            transliteration: slokDetail.transliteration,
            wordMeanings: slokDetail.wordMeanings,
            translation: slokDetail.translation,
            purport: slokDetail.purport,
          ));
        } catch (e) {
          print('Error fetching verse $verseNumber: $e');
          // Continue with next verse even if one fails
        }
      }
      
      return sloks;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get specific slok details
  Future<SlokDetail> getSlokDetail(int chapterNumber, int slokNumber) async {
    try {
      final response = await _dio.get('/slok/$chapterNumber/$slokNumber');
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map) {
          return SlokDetail.fromJson(Map<String, dynamic>.from(data));
        } else if (data is String) {
          try {
            final parsed = Map<String, dynamic>.from(jsonDecode(data));
            return SlokDetail.fromJson(parsed);
          } catch (e) {
            throw Exception('Failed to parse string response: $e');
          }
        } else {
          throw Exception('Unexpected response format: ${data.runtimeType}');
        }
      }
      throw Exception('Failed to load slok details');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Helper method to get verse count for each chapter
  int _getChapterVersesCount(int chapterNumber) {
    final Map<int, int> chapterVerses = {
      1: 47, 2: 72, 3: 43, 4: 42, 5: 29, 6: 47, 7: 30, 8: 28, 9: 34, 10: 42,
      11: 55, 12: 20, 13: 35, 14: 27, 15: 20, 16: 24, 17: 28, 18: 78
    };
    return chapterVerses[chapterNumber] ?? 0;
  }
}

// Data Models
class Chapter {
  final int chapterNumber;
  final String name;
  final String translation;
  final String transliteration;
  final Map<String, String> meaning;
  final Map<String, String> summary;

  Chapter({
    required this.chapterNumber,
    required this.name,
    required this.translation,
    required this.transliteration,
    required this.meaning,
    required this.summary,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: _parseInt(json['chapter_number']) ?? 0,
      name: json['name'] ?? '',
      translation: json['translation'] ?? '',
      transliteration: json['transliteration'] ?? '',
      meaning: _convertToStringMap(json['meaning']),
      summary: _convertToStringMap(json['summary']),
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

  // Helper method to convert dynamic map to string map
  static Map<String, String> _convertToStringMap(dynamic map) {
    if (map is Map) {
      return Map<String, String>.from(map.map((key, value) => 
        MapEntry(key.toString(), value.toString())));
    }
    return {};
  }

  // Getter for verses count
  int get versesCount {
    final Map<int, int> chapterVerses = {
      1: 47, 2: 72, 3: 43, 4: 42, 5: 29, 6: 47, 7: 30, 8: 28, 9: 34, 10: 42,
      11: 55, 12: 20, 13: 35, 14: 27, 15: 20, 16: 24, 17: 28, 18: 78
    };
    return chapterVerses[chapterNumber] ?? 0;
  }

  // Getter for name meaning
  String get nameMeaning => meaning['en'] ?? meaning['hi'] ?? '';

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

  Slok({
    required this.id,
    required this.chapterNumber,
    required this.verseNumber,
    required this.text,
    required this.transliteration,
    required this.wordMeanings,
    required this.translation,
    required this.purport,
  });

  factory Slok.fromJson(Map<String, dynamic> json) {
    return Slok(
      id: _parseInt(json['id']) ?? _parseInt(json['verse_number']) ?? 0,
      chapterNumber: _parseInt(json['chapter_number']) ?? 0,
      verseNumber: _parseInt(json['verse_number']) ?? 0,
      text: json['text'] ?? json['slok'] ?? '',
      transliteration: json['transliteration'] ?? '',
      wordMeanings: json['word_meanings'] ?? '',
      translation: json['translation'] ?? '',
      purport: json['purport'] ?? '',
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
} 