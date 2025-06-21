import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = -1;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on index
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
              // Top greeting + theme toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.brown,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Hello, ',
                        style: TextStyle(
                          color: AppColors.latteFoam,
                          fontSize: 20,
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'coffeeloverxxx',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          TextSpan(text: ' !'),
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

              // Quote card
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

              // Places visited card
              HomeCard(
                children: const [
                  Text(
                    '5',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                      color: AppColors.brown,
                    ),
                  ),
                  Text(
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

              // Mood card
              HomeCard(
                children: const [
                  Text(
                    "today’s mood",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.brown,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '⭐ excited !',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.brown,
                    ),
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