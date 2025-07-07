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
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      displayName = user.displayName ?? 'coffee friend';
    });

    final visitedSnapshot = await FirebaseFirestore.instance
        .collection('map_markers_v2')
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: 'visited')
        .get();

    final moodDoc = await FirebaseFirestore.instance
        .collection('user_moods')
        .doc(user.uid)
        .get();

    if (mounted) {
      setState(() {
        visitedCount = visitedSnapshot.docs.length;
        if (moodDoc.exists && moodDoc.data()!.containsKey('mood')) {
          selectedMood = moodDoc['mood'];
        }
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
      backgroundColor: AppColors.latteFoam(context),
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
                      color: AppColors.shadow(context),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Hello, ',
                        style: TextStyle(
                          color: AppColors.brown(context),
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
                  ThemeToggleButton(iconColor: AppColors.brown(context)),
                ],
              ),

              const SizedBox(height: 50),

              Container(
                height: 4.5,
                width: double.infinity,
                color: AppColors.shadow(context),
              ),

              const SizedBox(height: 40),

              HomeCard(
                children: [
                  Text(
                    'memories brewed\none sip at a time',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      color: AppColors.brown(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              HomeCard(
                children: [
                  Text(
                    '$visitedCount',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                      color: AppColors.brown(context),
                    ),
                  ),
                  Text(
                    'places visited',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Playfair Display',
                      color: AppColors.brown(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              HomeCard(
                children: [
                  Text(
                    "today’s mood",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.brown(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: selectedMood,
                    icon: Icon(Icons.arrow_drop_down, color: AppColors.brown(context)),
                    dropdownColor: AppColors.latteFoam(context),
                    borderRadius: BorderRadius.circular(16),
                    style: TextStyle(
                      color: AppColors.brown(context),
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

              NavBar(currentIndex: _selectedIndex, onTap: _onNavTap),
            ],
          ),
        ),
      ),
    );
  }
}