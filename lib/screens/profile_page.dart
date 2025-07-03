import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  void _showConfirmationDialog(String title, String message) {
    _showBlurDialog(
      AlertDialog(
        backgroundColor: AppColors.latteFoam,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.brown,
            fontWeight: FontWeight.bold,
            fontFamily: 'Playfair Display',
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.brown,
            fontFamily: 'Playfair Display',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(
                color: AppColors.sage,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editUsername() {
    final newUsernameController = TextEditingController();
    _showBlurDialog(
      AlertDialog(
        backgroundColor: AppColors.latteFoam,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Edit Username",
          style: TextStyle(
            color: AppColors.brown,
            fontWeight: FontWeight.bold,
            fontFamily: 'Playfair Display',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Current: $displayName",
              style: const TextStyle(color: AppColors.brown),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newUsernameController,
              decoration: const InputDecoration(
                labelText: "New Username",
                labelStyle: TextStyle(color: AppColors.brown),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.brown),
                ),
              ),
              style: const TextStyle(color: AppColors.brown),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: AppColors.sage)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sage,
            ),
            onPressed: () async {
              final newName = newUsernameController.text.trim();
              if (newName.isNotEmpty) {
                await FirebaseAuth.instance.currentUser?.updateDisplayName(newName);
                if (context.mounted) {
                  setState(() => displayName = newName);
                  Navigator.pop(context);
                  _showConfirmationDialog("Username Updated", "Your username has been changed.");
                }
              }
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editPassword() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    _showBlurDialog(
      AlertDialog(
        backgroundColor: AppColors.latteFoam,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Change Password",
          style: TextStyle(
            color: AppColors.brown,
            fontWeight: FontWeight.bold,
            fontFamily: 'Playfair Display',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Current Password",
                labelStyle: TextStyle(color: AppColors.brown),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.brown),
                ),
              ),
              style: const TextStyle(color: AppColors.brown),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(color: AppColors.brown),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.brown),
                ),
              ),
              style: const TextStyle(color: AppColors.brown),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: AppColors.sage)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sage),
            onPressed: () async {
              final currentPassword = currentPasswordController.text.trim();
              final newPassword = newPasswordController.text.trim();
              final user = FirebaseAuth.instance.currentUser;

              if (user != null &&
                  currentPassword.isNotEmpty &&
                  newPassword.isNotEmpty &&
                  newPassword.length >= 6) {
                final cred = EmailAuthProvider.credential(
                  email: user.email!,
                  password: currentPassword,
                );

                try {
                  await user.reauthenticateWithCredential(cred);
                  await user.updatePassword(newPassword);
                  if (context.mounted) {
                    Navigator.pop(context);
                    _showConfirmationDialog("Password Updated", "Your password has been successfully changed.");
                  }
                } catch (e) {
                  Navigator.pop(context);
                  _showConfirmationDialog("Error", "Password update failed. Please check your current password.");
                }
              }
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBlurDialog(Widget child) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: child,
      ),
    );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'my profile',
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
              const SizedBox(height: 24),
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
              ProfileInfoTile(
                label: 'email',
                value: userEmail,
                editable: false,
              ),
              ProfileInfoTile(
                label: 'username',
                value: displayName,
                editable: true,
                onEdit: _editUsername,
              ),
              ProfileInfoTile(
                label: 'password',
                value: '**********',
                editable: true,
                onEdit: _editPassword,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Log out',
                  color: AppColors.darkCrml,
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout failed. Please try again.')),
                      );
                    }
                  },
                ),
              ),
              const Spacer(),
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

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool editable;
  final VoidCallback? onEdit;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.editable = false,
    this.onEdit,
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
          BoxShadow(color: Colors.brown, blurRadius: 6, offset: Offset(2, 3)),
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
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.sage),
              onPressed: onEdit,
              tooltip: 'Edit $label',
            ),
        ],
      ),
    );
  }
}
