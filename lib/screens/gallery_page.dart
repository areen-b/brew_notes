import 'dart:io';
import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:brew_notes/global.dart';
import 'package:intl/intl.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  int _selectedIndex = 1;

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/map');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/journal');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  Map<String, List<File>> _groupImagesByMonth() {
    final Map<String, List<File>> grouped = {};
    for (final entry in journalEntries) {
      final date = DateFormat('MMMM d, yyyy').parse(entry.date);
      final key = DateFormat('MMMM, yyyy').format(date).toLowerCase();
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(entry.imageFile!);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedImages = _groupImagesByMonth();

    return Scaffold(
      backgroundColor: AppColors.latteFoam,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'gallery',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                      color: AppColors.brown,
                    ),
                  ),
                  Row(
                    children: [
                      HomeButton(),
                      SizedBox(width: 8),
                      ThemeToggleButton(iconColor: AppColors.brown),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Body
              Expanded(
                child: groupedImages.isEmpty
                    ? const Center(
                  child: Text(
                    'no images yet',
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 18, // ← updated font size
                    ),
                  ),
                )
                    : ListView(
                  children: groupedImages.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brown,
                            fontFamily: 'Playfair Display',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: entry.value
                              .map(
                                (imageFile) => ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                imageFile,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),
              NavBar(currentIndex: _selectedIndex, onTap: _onNavTap),
            ],
          ),
        ),
      ),
    );
  }
}
