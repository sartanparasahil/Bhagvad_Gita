import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  var selectedLanguage = 'hindi'.obs; // 'hindi' or 'english'
  var notificationsEnabled = true.obs; // Enable notifications by default
  
  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLanguage.value = prefs.getString('language') ?? 'hindi';
    notificationsEnabled.value = prefs.getBool('notifications_enabled') ?? true;
  }

  Future<void> setLanguage(String language) async {
    selectedLanguage.value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    notificationsEnabled.value = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
  }

  String getTranslation(Map<String, dynamic> commentaries) {
    if (selectedLanguage.value == 'english') {
      // Try to get English translation from various sources
      if (commentaries['prabhu'] != null && commentaries['prabhu']['et'] != null) {
        return commentaries['prabhu']['et'];
      }
      if (commentaries['siva'] != null && commentaries['siva']['et'] != null) {
        return commentaries['siva']['et'];
      }
      if (commentaries['purohit'] != null && commentaries['purohit']['et'] != null) {
        return commentaries['purohit']['et'];
      }
      if (commentaries['chinmay'] != null && commentaries['chinmay']['et'] != null) {
        return commentaries['chinmay']['et'];
      }
      if (commentaries['san'] != null && commentaries['san']['et'] != null) {
        return commentaries['san']['et'];
      }
      if (commentaries['adi'] != null && commentaries['adi']['et'] != null) {
        return commentaries['adi']['et'];
      }
      if (commentaries['gambir'] != null && commentaries['gambir']['et'] != null) {
        return commentaries['gambir']['et'];
      }
      if (commentaries['anand'] != null && commentaries['anand']['et'] != null) {
        return commentaries['anand']['et'];
      }
      if (commentaries['rams'] != null && commentaries['rams']['et'] != null) {
        return commentaries['rams']['et'];
      }
      if (commentaries['raman'] != null && commentaries['raman']['et'] != null) {
        return commentaries['raman']['et'];
      }
      if (commentaries['abhinav'] != null && commentaries['abhinav']['et'] != null) {
        return commentaries['abhinav']['et'];
      }
      if (commentaries['sankar'] != null && commentaries['sankar']['et'] != null) {
        return commentaries['sankar']['et'];
      }
      if (commentaries['jaya'] != null && commentaries['jaya']['et'] != null) {
        return commentaries['jaya']['et'];
      }
      if (commentaries['vallabh'] != null && commentaries['vallabh']['et'] != null) {
        return commentaries['vallabh']['et'];
      }
      if (commentaries['ms'] != null && commentaries['ms']['et'] != null) {
        return commentaries['ms']['et'];
      }
      if (commentaries['srid'] != null && commentaries['srid']['et'] != null) {
        return commentaries['srid']['et'];
      }
      if (commentaries['dhan'] != null && commentaries['dhan']['et'] != null) {
        return commentaries['dhan']['et'];
      }
      if (commentaries['venkat'] != null && commentaries['venkat']['et'] != null) {
        return commentaries['venkat']['et'];
      }
      if (commentaries['puru'] != null && commentaries['puru']['et'] != null) {
        return commentaries['puru']['et'];
      }
      if (commentaries['neel'] != null && commentaries['neel']['et'] != null) {
        return commentaries['neel']['et'];
      }
    } else {
      // Try to get Hindi translation from various sources
      if (commentaries['tej'] != null && commentaries['tej']['ht'] != null) {
        return commentaries['tej']['ht'];
      }
      if (commentaries['chinmay'] != null && commentaries['chinmay']['hc'] != null) {
        return commentaries['chinmay']['hc'];
      }
      if (commentaries['rams'] != null && commentaries['rams']['ht'] != null) {
        return commentaries['rams']['ht'];
      }
      if (commentaries['anand'] != null && commentaries['anand']['sc'] != null) {
        return commentaries['anand']['sc'];
      }
      if (commentaries['madhav'] != null && commentaries['madhav']['sc'] != null) {
        return commentaries['madhav']['sc'];
      }
      if (commentaries['sankar'] != null && commentaries['sankar']['ht'] != null) {
        return commentaries['sankar']['ht'];
      }
      if (commentaries['jaya'] != null && commentaries['jaya']['sc'] != null) {
        return commentaries['jaya']['sc'];
      }
      if (commentaries['vallabh'] != null && commentaries['vallabh']['sc'] != null) {
        return commentaries['vallabh']['sc'];
      }
      if (commentaries['ms'] != null && commentaries['ms']['sc'] != null) {
        return commentaries['ms']['sc'];
      }
      if (commentaries['srid'] != null && commentaries['srid']['sc'] != null) {
        return commentaries['srid']['sc'];
      }
      if (commentaries['dhan'] != null && commentaries['dhan']['sc'] != null) {
        return commentaries['dhan']['sc'];
      }
      if (commentaries['venkat'] != null && commentaries['venkat']['sc'] != null) {
        return commentaries['venkat']['sc'];
      }
      if (commentaries['puru'] != null && commentaries['puru']['sc'] != null) {
        return commentaries['puru']['sc'];
      }
      if (commentaries['neel'] != null && commentaries['neel']['sc'] != null) {
        return commentaries['neel']['sc'];
      }
    }
    
    // Fallback to English if no Hindi translation found
    if (selectedLanguage.value == 'hindi') {
      return getTranslation(commentaries); // This will call the English version
    }
    
    return 'Translation not available';
  }

  String getPurport(Map<String, dynamic> commentaries) {
    if (selectedLanguage.value == 'english') {
      // Try to get English purport from various sources
      if (commentaries['prabhu'] != null && commentaries['prabhu']['ec'] != null) {
        return commentaries['prabhu']['ec'];
      }
      if (commentaries['siva'] != null && commentaries['siva']['ec'] != null) {
        return commentaries['siva']['ec'];
      }
      if (commentaries['chinmay'] != null && commentaries['chinmay']['ec'] != null) {
        return commentaries['chinmay']['ec'];
      }
      if (commentaries['san'] != null && commentaries['san']['ec'] != null) {
        return commentaries['san']['ec'];
      }
      if (commentaries['adi'] != null && commentaries['adi']['ec'] != null) {
        return commentaries['adi']['ec'];
      }
      if (commentaries['gambir'] != null && commentaries['gambir']['ec'] != null) {
        return commentaries['gambir']['ec'];
      }
      if (commentaries['anand'] != null && commentaries['anand']['ec'] != null) {
        return commentaries['anand']['ec'];
      }
      if (commentaries['rams'] != null && commentaries['rams']['ec'] != null) {
        return commentaries['rams']['ec'];
      }
      if (commentaries['raman'] != null && commentaries['raman']['ec'] != null) {
        return commentaries['raman']['ec'];
      }
      if (commentaries['abhinav'] != null && commentaries['abhinav']['ec'] != null) {
        return commentaries['abhinav']['ec'];
      }
      if (commentaries['sankar'] != null && commentaries['sankar']['ec'] != null) {
        return commentaries['sankar']['ec'];
      }
      if (commentaries['jaya'] != null && commentaries['jaya']['ec'] != null) {
        return commentaries['jaya']['ec'];
      }
      if (commentaries['vallabh'] != null && commentaries['vallabh']['ec'] != null) {
        return commentaries['vallabh']['ec'];
      }
      if (commentaries['ms'] != null && commentaries['ms']['ec'] != null) {
        return commentaries['ms']['ec'];
      }
      if (commentaries['srid'] != null && commentaries['srid']['ec'] != null) {
        return commentaries['srid']['ec'];
      }
      if (commentaries['dhan'] != null && commentaries['dhan']['ec'] != null) {
        return commentaries['dhan']['ec'];
      }
      if (commentaries['venkat'] != null && commentaries['venkat']['ec'] != null) {
        return commentaries['venkat']['ec'];
      }
      if (commentaries['puru'] != null && commentaries['puru']['ec'] != null) {
        return commentaries['puru']['ec'];
      }
      if (commentaries['neel'] != null && commentaries['neel']['ec'] != null) {
        return commentaries['neel']['ec'];
      }
    } else {
      // Try to get Hindi purport from various sources
      if (commentaries['chinmay'] != null && commentaries['chinmay']['hc'] != null) {
        return commentaries['chinmay']['hc'];
      }
      if (commentaries['rams'] != null && commentaries['rams']['hc'] != null) {
        return commentaries['rams']['hc'];
      }
      if (commentaries['anand'] != null && commentaries['anand']['sc'] != null) {
        return commentaries['anand']['sc'];
      }
      if (commentaries['madhav'] != null && commentaries['madhav']['sc'] != null) {
        return commentaries['madhav']['sc'];
      }
      if (commentaries['sankar'] != null && commentaries['sankar']['ht'] != null) {
        return commentaries['sankar']['ht'];
      }
      if (commentaries['jaya'] != null && commentaries['jaya']['sc'] != null) {
        return commentaries['jaya']['sc'];
      }
      if (commentaries['vallabh'] != null && commentaries['vallabh']['sc'] != null) {
        return commentaries['vallabh']['sc'];
      }
      if (commentaries['ms'] != null && commentaries['ms']['sc'] != null) {
        return commentaries['ms']['sc'];
      }
      if (commentaries['srid'] != null && commentaries['srid']['sc'] != null) {
        return commentaries['srid']['sc'];
      }
      if (commentaries['dhan'] != null && commentaries['dhan']['sc'] != null) {
        return commentaries['dhan']['sc'];
      }
      if (commentaries['venkat'] != null && commentaries['venkat']['sc'] != null) {
        return commentaries['venkat']['sc'];
      }
      if (commentaries['puru'] != null && commentaries['puru']['sc'] != null) {
        return commentaries['puru']['sc'];
      }
      if (commentaries['neel'] != null && commentaries['neel']['sc'] != null) {
        return commentaries['neel']['sc'];
      }
    }
    
    // Fallback to English if no Hindi purport found
    if (selectedLanguage.value == 'hindi') {
      return getPurport(commentaries); // This will call the English version
    }
    
    return 'Purport not available';
  }
} 