import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'journal_entry.dart';
import 'package:brew_notes/screens/image_viewer.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  int _selectedIndex = 1;
  Map<DateTime, List<String>> _groupedByDate = {};

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

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

  Future<void> _loadImages() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('journal_entries')
        .where('userId', isEqualTo: uid)
        .get();

    final Map<DateTime, List<String>> grouped = {};

    for (var doc in snapshot.docs) {
      final entry = JournalEntryData.fromJson(doc.data(), doc.id);
      if (entry.imageUrl.isEmpty) continue;

      try {
        final date = DateFormat('MMMM d, yyyy').parse(entry.date);
        final groupKey = DateTime(date.year, date.month);
        grouped.putIfAbsent(groupKey, () => []);
        grouped[groupKey]!.add(entry.imageUrl);
      } catch (_) {}
    }

    setState(() => _groupedByDate = grouped);
  }

  @override
  Widget build(BuildContext context) {
    final sortedEntries = _groupedByDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      backgroundColor: AppColors.latteFoam(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'gallery',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                      color: AppColors.brown(context),
                    ),
                  ),
                  Row(
                    children: [
                      const HomeButton(),
                      const SizedBox(width: 8),
                      ThemeToggleButton(iconColor: AppColors.brown(context)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _groupedByDate.isEmpty
                    ? Center(
                  child: Text(
                    'no images yet',
                    style: TextStyle(
                      color: AppColors.brown(context),
                      fontSize: 18,
                    ),
                  ),
                )
                    : ListView(
                  children: sortedEntries.map((entry) {
                    final dateLabel =
                    DateFormat('MMMM, yyyy').format(entry.key);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          dateLabel.toLowerCase(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brown(context),
                            fontFamily: 'Playfair Display',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: entry.value.map((imageUrl) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ImageViewerPage(
                                      imageUrl: imageUrl,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
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