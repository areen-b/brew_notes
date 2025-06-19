import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brown,
          foregroundColor: AppColors.latteFoam,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 6,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: AppTextStyles.button,
        ),
      );
  }
}

Widget buildStaticTextField(String label, {bool isPassword = false}) {
  return TextFormField(
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.brown),
      suffixIcon: isPassword
          ? Icon(Icons.visibility_off, color: AppColors.brown)
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.brown, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: AppColors.latteFoam,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
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
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at top-left
    path.moveTo(0, 0);

    // Create a downward curve (the "U" shape)
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 60, // controls how far down the U dips
      size.width,
      0,
    );

    // Close the path to the bottom
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopInverseCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from bottom-left
    path.lineTo(0, size.height);

    // Draw an upward curve (frown shape)
    path.quadraticBezierTo(
      size.width / 1.5,
      -size.height * 0.2,
      size.width,
      size.height,
    );

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


