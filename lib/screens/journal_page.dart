import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'journal_entry.dart';
import 'new_entry_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<JournalEntry> entries = [];
  int _selectedIndex = 2;

  final List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
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

  DateTime _parseDate(String date) {
    final parts = date.replaceAll(',', '').split(' ');
    if (parts.length == 3) {
      final month = parts[0];
      final day = int.tryParse(parts[1]) ?? 1;
      final year = int.tryParse(parts[2]) ?? 2000;
      final monthIndex = _monthNames.indexOf(month) + 1;
      return DateTime(year, monthIndex, day);
    }
    return DateTime(2000);
  }

  void _addNewEntry(JournalEntry entry) {
    setState(() {
      entries.add(entry);
      entries.sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));
    });
  }

  void _deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
  }

  void _navigateToAddPage() async {
    final newEntry = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EntryPage()),
    );
    if (newEntry is JournalEntry) {
      _addNewEntry(newEntry);
    }
  }

  void _navigateToEditPage(int index) async {
    final updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntryPage(initialEntry: entries[index])),
    );
    if (updatedEntry is JournalEntry) {
      setState(() {
        entries[index] = updatedEntry;
        entries.sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));
      });
    }
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
              // Top bar
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
              const Text('your saved moments', style: TextStyle(fontSize: 16, color: AppColors.brown)),
              const SizedBox(height: 20),

              // Entry list or empty state
              Expanded(
                child: entries.isEmpty
                    ? const Center(
                  child: Text(
                    "no entries yet.\ntap below to add one!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: AppColors.brown),
                  ),
                )
                    : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints.tightFor(height: 100),
                                          child: Container(
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
                                            .map((note) => Text('• $note',
                                            style: const TextStyle(color: AppColors.latteFoam)))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      entry.imageFile!,
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
                                onPressed: () => _navigateToEditPage(index),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () => _deleteEntry(index),
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
