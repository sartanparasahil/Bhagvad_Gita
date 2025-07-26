import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'api_service.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late final GetStorage _storage;
  
  // Storage keys
  static const String _chaptersKey = 'chapters';
  static const String _sloksKey = 'sloks_';
  static const String _slokDetailKey = 'slok_detail_';
  static const String _lastUpdatedKey = 'last_updated_';
  
  // Cache expiration time (24 hours)
  static const Duration _cacheExpiration = Duration(hours: 24);

  Future<void> init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  // Chapters caching
  Future<void> cacheChapters(List<Chapter> chapters) async {
    try {
      final chaptersJson = chapters.map((chapter) => _chapterToJson(chapter)).toList();
      await _storage.write(_chaptersKey, chaptersJson);
      await _storage.write('${_lastUpdatedKey}chapters', DateTime.now().toIso8601String());
      print('Chapters cached successfully');
    } catch (e) {
      print('Error caching chapters: $e');
    }
  }

  List<Chapter>? getCachedChapters() {
    try {
      final chaptersJson = _storage.read(_chaptersKey);
      if (chaptersJson != null) {
        final List<dynamic> chaptersList = chaptersJson;
        return chaptersList.map((json) => _chapterFromJson(json)).toList();
      }
      return null;
    } catch (e) {
      print('Error retrieving cached chapters: $e');
      return null;
    }
  }

  bool isChaptersCacheValid() {
    try {
      final lastUpdated = _storage.read('${_lastUpdatedKey}chapters');
      if (lastUpdated == null) return false;
      
      final lastUpdatedTime = DateTime.parse(lastUpdated);
      final now = DateTime.now();
      return now.difference(lastUpdatedTime) < _cacheExpiration;
    } catch (e) {
      print('Error checking chapters cache validity: $e');
      return false;
    }
  }

  // Sloks caching
  Future<void> cacheSloks(int chapterNumber, List<Slok> sloks) async {
    try {
      final sloksJson = sloks.map((slok) => _slokToJson(slok)).toList();
      await _storage.write('${_sloksKey}$chapterNumber', sloksJson);
      await _storage.write('${_lastUpdatedKey}sloks_$chapterNumber', DateTime.now().toIso8601String());
      print('Sloks for chapter $chapterNumber cached successfully');
    } catch (e) {
      print('Error caching sloks for chapter $chapterNumber: $e');
    }
  }

  List<Slok>? getCachedSloks(int chapterNumber) {
    try {
      final sloksJson = _storage.read('${_sloksKey}$chapterNumber');
      if (sloksJson != null) {
        final List<dynamic> sloksList = sloksJson;
        return sloksList.map((json) => _slokFromJson(json)).toList();
      }
      return null;
    } catch (e) {
      print('Error retrieving cached sloks for chapter $chapterNumber: $e');
      return null;
    }
  }

  bool isSloksCacheValid(int chapterNumber) {
    try {
      final lastUpdated = _storage.read('${_lastUpdatedKey}sloks_$chapterNumber');
      if (lastUpdated == null) return false;
      
      final lastUpdatedTime = DateTime.parse(lastUpdated);
      final now = DateTime.now();
      return now.difference(lastUpdatedTime) < _cacheExpiration;
    } catch (e) {
      print('Error checking sloks cache validity for chapter $chapterNumber: $e');
      return false;
    }
  }

  // Slok detail caching
  Future<void> cacheSlokDetail(int chapterNumber, int slokNumber, SlokDetail slokDetail) async {
    try {
      final detailJson = _slokDetailToJson(slokDetail);
      await _storage.write('${_slokDetailKey}${chapterNumber}_$slokNumber', detailJson);
      await _storage.write('${_lastUpdatedKey}slok_detail_${chapterNumber}_$slokNumber', DateTime.now().toIso8601String());
      print('Slok detail for chapter $chapterNumber, slok $slokNumber cached successfully');
    } catch (e) {
      print('Error caching slok detail for chapter $chapterNumber, slok $slokNumber: $e');
    }
  }

  SlokDetail? getCachedSlokDetail(int chapterNumber, int slokNumber) {
    try {
      final detailJson = _storage.read('${_slokDetailKey}${chapterNumber}_$slokNumber');
      if (detailJson != null) {
        return _slokDetailFromJson(detailJson);
      }
      return null;
    } catch (e) {
      print('Error retrieving cached slok detail for chapter $chapterNumber, slok $slokNumber: $e');
      return null;
    }
  }

  bool isSlokDetailCacheValid(int chapterNumber, int slokNumber) {
    try {
      final lastUpdated = _storage.read('${_lastUpdatedKey}slok_detail_${chapterNumber}_$slokNumber');
      if (lastUpdated == null) return false;
      
      final lastUpdatedTime = DateTime.parse(lastUpdated);
      final now = DateTime.now();
      return now.difference(lastUpdatedTime) < _cacheExpiration;
    } catch (e) {
      print('Error checking slok detail cache validity for chapter $chapterNumber, slok $slokNumber: $e');
      return false;
    }
  }

  // Clear cache methods
  Future<void> clearChaptersCache() async {
    await _storage.remove(_chaptersKey);
    await _storage.remove('${_lastUpdatedKey}chapters');
  }

  Future<void> clearSloksCache(int chapterNumber) async {
    await _storage.remove('${_sloksKey}$chapterNumber');
    await _storage.remove('${_lastUpdatedKey}sloks_$chapterNumber');
  }

  Future<void> clearSlokDetailCache(int chapterNumber, int slokNumber) async {
    await _storage.remove('${_slokDetailKey}${chapterNumber}_$slokNumber');
    await _storage.remove('${_lastUpdatedKey}slok_detail_${chapterNumber}_$slokNumber');
  }

  Future<void> clearAllCache() async {
    await _storage.erase();
  }

  // Helper methods to convert models to/from JSON
  Map<String, dynamic> _chapterToJson(Chapter chapter) {
    return {
      'chapterNumber': chapter.chapterNumber,
      'name': chapter.name,
      'translation': chapter.translation,
      'transliteration': chapter.transliteration,
      'meaningEn': chapter.meaningEn,
      'meaningHi': chapter.meaningHi,
      'summaryEn': chapter.summaryEn,
      'summaryHi': chapter.summaryHi,
      'versesCount': chapter.versesCount,
    };
  }

  Chapter _chapterFromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterNumber: json['chapterNumber'] ?? 0,
      name: json['name'] ?? '',
      translation: json['translation'] ?? '',
      transliteration: json['transliteration'] ?? '',
      meaningEn: json['meaningEn'] ?? '',
      meaningHi: json['meaningHi'] ?? '',
      summaryEn: json['summaryEn'] ?? '',
      summaryHi: json['summaryHi'] ?? '',
      versesCount: json['versesCount'] ?? 0,
    );
  }

  Map<String, dynamic> _slokToJson(Slok slok) {
    return {
      'id': slok.id,
      'chapterNumber': slok.chapterNumber,
      'verseNumber': slok.verseNumber,
      'text': slok.text,
      'transliteration': slok.transliteration,
      'wordMeanings': slok.wordMeanings,
      'translation': slok.translation,
      'purport': slok.purport,
      'textHindi': slok.textHindi,
      'textEnglish': slok.textEnglish,
      'translationHindi': slok.translationHindi,
      'translationEnglish': slok.translationEnglish,
    };
  }

  Slok _slokFromJson(Map<String, dynamic> json) {
    return Slok(
      id: json['id'] ?? 0,
      chapterNumber: json['chapterNumber'] ?? 0,
      verseNumber: json['verseNumber'] ?? 0,
      text: json['text'] ?? '',
      transliteration: json['transliteration'] ?? '',
      wordMeanings: json['wordMeanings'] ?? '',
      translation: json['translation'] ?? '',
      purport: json['purport'] ?? '',
      textHindi: json['textHindi'],
      textEnglish: json['textEnglish'],
      translationHindi: json['translationHindi'],
      translationEnglish: json['translationEnglish'],
    );
  }

  Map<String, dynamic> _slokDetailToJson(SlokDetail slokDetail) {
    return {
      'id': slokDetail.id,
      'chapterNumber': slokDetail.chapterNumber,
      'verseNumber': slokDetail.verseNumber,
      'text': slokDetail.text,
      'transliteration': slokDetail.transliteration,
      'wordMeanings': slokDetail.wordMeanings,
      'translation': slokDetail.translation,
      'purport': slokDetail.purport,
      'commentaries': slokDetail.commentaries,
      'textHindi': slokDetail.textHindi,
      'textEnglish': slokDetail.textEnglish,
      'translationHindi': slokDetail.translationHindi,
      'translationEnglish': slokDetail.translationEnglish,
    };
  }

  SlokDetail _slokDetailFromJson(Map<String, dynamic> json) {
    return SlokDetail(
      id: json['id'] ?? 0,
      chapterNumber: json['chapterNumber'] ?? 0,
      verseNumber: json['verseNumber'] ?? 0,
      text: json['text'] ?? '',
      transliteration: json['transliteration'] ?? '',
      wordMeanings: json['wordMeanings'] ?? '',
      translation: json['translation'] ?? '',
      purport: json['purport'] ?? '',
      commentaries: Map<String, dynamic>.from(json['commentaries'] ?? {}),
      textHindi: json['textHindi'],
      textEnglish: json['textEnglish'],
      translationHindi: json['translationHindi'],
      translationEnglish: json['translationEnglish'],
    );
  }
} 