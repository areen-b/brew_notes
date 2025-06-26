import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'journal_entry.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<JournalEntry> entries = [];
  int _selectedIndex = 2;

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;

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

  void _addNewEntry(JournalEntry entry) {
    setState(() {
      entries.add(entry);
    });
  }

  void _navigateToAddPage() async {
    final newEntry = await Navigator.pushNamed(context, '/add');
    if (newEntry is JournalEntry) {
      _addNewEntry(newEntry);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'daily entries',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.brown),
                  ),
                  ThemeToggleButton(iconColor: AppColors.brown),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'may 6, 2025',
                style: TextStyle(fontSize: 16, color: AppColors.brown),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: entries.isEmpty
                    ? Center(
                  child: Text(
                    "No entries yet.\nTap below to add one!",
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              entry.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: AppColors.latteFoam,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.caramel,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    entry.address,
                                    style: const TextStyle(color: AppColors.latteFoam),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.caramel,
                                    borderRadius: BorderRadius.circular(12),
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
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.sage,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: entry.notes
                                  .map((note) => Text('• $note', style: const TextStyle(color: AppColors.latteFoam)))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(entry.imagePath, height: 200),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _navigateToAddPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.add, color: AppColors.latteFoam),
                    label: const Text('add new entry', style: TextStyle(color: AppColors.latteFoam)),
                  ),
                  const SizedBox(width: 12),
                  EditButton(onPressed: () {
                    // Add your logic here, e.g., navigate to edit screen
                  }),
                ],
              ),

              const SizedBox(height: 16),
              NavBar(
                currentIndex: _selectedIndex,
                onTap: _onNavTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
