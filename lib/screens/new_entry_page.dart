import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'journal_entry.dart';
import 'package:brew_notes/global.dart';

class EntryPage extends StatefulWidget {
  final JournalEntry? initialEntry;
  const EntryPage({super.key, this.initialEntry});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  int _selectedIndex = 2;
  int _rating = 0;
  bool _isFormComplete = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final List<int> _days = List.generate(31, (i) => i + 1);
  final List<int> _years = List.generate(26, (i) => 2000 + i);

  String? _selectedMonth;
  int? _selectedDay;
  int? _selectedYear;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.initialEntry != null) {
      final entry = widget.initialEntry!;
      _titleController.text = entry.title;
      _addressController.text = entry.address;
      _notesController.text = entry.notes.join('\n');
      _rating = entry.rating.toInt();
      _selectedImage = entry.imageFile;

      final parts = entry.date.split(' ');
      if (parts.length == 3) {
        _selectedMonth = parts[0];
        _selectedDay = int.tryParse(parts[1].replaceAll(',', ''));
        _selectedYear = int.tryParse(parts[2]);
      }
    }

    _titleController.addListener(_checkFormComplete);
    _addressController.addListener(_checkFormComplete);
    _notesController.addListener(_checkFormComplete);
  }

  void _checkFormComplete() {
    final hasDate = _selectedMonth != null && _selectedDay != null && _selectedYear != null;
    final hasTitle = _titleController.text.trim().isNotEmpty;
    final hasAddress = _addressController.text.trim().isNotEmpty;
    final hasNotes = _notesController.text.trim().isNotEmpty;
    final hasImage = _selectedImage != null;

    setState(() {
      _isFormComplete = hasDate && hasTitle && hasAddress && hasNotes && hasImage;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _checkFormComplete();
      });
    }
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/map');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/gallery');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteFoam,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const BackButtonText(color: AppColors.brown),
                  ),
                  Row(
                    children: const [
                      HomeButton(),
                      SizedBox(width: 8),
                      ThemeToggleButton(iconColor: AppColors.brown),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text('add a new entry', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.brown)),
              ),
              const SizedBox(height: 12),

              // Date Dropdowns
              Row(
                children: [
                  _buildDropdown<String>(label: 'month', value: _selectedMonth, items: _months, onChanged: (val) {
                    setState(() => _selectedMonth = val);
                    _checkFormComplete();
                  }),
                  const SizedBox(width: 8),
                  _buildDropdown<int>(label: 'day', value: _selectedDay, items: _days, onChanged: (val) {
                    setState(() => _selectedDay = val);
                    _checkFormComplete();
                  }),
                  const SizedBox(width: 8),
                  _buildDropdown<int>(label: 'year', value: _selectedYear, items: _years, onChanged: (val) {
                    setState(() => _selectedYear = val);
                    _checkFormComplete();
                  }),
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
                    ),
                    child: Column(
                      children: [
                        _buildTextField(_titleController, 'location name'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 80,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.caramel,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
                                ),
                                child: TextField(
                                  controller: _addressController,
                                  expands: true,
                                  maxLines: null,
                                  style: const TextStyle(color: AppColors.brown),
                                  decoration: const InputDecoration(
                                    hintText: 'address',
                                    hintStyle: TextStyle(color: AppColors.brown),
                                    contentPadding: EdgeInsets.all(0),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 80,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.caramel,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
                                ),
                                child: StarRating(
                                  rating: _rating,
                                  onRatingChanged: (val) {
                                    setState(() => _rating = val);
                                    _checkFormComplete();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.sage.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
                            ),
                            child: TextField(
                              controller: _notesController,
                              style: const TextStyle(color: AppColors.latteFoam),
                              expands: true,
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: 'describe your visit/thoughts',
                                hintStyle: TextStyle(color: AppColors.latteFoam),
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 300,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.caramel.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4))],
                            ),
                            child: _selectedImage == null
                                ? const Text('tap to upload a picture', style: TextStyle(color: AppColors.latteFoam))
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(_selectedImage!, height: 300, width: double.infinity, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _isFormComplete
                                ? () {
                              final date = '$_selectedMonth $_selectedDay, $_selectedYear';
                              if (_selectedImage != null && !galleryImages.contains(_selectedImage)) {
                                galleryImages.add(_selectedImage!);
                              }

                              final entry = JournalEntry(
                                title: _titleController.text.trim(),
                                address: _addressController.text.trim(),
                                rating: _rating.toDouble(),
                                notes: _notesController.text.trim().split('\n').where((line) => line.isNotEmpty).toList(),
                                date: date,
                                imageFile: _selectedImage,
                              );
                              journalEntries.add(entry);

                              Navigator.pop(context, entry);
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brown,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            ),
                            child: const Text('post', style: TextStyle(fontSize: 18, color: AppColors.latteFoam)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              NavBar(currentIndex: _selectedIndex, onTap: _onNavTap),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
        ),
        child: DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item.toString()))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: AppColors.latteFoam),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: AppColors.primary,
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide.none),
          ),
          dropdownColor: AppColors.primary,
          style: const TextStyle(color: AppColors.latteFoam),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {Color fill = AppColors.primary, Color hintColor = AppColors.latteFoam}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: hintColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: fill,
        hintText: hint,
        hintStyle: TextStyle(color: hintColor, fontFamily: 'Playfair Display'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}