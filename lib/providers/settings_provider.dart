
// SETTINGS PROVIDER
// State management untuk settings (theme, language, city)

import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../config/constants.dart';


class SettingsProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  ThemeMode _themeMode = ThemeMode.light;
  String _language = 'id'; // 'id' atau 'en'
  String _selectedCity = AppConstants.defaultCity;

  // Getters
  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  String get selectedCity => _selectedCity;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Initialize (load saved settings)
  Future<void> init() async {
    await _storageService.init();
    
    // Load theme mode
    final savedTheme = _storageService.getThemeMode();
    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    
    // Load language
    _language = _storageService.getLanguage();
    
    // Load selected city
    _selectedCity = _storageService.getSelectedCity();
    
    notifyListeners();
  }

  // Toggle Theme (Light/Dark)
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      await _storageService.saveThemeMode('dark');
    } else {
      _themeMode = ThemeMode.light;
      await _storageService.saveThemeMode('light');
    }
    notifyListeners();
  }

  // Set Theme Mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    
    String modeString;
    if (mode == ThemeMode.dark) {
      modeString = 'dark';
    } else if (mode == ThemeMode.light) {
      modeString = 'light';
    } else {
      modeString = 'system';
    }
    
    await _storageService.saveThemeMode(modeString);
    notifyListeners();
  }

  // Change Language
  Future<void> changeLanguage(String languageCode) async {
    _language = languageCode;
    await _storageService.saveLanguage(languageCode);
    notifyListeners();
  }

  // Change City (untuk prayer times)
  Future<void> changeCity(String city) async {
    _selectedCity = city;
    await _storageService.saveSelectedCity(city);
    notifyListeners();
  }

  // Get localized text (untuk multi-language)
  String getText(String id, String en) {
    return _language == 'id' ? id : en;
  }

  // Common translations
  String get appName => getText('Kajian Scheduler', 'Islamic Study Scheduler');
  String get home => getText('Beranda', 'Home');
  String get profile => getText('Profil', 'Profile');
  String get settings => getText('Pengaturan', 'Settings');
  String get logout => getText('Keluar', 'Logout');
  String get login => getText('Masuk', 'Login');
  String get register => getText('Daftar', 'Register');
  String get email => getText('Email', 'Email');
  String get password => getText('Password', 'Password');
  String get name => getText('Nama', 'Name');
  String get save => getText('Simpan', 'Save');
  String get cancel => getText('Batal', 'Cancel');
  String get edit => getText('Edit', 'Edit');
  String get delete => getText('Hapus', 'Delete');
  String get search => getText('Cari', 'Search');
  String get filter => getText('Filter', 'Filter');
  String get all => getText('Semua', 'All');
  String get upcoming => getText('Akan Datang', 'Upcoming');
  String get past => getText('Sudah Lewat', 'Past');
  String get today => getText('Hari Ini', 'Today');
  String get tomorrow => getText('Besok', 'Tomorrow');
  String get theme => getText('Tema', 'Theme');
  String get lightMode => getText('Mode Terang', 'Light Mode');
  String get darkMode => getText('Mode Gelap', 'Dark Mode');
  String get language_label => getText('Bahasa', 'Language');
  String get city => getText('Kota', 'City');
}