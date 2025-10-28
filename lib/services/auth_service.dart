import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

// AUTH SERVICE
// Service untuk Login & Register

class AuthService {
  final StorageService _storageService = StorageService();

  // Initialize (harus dipanggil saat app start)
  Future<void> init() async {
    await _storageService.init();
  }

  // Load users dari JSON file (users default)
  Future<List<User>> _loadUsersFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> jsonList = jsonDecode(response);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('Error loading users.json: $e');
      return [];
    }
  }

  // Get ALL users (JSON + SharedPreferences)
  Future<List<User>> getAllUsers() async {
    List<User> allUsers = [];
    
    // 1. Load dari JSON (users default)
    allUsers.addAll(await _loadUsersFromJson());
    
    // 2. Load dari SharedPreferences (users yang register)
    allUsers.addAll(_storageService.getRegisteredUsers());
    
    return allUsers;
  }

  // LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Get all users
      final allUsers = await getAllUsers();
      
      // Cari user yang cocok
      final user = allUsers.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('User not found'),
      );
      
      // Save session
      await _storageService.saveUserSession(user);
      
      return {
        'success': true,
        'message': 'Login berhasil',
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Email atau password salah',
        'user': null,
      };
    }
  }

  // REGISTER
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Check jika email sudah terdaftar
      final allUsers = await getAllUsers();
      
      final emailExists = allUsers.any((user) => user.email == email);
      
      if (emailExists) {
        return {
          'success': false,
          'message': 'Email sudah terdaftar',
          'user': null,
        };
      }
      
      // Buat user baru
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password,
        level: 1,
        points: 0,
        createdAt: DateTime.now(),
      );
      
      // Get registered users dari SharedPreferences
      List<User> registeredUsers = _storageService.getRegisteredUsers();
      
      // Tambah user baru
      registeredUsers.add(newUser);
      
      // Save ke SharedPreferences
      await _storageService.saveRegisteredUsers(registeredUsers);
      
      // Auto login setelah register
      await _storageService.saveUserSession(newUser);
      
      return {
        'success': true,
        'message': 'Registrasi berhasil',
        'user': newUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
        'user': null,
      };
    }
  }

  // LOGOUT
  Future<bool> logout() async {
    return await _storageService.logout();
  }

  // Check if logged in
  bool isLoggedIn() {
    return _storageService.isLoggedIn();
  }

  // Get current user
  User? getCurrentUser() {
    return _storageService.getCurrentUser();
  }
}