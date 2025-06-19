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
  bool _obscurePassword = true;

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
      SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0, left: 15.0, right: 15.0),
            child: Column(
              children: [
                // Tab Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Log in tab
                    GestureDetector(
                      onTap: () {
                        // Already on login page — do nothing
                      },
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
                    // Sign up tab
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
                buildTextField("username"),
                const SizedBox(height: 30),
                buildTextField("password", isPassword: true),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                    child: AppButton(label: 'Log in', onPressed: () {})
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

  Widget buildTextField(String label, {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.brown),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.brown,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.brown, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.brown, width: 2.5),
        ),
        filled: true,
        fillColor: AppColors.latteFoam,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }
}
