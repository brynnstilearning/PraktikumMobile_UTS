import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../services/prayer_service.dart';
import '../utils/date_formatter.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';


class AddKajianScreen extends StatefulWidget {
  const AddKajianScreen({super.key});

  @override
  State<AddKajianScreen> createState() => _AddKajianScreenState();
}

class _AddKajianScreenState extends State<AddKajianScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ustadzController = TextEditingController();
  final _themeController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final PrayerService _prayerService = PrayerService();

  DateTime _selectedDate = DateTime.now();
  String _selectedTimeMode = 'manual'; // 'manual' atau 'bada_sholat'
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedBadaSholat = 'Ba\'da Maghrib';
  String _selectedCategory = 'Tafsir';
  
  Map<String, String> _prayerTimesFromJson = {}; // Data dari JSON
  bool _isLoadingPrayerTimes = false;

  @override
  void initState() {
    super.initState();
    // Load prayer times untuk ba'da sholat dari JSON
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPrayerTimes();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ustadzController.dispose();
    _themeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // LOAD PRAYER TIMES DARI JSON
  Future<void> _loadPrayerTimes() async {
    if (!mounted) return;
    
    setState(() => _isLoadingPrayerTimes = true);
    
    try {
      final times = await _prayerService.getPrayerTimesMap();
      
      if (mounted) {
        setState(() {
          _prayerTimesFromJson = times;
          _isLoadingPrayerTimes = false;
        });
      }
    } catch (e) {
      print('Error loading prayer times: $e');
      if (mounted) {
        setState(() => _isLoadingPrayerTimes = false);
      }
    }
  }

  // Handle save 
  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur simpan akan tersedia'),
        backgroundColor: Colors.orange,
      ),
    );

    // tampilkan data yang diinput
    _showPreviewDialog();
  }

  // Show preview dialog
  void _showPreviewDialog() {
    final timeString = _selectedTimeMode == 'manual'
        ? '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}'
        : _selectedBadaSholat;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preview Data'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Judul: ${_titleController.text}'),
              const SizedBox(height: 8),
              Text('Ustadz: ${_ustadzController.text}'),
              const SizedBox(height: 8),
              Text('Tema: ${_themeController.text}'),
              const SizedBox(height: 8),
              Text('Tanggal: ${DateFormatter.formatIndonesian(_selectedDate)}'),
              const SizedBox(height: 8),
              Text('Waktu: $timeString'),
              const SizedBox(height: 8),
              Text('Lokasi: ${_locationController.text}'),
              const SizedBox(height: 8),
              Text('Kategori: $_selectedCategory'),
              const SizedBox(height: 8),
              Text('Catatan: ${_notesController.text}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kajian'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              CustomTextField(
                label: 'Judul Kajian',
                hint: 'Contoh: Kajian Tafsir Al-Baqarah',
                controller: _titleController,
                validator: (value) => Validators.validateRequired(value, 'Judul kajian'),
              ),

              const SizedBox(height: 20),

              // Ustadz
              CustomTextField(
                label: 'Nama Ustadz',
                hint: 'Contoh: Ustadz Ahmad',
                controller: _ustadzController,
                validator: (value) => Validators.validateRequired(value, 'Nama ustadz'),
              ),

              const SizedBox(height: 20),

              // Theme
              CustomTextField(
                label: 'Tema Kajian',
                hint: 'Contoh: Tafsir Al-Quran Juz 1-2',
                controller: _themeController,
                validator: (value) => Validators.validateRequired(value, 'Tema kajian'),
              ),

              const SizedBox(height: 20),

              // Date Picker
              _buildDatePicker(),

              const SizedBox(height: 20),

              // Time Picker Mode
              _buildTimePicker(),

              const SizedBox(height: 20),

              // Location
              CustomTextField(
                label: 'Lokasi',
                hint: 'Contoh: Masjid Agung Malang',
                controller: _locationController,
                validator: (value) => Validators.validateRequired(value, 'Lokasi'),
              ),

              const SizedBox(height: 20),

              // Category
              _buildCategorySelector(),

              const SizedBox(height: 20),

              // Notes
              CustomTextField(
                label: 'Catatan',
                hint: 'Catatan tambahan (opsional)',
                controller: _notesController,
                maxLines: 4,
              ),

              const SizedBox(height: 30),

              // Save Button
              CustomButton(
                text: 'Simpan Kajian',
                onPressed: _handleSave,
                icon: Icons.save,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // BUILD DATE PICKER
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Tanggal',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        
        InkWell(
          onTap: () => _showCalendarDialog(),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primaryPink),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    DateFormatter.formatIndonesian(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCalendarDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _selectedDate,
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                  });
                  Navigator.pop(context);
                },
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primaryPurple,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BUILD TIME PICKER
  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Waktu',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),

        // Toggle: Manual vs Ba'da Sholat
        Row(
          children: [
            Expanded(
              child: _buildTimeToggle('Manual', 'manual'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTimeToggle('Ba\'da Sholat', 'bada_sholat'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Time selector based on mode
        if (_selectedTimeMode == 'manual')
          _buildManualTimePicker()
        else
          _buildBadaSholatPicker(),
      ],
    );
  }

  Widget _buildTimeToggle(String label, String mode) {
    final isSelected = _selectedTimeMode == mode;

    return InkWell(
      onTap: () => setState(() => _selectedTimeMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPink : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManualTimePicker() {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
        );
        if (picked != null) {
          setState(() => _selectedTime = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.primaryPink),
            const SizedBox(width: 12),
            Text(
              '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  // BUILD BA'DA SHOLAT PICKER (DARI JSON)
  Widget _buildBadaSholatPicker() {
    if (_isLoadingPrayerTimes) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      children: AppConstants.badaSholatOptions.map((option) {
        final isSelected = _selectedBadaSholat == option;
        
        // Get waktu from JSON yang sudah di-load
        final simpleName = option.replaceAll('Ba\'da ', '');
        final prayerTime = _prayerTimesFromJson[simpleName] ?? '';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () => setState(() => _selectedBadaSholat = option),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPink.withOpacity(0.1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primaryPink : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? AppColors.primaryPink : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppColors.primaryPink : AppColors.textDark,
                      ),
                    ),
                  ),
                  if (prayerTime.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primaryPink.withOpacity(0.1)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        prayerTime,
                        style: TextStyle(
                          color: isSelected ? AppColors.primaryPink : AppColors.textLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // BUILD CATEGORY SELECTOR
  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.categories.map((category) {
            final isSelected = _selectedCategory == category['name'];
            final color = Color(category['color']);

            return InkWell(
              onTap: () => setState(() => _selectedCategory = category['name']),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.2) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? color : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category['icon'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category['name'],
                      style: TextStyle(
                        color: isSelected ? color : AppColors.textDark,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}