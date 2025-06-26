import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  int _selectedIndex = 1;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/map');
        break;
      case 1:
        break; // Already on gallery
      case 2:
        Navigator.pushReplacementNamed(context, '/journal');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
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
              // Top row with title + buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'gallery',
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

              // Bottom nav
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
