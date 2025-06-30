import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName = 'coffee friend';
  String userEmail = '';
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      displayName = user?.displayName ?? 'coffee friend';
      userEmail = user?.email ?? '';
    });
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
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
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteFoam,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'my profile',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brown,
                    ),
                  ),
                  ThemeToggleButton(iconColor: AppColors.brown),
                ],
              ),
              const SizedBox(height: 24),

              // Profile Image
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/coffee.jpg',
                  height: 240,
                  width: 230,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 40),

              // Email
              ProfileInfoTile(
                label: 'email',
                value: userEmail,
                editable: false,
              ),

              // Username
              ProfileInfoTile(
                label: 'username',
                value: displayName,
                editable: true,
              ),

              // Password placeholder
              const ProfileInfoTile(
                label: 'password',
                value: '**********',
                editable: true,
              ),

              const SizedBox(height: 30),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Log out',
                  color: AppColors.darkCrml,
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();

                        if (!mounted) return;
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                      } catch (e) {
                        print('Logout failed: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logout failed. Please try again.')),
                        );
                      }
                    }
                ),
              ),

              const Spacer(),

              // ✅ NavBar with onTap
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

// Profile info tile widget
class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool editable;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.brown,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 3)),
        ],
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: AppColors.latteFoam, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.latteFoam, fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (editable)
            const Icon(Icons.edit, color: AppColors.sage),
        ],
      ),
    );
  }
}