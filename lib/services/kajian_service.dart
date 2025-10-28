import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/kajian_model.dart';

// KAJIAN SERVICE
// Service untuk load data kajian dari JSON 

class KajianService {

  // Load kajian dari JSON file
  Future<List<Kajian>> loadKajian() async {
    try {
      final String response = await rootBundle.loadString('assets/data/kajian.json');
      final List<dynamic> jsonList = jsonDecode(response);
      
      List<Kajian> kajianList = jsonList.map((json) => Kajian.fromJson(json)).toList();
      
      print('✅ Loaded ${kajianList.length} kajian from JSON');
      
      return kajianList;
    } catch (e) {
      print('❌ Error loading kajian.json: $e');
      return [];
    }
  }

  // Get upcoming kajian (yang akan datang)
  Future<List<Kajian>> getUpcomingKajian() async {
    try {
      final allKajian = await loadKajian();
      return allKajian.where((kajian) => kajian.status == 'upcoming').toList();
    } catch (e) {
      return [];
    }
  }

  // Get past kajian (yang sudah lewat)
  Future<List<Kajian>> getPastKajian() async {
    try {
      final allKajian = await loadKajian();
      return allKajian.where((kajian) => kajian.status == 'past').toList();
    } catch (e) {
      return [];
    }
  }

  // Get kajian by category
  Future<List<Kajian>> getKajianByCategory(String category) async {
    try {
      final allKajian = await loadKajian();
      return allKajian.where((kajian) => kajian.category == category).toList();
    } catch (e) {
      return [];
    }
  }

  // Search kajian by title/ustadz/theme
  Future<List<Kajian>> searchKajian(String query) async {
    try {
      final allKajian = await loadKajian();
      final lowerQuery = query.toLowerCase();
      
      return allKajian.where((kajian) {
        return kajian.title.toLowerCase().contains(lowerQuery) ||
               kajian.ustadz.toLowerCase().contains(lowerQuery) ||
               kajian.theme.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get kajian by date
  Future<List<Kajian>> getKajianByDate(String date) async {
    try {
      final allKajian = await loadKajian();
      return allKajian.where((kajian) => kajian.date == date).toList();
    } catch (e) {
      return [];
    }
  }

  // Get kajian count by status
  Future<Map<String, int>> getKajianStats() async {
    try {
      final allKajian = await loadKajian();
      
      int total = allKajian.length;
      int upcoming = allKajian.where((k) => k.status == 'upcoming').length;
      int past = allKajian.where((k) => k.status == 'past').length;
      
      return {
        'total': total,
        'upcoming': upcoming,
        'past': past,
      };
    } catch (e) {
      return {
        'total': 0,
        'upcoming': 0,
        'past': 0,
      };
    }
  }
}