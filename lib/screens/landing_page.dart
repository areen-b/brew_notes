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
      backgroundColor: AppColors.latteFoam,
      body: Column(
        children: [
          // Top Curved Header
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              height: screenHeight * 0.55,
              color: AppColors.primary,
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.12),
                child: Text(
                  'Brew Notes',
                  style: TextStyle(
                    fontSize: screenWidth * 0.125,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Playfair Display',
                    color: AppColors.latteFoam,
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
              color: AppColors.brown,
              height: 1.5,
              shadows: [
                Shadow(
                  color: AppColors.brown,
                  blurRadius: 4,
                  offset: Offset(0, 1),
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
                AppButton(
                  label: 'Log in',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
                SizedBox(width: screenWidth * 0.04),
                AppButton(label: 'Sign up', onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height + 20,
      size.width,
      size.height - 170,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
