import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = -1;
  String displayName = 'coffee friend';
  int visitedCount = 0;
  String selectedMood = '⭐ excited';

  final List<String> moodOptions = [
    '⭐ excited',
    '😌 relaxed',
    '☕ cozy',
    '💤 sleepy',
    '📚 focused',
    '🎉 joyful',
    '😞 tired',
    '🌧️ gloomy',
  ];

  @override
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    // Load display name
    setState(() {
      displayName = user.displayName ?? 'coffee friend';
    });

    // Get visited count
    final visitedSnapshot = await FirebaseFirestore.instance
        .collection('map_markers_v2')
        .where('userId', isEqualTo: uid)
        .where('type', isEqualTo: 'visited')
        .get();
    if (mounted) {
      setState(() {
        visitedCount = visitedSnapshot.docs.length;
      });
    }

    // Get stored mood
    final moodDoc = await FirebaseFirestore.instance
        .collection('user_moods')
        .doc(uid)
        .get();

    if (mounted && moodDoc.exists && moodDoc.data()!.containsKey('mood')) {
      setState(() {
        selectedMood = moodDoc['mood'];
      });
    }
  }


  Future<void> _saveMood(String mood) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('user_moods')
        .doc(user.uid)
        .set({'mood': mood});
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/map');
        break;
      case 1:
        Navigator.pushNamed(context, '/gallery');
        break;
      case 2:
        Navigator.pushNamed(context, '/journal');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
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
            children: [
              // Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.brown,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Hello, ',
                        style: const TextStyle(
                          color: AppColors.latteFoam,
                          fontSize: 20,
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: displayName,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                          const TextSpan(text: ' !'),
                        ],
                      ),
                    ),
                  ),
                  const ThemeToggleButton(iconColor: AppColors.brown),
                ],
              ),

              const SizedBox(height: 50),

              // Divider
              Container(
                height: 4.5,
                width: double.infinity,
                color: AppColors.brown,
              ),
              const SizedBox(height: 40),

              // Quote
              HomeCard(
                children: const [
                  Text(
                    'memories brewed\none sip at a time',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      color: AppColors.brown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Places Visited
              HomeCard(
                children: [
                  Text(
                    '$visitedCount',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                      color: AppColors.brown,
                    ),
                  ),
                  const Text(
                    'places visited',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Playfair Display',
                      color: AppColors.brown,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Mood Card with dropdown
              HomeCard(
                children: [
                  const Text(
                    "today’s mood",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: selectedMood,
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.brown),
                    dropdownColor: AppColors.latteFoam,
                    borderRadius: BorderRadius.circular(16),
                    style: const TextStyle(
                      color: AppColors.brown,
                      fontSize: 18,
                      fontFamily: 'Playfair Display',
                    ),
                    underline: const SizedBox(),
                    items: moodOptions.map((mood) {
                      return DropdownMenuItem<String>(
                        value: mood,
                        child: Text(mood),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedMood = value);
                        _saveMood(value);
                      }
                    },
                  ),
                ],
              ),

              const Spacer(),

              // Bottom Nav
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
