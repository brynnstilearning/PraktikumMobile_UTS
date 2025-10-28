import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/surat_model.dart';
import '../services/quran_service.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dashboard_screen.dart';
import 'prayer_times_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'quran_detail_screen.dart';

// QURAN LIST SCREEN
// Screen untuk menampilkan daftar surat Al-Quran

class QuranListScreen extends StatefulWidget {
  const QuranListScreen({super.key});

  @override
  State<QuranListScreen> createState() => _QuranListScreenState();
}

class _QuranListScreenState extends State<QuranListScreen> {
  int _currentIndex = 4; // Index untuk Al-Quran
  final QuranService _quranService = QuranService();
  
  List<Surat> _suratList = [];
  List<Surat> _filteredSuratList = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // all, makkiyyah, madaniyyah
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSuratList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load list surat dari service
  Future<void> _loadSuratList() async {
    setState(() => _isLoading = true);

    final suratList = await _quranService.loadSuratList();

    setState(() {
      _suratList = suratList;
      _filteredSuratList = suratList;
      _isLoading = false;
    });
  }

  // Apply filter
  void _applyFilter() {
    setState(() {
      if (_selectedFilter == 'all') {
        _filteredSuratList = _suratList;
      } else if (_selectedFilter == 'makkiyyah') {
        _filteredSuratList = _suratList
            .where((s) => s.revelationType == 'Makkiyyah')
            .toList();
      } else if (_selectedFilter == 'madaniyyah') {
        _filteredSuratList = _suratList
            .where((s) => s.revelationType == 'Madaniyyah')
            .toList();
      }
      
      // Apply search if any
      if (_searchController.text.isNotEmpty) {
        _searchSurat(_searchController.text);
      }
    });
  }

  // Search surat
  void _searchSurat(String query) {
    if (query.isEmpty) {
      _applyFilter();
      return;
    }

    setState(() {
      final lowerQuery = query.toLowerCase();
      _filteredSuratList = _filteredSuratList.where((surat) {
        return surat.name.toLowerCase().contains(lowerQuery) ||
               surat.nameTranslation.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Navigation ke screen lain
    if (_currentIndex == 0) {
      return const DashboardScreen();
    } else if (_currentIndex == 1) {
      return const PrayerTimesScreen();
    } else if (_currentIndex == 2) {
      return const ProfileScreen();
    } else if (_currentIndex == 3) {
      return const SettingsScreen();
    }

    // Quran List content
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadSuratList,
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Search bar
              _buildSearchBar(),

              // Filter chips
              _buildFilterChips(),

              // Surat list
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredSuratList.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredSuratList.length,
                            itemBuilder: (context, index) {
                              final surat = _filteredSuratList[index];
                              return _buildSuratCard(surat);
                            },
                          ),
              ),
            ],
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
            AppColors.accentGreen,
            AppColors.accentGreen.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.menu_book,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'Al-Quran',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_filteredSuratList.length} Surat',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // BUILD SEARCH BAR
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: _searchSurat,
        decoration: InputDecoration(
          hintText: 'Cari surat...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textLight),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilter();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // BUILD FILTER CHIPS
  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('Semua', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Makkiyyah', 'makkiyyah'),
          const SizedBox(width: 8),
          _buildFilterChip('Madaniyyah', 'madaniyyah'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = value;
          _applyFilter();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentGreen : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textDark,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // BUILD SURAT CARD
  Widget _buildSuratCard(Surat surat) {
    final isMakkiyyah = surat.revelationType == 'Makkiyyah';
    final badgeColor = isMakkiyyah ? AppColors.accentYellow : AppColors.primaryPurple;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuranDetailScreen(surat: surat),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Number badge
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${surat.number}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Surat info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surat.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${surat.nameTranslation} • ${surat.numberOfAyat} Ayat',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        surat.revelationType,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arabic name
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    surat.nameArabic,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BUILD EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Surat tidak ditemukan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textLight,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba kata kunci lain',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}