import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../models/kajian_model.dart';
import '../services/kajian_service.dart';
import '../utils/date_formatter.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/kajian_card.dart';
import 'add_kajian_screen.dart';
import 'prayer_times_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'edit_kajian_screen.dart';
import 'quran_list_screen.dart';

// DASHBOARD SCREEN
// Screen utama setelah login

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final KajianService _kajianService = KajianService();
  List<Kajian> _kajianList = [];
  List<Kajian> _filteredKajianList = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // all, upcoming, past

  @override
  void initState() {
    super.initState();
    _loadKajian();
  }

  // Load kajian dari service
  Future<void> _loadKajian() async {
    setState(() => _isLoading = true);

    final kajian = await _kajianService.loadKajian();

    setState(() {
      _kajianList = kajian;
      _applyFilter();
      _isLoading = false;
    });
  }

  // Apply filter
  void _applyFilter() {
    if (_selectedFilter == 'all') {
      _filteredKajianList = _kajianList;
    } else if (_selectedFilter == 'upcoming') {
      _filteredKajianList =
          _kajianList.where((k) => k.status == 'upcoming').toList();
    } else if (_selectedFilter == 'past') {
      _filteredKajianList =
          _kajianList.where((k) => k.status == 'past').toList();
    }
  }

  // Change filter
  void _changeFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Jika bukan index 0, tampilkan screen lain
    if (_currentIndex == 1) {
      return const PrayerTimesScreen();
    } else if (_currentIndex == 2) {
      return const ProfileScreen();
    } else if (_currentIndex == 3) {
      return const SettingsScreen();
    }else if (_currentIndex == 4) {
      return const QuranListScreen();
    }

    // Dashboard content
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadKajian,
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Filter chips
              _buildFilterChips(),

              // Kajian list
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredKajianList.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredKajianList.length,
                            itemBuilder: (context, index) {
                              final kajian = _filteredKajianList[index];
                              return KajianCard(
                                kajian: kajian,
                                onEdit: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditKajianScreen(kajian: kajian),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddKajianScreen()),
          );
        },
        backgroundColor: AppColors.primaryPink,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kajian'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // Bottom Navigation
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
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPink,
            AppColors.primaryPink.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Text(
                  user?.name.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.getGreeting(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      user?.name ?? 'User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormatter.formatWithDay(DateTime.now()),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // BUILD FILTER CHIPS
  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFilterChip('Semua', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Akan Datang', 'upcoming'),
          const SizedBox(width: 8),
          _buildFilterChip('Sudah Lewat', 'past'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;

    return InkWell(
      onTap: () => _changeFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPink : Colors.grey[200],
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

  // BUILD EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada kajian',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textLight,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap tombol + untuk menambah kajian',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
