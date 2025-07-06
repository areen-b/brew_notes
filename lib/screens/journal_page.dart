
import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'journal_entry.dart';
import 'new_entry_page.dart';
import 'dart:io';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  int _selectedIndex = 2;
  List<JournalEntryData> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('journal_entries')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();

    final List<JournalEntryData> loaded = snapshot.docs
        .map((doc) => JournalEntryData.fromJson(doc.data(), doc.id))
        .toList();

    setState(() => _entries = loaded);
  }

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
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

  void _navigateToAddPage() async {
    final newEntry = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EntryPage()),
    );
    if (newEntry is JournalEntryData) {
      _loadEntries(); // Refresh from Firestore
    }
  }

  void _navigateToEditPage(JournalEntryData entry) async {
    final updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntryPage(initialEntry: entry)),
    );
    if (updatedEntry is JournalEntryData) {
      _loadEntries(); // Refresh from Firestore
    }
  }

  Future<void> _deleteEntry(JournalEntryData entry) async {
    await FirebaseFirestore.instance.collection('journal_entries').doc(entry.id).delete();
    _loadEntries(); // Refresh from Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteFoam,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'daily entries',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                      color: AppColors.brown,
                    ),
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
              const SizedBox(height: 8),
              const Text('your saved moments ☕️', style: TextStyle(fontSize: 18, color: AppColors.brown)),
              const SizedBox(height: 20),
              Expanded(
                child: _entries.isEmpty
                    ? const Center(
                  child: Text(
                    "no entries yet.\ntap below to add one!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: AppColors.brown),
                  ),
                )
                    : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _entries.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 520,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
                            ),
                            child: Column(
                              children: [
                                Text(entry.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Playfair Display',
                                        fontSize: 20,
                                        color: AppColors.latteFoam)),
                                const SizedBox(height: 4),
                                Text(entry.date,
                                    style: const TextStyle(fontSize: 14, color: AppColors.latteFoam)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 100,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.caramel,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
                                          ),
                                          child: SingleChildScrollView(
                                            child: Text(entry.address,
                                                style: const TextStyle(color: AppColors.latteFoam)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Container(
                                          height: 100,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.caramel,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
                                          ),
                                          child: StarRating(
                                            rating: entry.rating.toInt(),
                                            onRatingChanged: (_) {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    height: 100,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.sage,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: entry.notes
                                            .map((note) => Text('• \$note',
                                            style: const TextStyle(color: AppColors.latteFoam)))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  if (entry.imageUrl.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        entry.imageUrl,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              EditButton(
                                onPressed: () => _navigateToEditPage(entry),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () => _deleteEntry(entry),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                icon: const Icon(Icons.delete, color: AppColors.latteFoam),
                                label: const Text('delete', style: TextStyle(color: AppColors.latteFoam)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _navigateToAddPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brown,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.add, color: AppColors.latteFoam),
                  label: const Text('add new entry', style: TextStyle(color: AppColors.latteFoam)),
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
