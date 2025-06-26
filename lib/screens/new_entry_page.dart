import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'journal_entry.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  int _selectedIndex = 2;
  int _rating = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/map');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/gallery');
        break;
      case 2:
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
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const BackButtonText(color: AppColors.brown),
                  ),
                  const ThemeToggleButton(iconColor: AppColors.brown),
                ],
              ),
              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'add a new entry',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brown,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'date: month dd, yyyy',
                  style: TextStyle(color: AppColors.brown),
                ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Input
                        TextField(
                          controller: _titleController,
                          style: const TextStyle(color: AppColors.latteFoam),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.primary,
                            hintText: 'location name',
                            hintStyle: const TextStyle(color: AppColors.latteFoam),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Address + Rating
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _addressController,
                                style: const TextStyle(color: AppColors.brown),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.caramel,
                                  hintText: 'address',
                                  hintStyle: const TextStyle(color: AppColors.brown),
                                  contentPadding: const EdgeInsets.all(12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                ),
                                maxLines: 3,
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
                                ),
                                child: StarRating(
                                  rating: _rating,
                                  onRatingChanged: (value) {
                                    setState(() {
                                      _rating = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Notes
                        TextField(
                          controller: _notesController,
                          style: const TextStyle(color: AppColors.latteFoam),
                          maxLines: 4,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.sage.withOpacity(0.75),
                            hintText: 'describe your visit/thoughts',
                            hintStyle: const TextStyle(color: AppColors.latteFoam),
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Upload photo (placeholder)
                        Container(
                          height: 300,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.caramel.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'upload a picture:',
                            style: TextStyle(color: AppColors.latteFoam),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Post button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              final entry = JournalEntry(
                                title: _titleController.text.trim(),
                                address: _addressController.text.trim(),
                                rating: _rating.toDouble(),
                                notes: _notesController.text.trim().split('\n').where((line) => line.isNotEmpty).toList(),
                                imagePath: "assets/images/coffee.jpg", // Placeholder
                              );

                              Navigator.pop(context, entry);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brown,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            ),
                            child: const Text(
                              'post',
                              style: TextStyle(fontSize: 18, color: AppColors.latteFoam),
                            ),
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
}
