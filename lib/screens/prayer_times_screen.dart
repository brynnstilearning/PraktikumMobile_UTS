import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/prayer_service.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'quran_list_screen.dart';

// PRAYER TIMES SCREEN 
// Screen untuk menampilkan jadwal sholat dari JSON

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  int _currentIndex = 1;
  final PrayerService _prayerService = PrayerService();
  
  Map<String, String> prayerTimes = {};
  String selectedCity = '';
  String gregorianDate = '';
  String hijriDate = '';
  String nextPrayerName = '';
  String nextPrayerTime = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrayerData();
  }

  // Load data dari JSON
  Future<void> _loadPrayerData() async {
    setState(() => _isLoading = true);
    
    prayerTimes = await _prayerService.getPrayerTimesMap();
    selectedCity = await _prayerService.getCity();
    
    final dates = await _prayerService.getDates();
    gregorianDate = dates['gregorian'] ?? '';
    hijriDate = dates['hijri'] ?? '';
    
    final nextPrayer = await _prayerService.getNextPrayer();
    nextPrayerName = nextPrayer['name'] ?? '';
    nextPrayerTime = nextPrayer['time'] ?? '';
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Navigation ke screen lain
    if (_currentIndex == 0) {
      return const DashboardScreen();
    } else if (_currentIndex == 2) {
      return const ProfileScreen();
    } else if (_currentIndex == 3) {
      return const SettingsScreen();
    } else if (_currentIndex == 4) {
      return const QuranListScreen();
    }

    // Prayer Times content
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadPrayerData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(),

                      const SizedBox(height: 20),

                      // Prayer Times List (SEMUA JADWAL)
                      _buildPrayerTimesList(),

                      const SizedBox(height: 20),

                      // Date Info
                      _buildDateInfo(),

                      const SizedBox(height: 100), // Space for bottom nav
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  // BUILD HEADER
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPurple,
            AppColors.primaryPurple.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.mosque,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Jadwal Sholat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                selectedCity,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            gregorianDate,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // BUILD PRAYER TIMES LIST (SEMUA JADWAL)
  Widget _buildPrayerTimesList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: prayerTimes.entries.map((entry) {
          final isLast = entry.key == prayerTimes.keys.last;
          final isNext = entry.key == nextPrayerName;
          
          return _buildPrayerTimeItem(
            entry.key,
            entry.value,
            isLast: isLast,
            isNext: isNext,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPrayerTimeItem(
    String name,
    String time, {
    bool isLast = false,
    bool isNext = false,
  }) {
    // Get icon based on prayer name
    IconData icon;
    switch (name) {
      case 'Subuh':
        icon = Icons.wb_twilight;
        break;
       case 'Terbit':
        icon = Icons.wb_twilight;
        break;
       case 'Dhuha':
        icon = Icons.wb_twilight;
        break;    
      case 'Dzuhur':
        icon = Icons.wb_sunny;
        break;
      case 'Ashar':
        icon = Icons.wb_cloudy;
        break;
      case 'Maghrib':
        icon = Icons.brightness_3;
        break;
      case 'Isya':
        icon = Icons.nights_stay;
        break;
      default:
        icon = Icons.access_time;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Highlight untuk sholat berikutnya
        color: isNext
            ? AppColors.primaryPink.withOpacity(0.1)
            : Colors.transparent,
        border: !isLast
            ? const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              )
            : null,
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isNext
                      ? AppColors.primaryPink.withOpacity(0.2)
                      : AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isNext ? AppColors.primaryPink : AppColors.primaryPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Nama Sholat
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                    color: isNext ? AppColors.primaryPink : AppColors.textDark,
                  ),
                ),
              ),
              
              // Waktu Sholat
              Text(
                time,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isNext ? AppColors.primaryPink : AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          
          // Info tambahan untuk sholat berikutnya
          if (isNext) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.primaryPink,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'dalam 7 jam 35 menit',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryPink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // BUILD DATE INFO (HIJRIAH)
  Widget _buildDateInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accentGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentGreen.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month,
            color: AppColors.accentGreen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tanggal Hijriah',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hijriDate,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}