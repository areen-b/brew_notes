import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:brew_notes/widgets.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

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
              // Top search bar + toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.brown,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: AppColors.latteFoam),
                          SizedBox(width: 8),
                          Text(
                            "Search places...",
                            style: TextStyle(
                              color: AppColors.latteFoam,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const ThemeToggleButton(iconColor: AppColors.brown),
                ],
              ),

              const SizedBox(height: 20),

              // Filter buttons row
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                decoration: BoxDecoration(
                  color: AppColors.brown.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("☕️ places visited\n\n🤎 want to visit",
                        style: TextStyle(
                            color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Barlow',
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Google Map directly below
              Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brown.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: const GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(34.0572, -117.8217), // Cal Poly Pomona
                    zoom: 14,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
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
