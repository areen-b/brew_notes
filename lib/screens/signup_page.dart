import 'package:brew_notes/widgets.dart';
import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/screens/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
          color: AppColors.primary.withOpacity(0.9),
        ),
      ),
      // Layer 3 (front - dark brown)
      ClipPath(
        clipper: TopInverseCurveClipper(),
        child: Container(
          height: 140,
          color: AppColors.latteFoam.withOpacity(0.3),
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
                // Toggle Tabs
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
                    GestureDetector(
                      onTap: () {
                        // Already on Sign up
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),

                buildTextField("username"),
                const SizedBox(height: 30),
                buildTextField("email"),
                const SizedBox(height: 30),
                buildPasswordField(),
                const SizedBox(height: 30),
                buildConfirmPasswordField(),

                const SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    child: AppButton(label: 'Sign up', onPressed: () {})
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

  Widget buildTextField(String label) {
    return TextFormField(
      decoration: buildInputDecoration(label),
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      obscureText: _obscurePassword,
      decoration: buildInputDecoration(
        "password",
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.brown,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  Widget buildConfirmPasswordField() {
    return TextFormField(
      obscureText: _obscureConfirmPassword,
      decoration: buildInputDecoration(
        "confirm password",
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.brown,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ),
    );
  }
  InputDecoration buildInputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.brown),
      suffixIcon: suffixIcon,
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
    );
  }


}
