import 'package:brew_notes/screens/home_page.dart';
import 'package:brew_notes/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.latteFoam,
      body: Stack(
        children: [
          // Background curves
          ClipPath(
            clipper: TopInverseCurveClipper(),
            child: Container(height: 230, color: AppColors.brown),
          ),
          ClipPath(
            clipper: TopInverseCurveClipper(),
            child: Container(height: 180, color: AppColors.primary.withOpacity(0.9)),
          ),
          ClipPath(
            clipper: TopInverseCurveClipper(),
            child: Container(height: 140, color: AppColors.latteFoam.withOpacity(0.3)),
          ),

          // Theme toggle
          const Positioned(
            top: 40,
            right: 16,
            child: ThemeToggleButton(iconColor: AppColors.brown),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 200, left: 15, right: 15),
              child: Column(
                children: [
                  // Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontFamily: 'Playfair Display',
                            fontWeight: FontWeight.normal,
                            color: AppColors.brown.withOpacity(0.5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  const CustomTextField(label: "username"),
                  const SizedBox(height: 30),
                  const CustomTextField(label: "email"),
                  const SizedBox(height: 30),
                  const PasswordField(),
                  const SizedBox(height: 30),
                  const ConfirmPasswordField(),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(label: 'Sign up', onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
