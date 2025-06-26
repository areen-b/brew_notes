import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

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
        Navigator.pushReplacementNamed(context, '/journal');
        break;
      case 3:
        break; // already on profile
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteFoam,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Top row: title + home + theme
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
              const Spacer(),

              // Bottom nav bar
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
