import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../models/kajian_model.dart';
import '../utils/date_formatter.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// EDIT KAJIAN SCREEN
// Screen untuk edit kajian yang sudah ada

class EditKajianScreen extends StatefulWidget {
  final Kajian kajian; // Data kajian yang akan diedit

  const EditKajianScreen({
    super.key,
    required this.kajian,
  });

  @override
  State<EditKajianScreen> createState() => _EditKajianScreenState();
}

class _EditKajianScreenState extends State<EditKajianScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _ustadzController;
  late TextEditingController _themeController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;

  late DateTime _selectedDate;
  late String _selectedTime;
  late String _selectedCategory;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    
    // Pre-fill form dengan data kajian yang ada
    _titleController = TextEditingController(text: widget.kajian.title);
    _ustadzController = TextEditingController(text: widget.kajian.ustadz);
    _themeController = TextEditingController(text: widget.kajian.theme);
    _locationController = TextEditingController(text: widget.kajian.location);
    _notesController = TextEditingController(text: widget.kajian.notes);
    
    _selectedDate = DateFormatter.parseIsoDate(widget.kajian.date) ?? DateTime.now();
    _selectedTime = widget.kajian.time;
    _selectedCategory = widget.kajian.category;
    _selectedStatus = widget.kajian.status;
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

  // Handle save 
  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur update akan tersedia'),
        backgroundColor: Colors.orange,
      ),
    );

    // Preview updated data
    _showPreviewDialog();
  }

  // Show preview dialog
  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preview Data Update'),
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
              Text('Waktu: $_selectedTime'),
              const SizedBox(height: 8),
              Text('Lokasi: ${_locationController.text}'),
              const SizedBox(height: 8),
              Text('Kategori: $_selectedCategory'),
              const SizedBox(height: 8),
              Text('Status: $_selectedStatus'),
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
        title: const Text('Edit Kajian'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info: Editing existing kajian
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accentBlue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.accentBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Anda sedang mengedit: ${widget.kajian.title}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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

              // Time
              CustomTextField(
                label: 'Waktu',
                hint: 'Contoh: 14:00 atau Ba\'da Maghrib',
                controller: TextEditingController(text: _selectedTime),
               // onChanged: (value) => _selectedTime = value,
              ),

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

              // Status (Upcoming / Past)
              _buildStatusSelector(),

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
                text: 'Simpan Perubahan',
                onPressed: _handleSave,
                icon: Icons.save,
              ),

              const SizedBox(height: 12),

              // Cancel Button
              CustomOutlineButton(
                text: 'Batal',
                onPressed: () => Navigator.pop(context),
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
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
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

  // BUILD STATUS SELECTOR (Upcoming / Past)
  Widget _buildStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Kajian',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: _buildStatusOption('Akan Datang', 'upcoming'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusOption('Sudah Lewat', 'past'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusOption(String label, String status) {
    final isSelected = _selectedStatus == status;
    final color = status == 'upcoming' ? AppColors.accentGreen : AppColors.textLight;

    return InkWell(
      onTap: () => setState(() => _selectedStatus = status),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? color : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SHOW DELETE DIALOG
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kajian'),
        content: Text('Apakah Anda yakin ingin menghapus "${widget.kajian.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur hapus akan tersedia'),
                  backgroundColor: Colors.orange,
                ),
              );
              Navigator.pop(context); // Close edit screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}