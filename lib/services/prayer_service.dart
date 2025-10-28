import 'dart:convert';
import 'package:flutter/services.dart';

// PRAYER SERVICE 
// Service untuk load data waktu sholat dari JSON

class PrayerService {
  // Load prayer times dari JSON file
  Future<Map<String, dynamic>> loadPrayerTimes() async {
    try {
      final String response = await rootBundle.loadString('assets/data/prayer_times.json');
      final data = jsonDecode(response);
      
      print('✅ Prayer times loaded from JSON');
      
      return data;
    } catch (e) {
      print('❌ Error loading prayer_times.json: $e');
      return {};
    }
  }

  // Get prayer times map
  Future<Map<String, String>> getPrayerTimesMap() async {
    final data = await loadPrayerTimes();
    
    if (data.isEmpty || data['prayerTimes'] == null) {
      return {};
    }
    
    return Map<String, String>.from(data['prayerTimes']);
  }

  // Get next prayer info
  Future<Map<String, String>> getNextPrayer() async {
    final data = await loadPrayerTimes();
    
    if (data.isEmpty || data['nextPrayer'] == null) {
      return {'name': 'Maghrib', 'time': '18:00'};
    }
    
    return Map<String, String>.from(data['nextPrayer']);
  }

  // Get city name
  Future<String> getCity() async {
    final data = await loadPrayerTimes();
    return data['city'] ?? 'Malang';
  }

  // Get dates (Gregorian & Hijri)
  Future<Map<String, String>> getDates() async {
    final data = await loadPrayerTimes();
    
    if (data.isEmpty || data['date'] == null) {
      return {
        'gregorian': 'Senin, 20 Oktober 2025',
        'hijri': '13 Rabiul Akhir 1447 H'
      };
    }
    
    return Map<String, String>.from(data['date']);
  }

  // Get prayer time by name (untuk ba'da sholat)
  Future<String> getPrayerTimeByName(String prayerName) async {
    final times = await getPrayerTimesMap();
    
    // Convert "Ba'da Subuh" -> "Subuh"
    final simpleName = prayerName.replaceAll('Ba\'da ', '');
    
    return times[simpleName] ?? '';
  }
}