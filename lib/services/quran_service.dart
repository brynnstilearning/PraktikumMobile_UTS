import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/surat_model.dart';

// QURAN SERVICE (JSON)
// Service untuk load data Al-Quran dari JSON

class QuranService {

  // Load list surat dari JSON
  Future<List<Surat>> loadSuratList() async {
    try {
      final String response = await rootBundle.loadString('assets/data/surat_list.json');
      final List<dynamic> jsonList = jsonDecode(response);
      
      List<Surat> suratList = jsonList.map((json) => Surat.fromJson(json)).toList();
      
      print('✅ Loaded ${suratList.length} surat from JSON');
      
      return suratList;
    } catch (e) {
      print('❌ Error loading surat_list.json: $e');
      return [];
    }
  }

  // Load detail surat (dengan ayat-ayat) dari JSON
  Future<Surat?> loadSuratDetail(int suratNumber) async {
    try {
      
      String fileName = 'surat_${suratNumber}_';
      
      // Mapping nama file (sesuaikan dengan file JSON yang ada)
      switch (suratNumber) {
        case 1:
          fileName += 'al_fatihah.json';
          break;
        case 112:
          fileName += 'al_ikhlas.json';
          break;
        case 113:
          fileName += 'al_falaq.json';
          break;
        case 114:
          fileName += 'an_nas.json';
          break;
        default:
          print('⚠️ Surat $suratNumber belum tersedia');
          return null;
      }
      
      final String response = await rootBundle.loadString('assets/data/$fileName');
      final Map<String, dynamic> json = jsonDecode(response);
      
      Surat surat = Surat.fromJson(json);
      
      print('✅ Loaded surat ${surat.name} dengan ${surat.ayatList?.length ?? 0} ayat');
      
      return surat;
    } catch (e) {
      print('❌ Error loading surat detail: $e');
      return null;
    }
  }

  // Search surat by name
  Future<List<Surat>> searchSurat(String query) async {
    try {
      final allSurat = await loadSuratList();
      final lowerQuery = query.toLowerCase();
      
      return allSurat.where((surat) {
        return surat.name.toLowerCase().contains(lowerQuery) ||
               surat.nameTranslation.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get surat by revelation type
  Future<List<Surat>> getSuratByRevelationType(String type) async {
    try {
      final allSurat = await loadSuratList();
      return allSurat.where((surat) => surat.revelationType == type).toList();
    } catch (e) {
      return [];
    }
  }

  // Get stats (untuk dashboard)
  Future<Map<String, int>> getSuratStats() async {
    try {
      final allSurat = await loadSuratList();
      
      int total = allSurat.length;
      int makkiyyah = allSurat.where((s) => s.revelationType == 'Makkiyyah').length;
      int madaniyyah = allSurat.where((s) => s.revelationType == 'Madaniyyah').length;
      
      return {
        'total': total,
        'makkiyyah': makkiyyah,
        'madaniyyah': madaniyyah,
      };
    } catch (e) {
      return {
        'total': 0,
        'makkiyyah': 0,
        'madaniyyah': 0,
      };
    }
  }
}