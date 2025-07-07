import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _sendResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset email sent!")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error sending reset email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.latteFoam(context),
      body: Stack(
        children: [
          const TopCurveHeader(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: 260,
                color: AppColors.shadow(context),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 200.0, left: 15.0, right: 15.0),
                child: Column(
                  children: [
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brown(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your email to reset your password.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: AppColors.brown(context).withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 60),
                    CustomTextField(
                      label: "email",
                      controller: _emailController,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: 'send reset link',
                        textColor: AppColors.light,
                        onPressed: _sendResetEmail,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const BackButtonText(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}