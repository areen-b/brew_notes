import 'package:brew_notes/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:brew_notes/screens/login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.latteFoam(context),
      body: Stack(
        children: [
          Column(
            children: [
              ClipPath(
                clipper: TopCurveClipper(),
                child: Container(
                  height: screenHeight * 0.55,
                  color: AppColors.shadow(context),
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.12),
                    child: Text(
                      'Brew Notes',
                      style: TextStyle(
                        fontSize: screenWidth * 0.125,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Playfair Display',
                        color: AppColors.inverse(context),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.07),

              Text(
                'Welcome to your\ncoffee journal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.055,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Barlow',
                  color: AppColors.brown(context),
                  height: 1.5,
                  shadows: [
                    Shadow(
                      color: AppColors.brown(context),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.08,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Log in',
                        textColor: AppColors.light,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: AppButton(
                        label: 'Sign up',
                        textColor: AppColors.light,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpPage()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Positioned(
            top: 40,
            right: 16,
            child: ThemeToggleButton(),
          ),
        ],
      ),
    );
  }
}