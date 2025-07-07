import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName = 'coffee friend';
  String userEmail = '';
  int _selectedIndex = 3;
  String? _profileImageUrl;

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
      userEmail = user.email ?? '';
    });

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data()?['profileImageUrl'] != null) {
      setState(() {
        _profileImageUrl = doc['profileImageUrl'];
      });
    }
  }

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
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
    }
  }

  Future<void> _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      try {
        final ref = FirebaseStorage.instance.ref().child('profile_pictures/$uid/profile.jpg');
        await ref.putFile(file);
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'profileImageUrl': url,
        }, SetOptions(merge: true));

        setState(() => _profileImageUrl = url);
      } catch (e) {
        _showConfirmationDialog("Upload Failed", "❌ Failed to upload profile image.");
      }
    }
  }

  void _showConfirmationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: AppColors.latteFoam(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title,
              style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontWeight: FontWeight.bold,
                  color: AppColors.brown(context))),
          content: Text(message,
              style: TextStyle(color: AppColors.brown(context), fontFamily: 'Playfair Display')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(color: AppColors.sage(context))),
            ),
          ],
        ),
      ),
    );
  }

  void _editUsername() {
    final controller = TextEditingController();
    _showBlurDialog(
      AlertDialog(
        backgroundColor: AppColors.latteFoam(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Edit Username",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'Playfair Display', color: AppColors.brown(context))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Current: $displayName", style: TextStyle(color: AppColors.brown(context))),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "New Username",
                labelStyle: TextStyle(color: AppColors.brown(context)),
              ),
              style: TextStyle(color: AppColors.brown(context)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: AppColors.sage(context))),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                await FirebaseAuth.instance.currentUser?.updateDisplayName(newName);
                setState(() => displayName = newName);
                Navigator.pop(context);
                _showConfirmationDialog("Username Updated", "Your username has been changed.");
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sage(context)),
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
        backgroundColor: AppColors.latteFoam(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Change Password",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'Playfair Display', color: AppColors.brown(context))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Current Password"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: AppColors.sage(context))),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              final currentPw = currentPasswordController.text.trim();
              final newPw = newPasswordController.text.trim();

              if (user != null && currentPw.isNotEmpty && newPw.length >= 6) {
                try {
                  final cred = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPw,
                  );
                  await user.reauthenticateWithCredential(cred);
                  await user.updatePassword(newPw);
                  Navigator.pop(context);
                  _showConfirmationDialog("Password Updated", "Password successfully changed.");
                } catch (_) {
                  Navigator.pop(context);
                  _showConfirmationDialog("Error", "Could not change password. Try again.");
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sage(context)),
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
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteFoam(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('my profile',
                      style: TextStyle(
                          fontSize: 26,
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown(context))),
                  Row(children: [
                    const HomeButton(),
                    const SizedBox(width: 8),
                    ThemeToggleButton(iconColor: AppColors.brown(context))
                  ])
                ],
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: _profileImageUrl != null
                        ? Image.network(_profileImageUrl!, height: 240, width: 230, fit: BoxFit.cover)
                        : Image.asset('assets/images/coffee.jpg', height: 240, width: 230, fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: _pickProfileImage,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.sage(context),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(Icons.edit, size: 20, color: AppColors.latteFoam(context)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ProfileInfoTile(label: 'email', value: userEmail, editable: false),
              ProfileInfoTile(label: 'username', value: displayName, editable: true, onEdit: _editUsername),
              ProfileInfoTile(label: 'password', value: '**********', editable: true, onEdit: _editPassword),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Log out',
                  color: AppColors.darkCrml(context),
                  textColor: AppColors.light,
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    }
                  },
                ),
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
      height: 70,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.shadow(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.shadow(context), blurRadius: 6, offset: const Offset(2, 3)),
        ],
      ),
      child: Row(
        children: [
          Text('$label: ',
              style: TextStyle(color: AppColors.inverse(context), fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.inverse(context), fontStyle: FontStyle.italic)),
          ),
          if (editable)
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.sage(context)),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}

