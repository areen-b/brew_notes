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
        .get();

    final List<JournalEntryData> loaded = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data.containsKey('timestamp')) {
        await doc.reference.update({'timestamp': FieldValue.delete()});
      }
      loaded.add(JournalEntryData.fromJson(data, doc.id));
    }

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
      _loadEntries();
    }
  }

  void _navigateToEditPage(JournalEntryData entry) async {
    final updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntryPage(initialEntry: entry)),
    );
    if (updatedEntry is JournalEntryData) {
      _loadEntries();
    }
  }

  Future<void> _deleteEntry(JournalEntryData entry) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.latteFoam(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Entry?',
          style: TextStyle(
            color: AppColors.brown(context),
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this entry? This cannot be undone.',
          style: TextStyle(color: AppColors.brown(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: AppColors.brown(context))),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('journal_entries')
          .doc(entry.id)
          .delete();
      _loadEntries(); // Refresh after deletion
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'daily entries',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
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
              const SizedBox(height: 8),
              Text(
                'your saved moments ☕️',
                style: TextStyle(fontSize: 18, color: AppColors.brown(context)),
              ),
              const SizedBox(height: 20),

              // Entry list
              Expanded(
                child: _entries.isEmpty
                    ? Center(
                  child: Text(
                    "no entries yet.\ntap below to add one!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: AppColors.brown(context)),
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
                        color: AppColors.shadow(context).withOpacity(0.65),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.constPrimary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  entry.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Playfair Display',
                                    fontSize: 20,
                                    color: AppColors.light,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(entry.date,
                                    style: TextStyle(fontSize: 14, color: AppColors.light)),
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
                                            color: AppColors.caramel(context),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 6,
                                                  offset: Offset(2, 4))
                                            ],
                                          ),
                                          child: SingleChildScrollView(
                                            child: Text(entry.address,
                                                style: TextStyle(color: AppColors.dark)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Container(
                                          height: 100,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.caramel(context),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 6,
                                                  offset: Offset(2, 4))
                                            ],
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
                                      color: AppColors.sage(context),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))
                                      ],
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: entry.notes
                                            .map((note) => Text('• $note',
                                            style: TextStyle(color: AppColors.dark)))
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
                              EditButton(onPressed: () => _navigateToEditPage(entry)),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () => _deleteEntry(entry),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                                icon: Icon(Icons.delete, color: AppColors.dark),
                                label: Text('delete', style: TextStyle(color: AppColors.dark)),
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
                    backgroundColor: AppColors.dark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: Icon(Icons.add, color: AppColors.light),
                  label: Text('add new entry', style: TextStyle(color: AppColors.light)),
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
