import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'journal_entry.dart';

class EntryPage extends StatefulWidget {
  final JournalEntryData? initialEntry;
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
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();

    _titleController.addListener(_checkFormComplete);
    _addressController.addListener(_checkFormComplete);
    _notesController.addListener(_checkFormComplete);

    if (widget.initialEntry != null) {
      final entry = widget.initialEntry!;
      _titleController.text = entry.title;
      _addressController.text = entry.address;
      _notesController.text = entry.notes.join('\n');
      _rating = entry.rating.toInt();
      _existingImageUrl = entry.imageUrl;
      final parts = entry.date.split(' ');
      if (parts.length >= 3) {
        _selectedMonth = parts[0];
        _selectedDay = int.tryParse(parts[1].replaceAll(',', ''));
        _selectedYear = int.tryParse(parts[2]);
      }
    }
  }

  void _checkFormComplete() {
    final hasDate = _selectedMonth != null && _selectedDay != null && _selectedYear != null;
    final hasTitle = _titleController.text.trim().isNotEmpty;
    final hasAddress = _addressController.text.trim().isNotEmpty;
    final hasNotes = _notesController.text.trim().isNotEmpty;
    final hasImage = _selectedImage != null || _existingImageUrl != null;

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
        _existingImageUrl = null; // Clear old image if new one selected
        _checkFormComplete();
      });
    }
  }

  Future<void> _submitEntry() async {
    final date = '$_selectedMonth $_selectedDay, $_selectedYear';
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in.")),
      );
      return;
    }

    try {
      String imageUrl = _existingImageUrl ?? '';

      // Upload new image if picked
      if (_selectedImage != null) {
        final fileName = const Uuid().v4();
        final ref = FirebaseStorage.instance.ref().child('journal_images/$fileName.jpg');
        await ref.putFile(_selectedImage!);
        imageUrl = await ref.getDownloadURL();
      }

      final data = JournalEntryData(
        id: widget.initialEntry?.id ?? FirebaseFirestore.instance.collection('journal_entries').doc().id,
        title: _titleController.text.trim(),
        address: _addressController.text.trim(),
        notes: _notesController.text.trim().split('\n').where((line) => line.isNotEmpty).toList(),
        rating: _rating.toDouble(),
        date: date,
        imageUrl: imageUrl,
        userId: uid,
      );

      final docRef = FirebaseFirestore.instance.collection('journal_entries').doc(data.id);
      await docRef.set(data.toJson());

      final docSnapshot = await docRef.get();
      final savedEntry = JournalEntryData.fromJson(docSnapshot.data()!, docSnapshot.id);
      Navigator.pop(context, savedEntry);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
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

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(_selectedImage!, height: 300, width: double.infinity, fit: BoxFit.cover),
      );
    } else if (_existingImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(_existingImageUrl!, height: 300, width: double.infinity, fit: BoxFit.cover),
      );
    } else {
      return Text('tap to upload a picture', style: TextStyle(color: AppColors.light));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteFoam(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: BackButtonText(color: AppColors.brown(context)),
                ),
                Row(
                  children: [
                    const HomeButton(),
                    const SizedBox(width: 8),
                    ThemeToggleButton(iconColor: AppColors.brown(context)),
                  ],
                ),
              ]),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'add a new entry',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.brown(context)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildDropdown(label: 'month', value: _selectedMonth, items: _months, onChanged: (val) => setState(() { _selectedMonth = val; _checkFormComplete(); })),
                  const SizedBox(width: 8),
                  _buildDropdown(label: 'day', value: _selectedDay, items: _days, onChanged: (val) => setState(() { _selectedDay = val; _checkFormComplete(); })),
                  const SizedBox(width: 8),
                  _buildDropdown(label: 'year', value: _selectedYear, items: _years, onChanged: (val) => setState(() { _selectedYear = val; _checkFormComplete(); })),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.shadow(context).withOpacity(0.65),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
                    ),
                    child: Column(children: [
                      _buildTextField(_titleController, 'location name'),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: _buildTextField(_addressController, 'address', fill: AppColors.caramel(context), hintColor: AppColors.dark)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.caramel(context),
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
                      ]),
                      const SizedBox(height: 12),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.sage(context).withOpacity(0.75),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
                        ),
                        child: TextField(
                          controller: _notesController,
                          style: TextStyle(color: AppColors.latteFoam(context)),
                          expands: true,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'describe your visit/thoughts',
                            hintStyle: TextStyle(color: AppColors.light),
                            contentPadding: const EdgeInsets.all(12),
                            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.transparent,
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
                            color: AppColors.caramel(context).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4))],
                          ),
                          child: _buildImagePreview(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isFormComplete ? _submitEntry : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brown(context),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          ),
                          child: Text('post', style: TextStyle(fontSize: 18, color: AppColors.light)),
                        ),
                      ),
                    ]),
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

  Widget _buildDropdown<T>({required String label, required T? value, required List<T> items, required ValueChanged<T?> onChanged}) {
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
            labelStyle: TextStyle(color: AppColors.inverse(context)),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: AppColors.shadow(context),
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide.none),
          ),
          dropdownColor: AppColors.primary(context),
          style: TextStyle(color: AppColors.inverse(context)),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {Color? fill, Color? hintColor}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: hintColor ?? AppColors.latteFoam(context)),
      decoration: InputDecoration(
        filled: true,
        fillColor: fill ?? AppColors.primary(context),
        hintText: hint,
        hintStyle: TextStyle(color: hintColor ?? AppColors.light, fontFamily: 'Playfair Display'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
