import 'package:brew_notes/screens/forgotPassword_page.dart';
import 'package:brew_notes/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.latteFoam,

      body: Stack(
          children: [
          // Top curve background
            // Layer 1 (backmost - light brown)
            ClipPath(
              clipper: TopInverseCurveClipper(),
              child: Container(
                height: 230,
                color: AppColors.brown,
              ),
            ),
            // Layer 2 (middle - medium brown)
            ClipPath(
              clipper: TopInverseCurveClipper(),
              child: Container(
                height: 180,
                color: AppColors.primary.withOpacity(0.8),
              ),
            ),
            // Layer 3 (front - dark brown)
            ClipPath(
              clipper: TopInverseCurveClipper(),
              child: Container(
                height: 140,
                color: AppColors.latteFoam.withOpacity(0.3)
              ),
            ),
            const Positioned(
              top: 40,
              right: 16,
              child: ThemeToggleButton(
                iconColor: AppColors.brown,
              ),
            ),
      SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0, left: 15.0, right: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.normal,
                          color: AppColors.brown.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                const CustomTextField(label: "username"),
                const SizedBox(height: 30),
                const PasswordField(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPassword()),
                      );
                      print("Forgot password tapped!");
                    },
                    child: Text(
                      "forgot password?",
                      style: TextStyle(
                        color: AppColors.error,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(label: 'Log in', onPressed: () {}),
                ),
              ],
            ),
          ),
        ),
      ),
      ],
      ),
    );
  }
}
