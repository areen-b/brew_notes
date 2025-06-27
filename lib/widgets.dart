import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

//buttons
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

//top curve for landing page
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

//bottom curve for forgot password/enter code
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Curve downward — control point near right side, end point deeper
    path.quadraticBezierTo(
        size.width * 0.25, size.height + 20, // control point
        size.width, size.height * 0.1        // end point
    );

    // Close shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

//top curve for login/signup/forgot password/enter code page
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

//top inverse curve with layers
class TopCurveHeader extends StatelessWidget {
  final double height1;
  final double height2;
  final double height3;

  const TopCurveHeader({
    super.key,
    this.height1 = 230,
    this.height2 = 180,
    this.height3 = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: TopInverseCurveClipper(),
          child: Container(
            height: height1,
            color: AppColors.brown,
          ),
        ),
        ClipPath(
          clipper: TopInverseCurveClipper(),
          child: Container(
            height: height2,
            color: AppColors.primary.withOpacity(0.8),
          ),
        ),
        ClipPath(
          clipper: TopInverseCurveClipper(),
          child: Container(
            height: height3,
            color: AppColors.latteFoam.withOpacity(0.3),
          ),
        ),
        const Positioned(
          top: 40,
          right: 16,
          child: ThemeToggleButton(iconColor: AppColors.brown),
        ),
      ],
    );
  }
}

//back button
class BackButtonText extends StatelessWidget {
  final Color color;

  const BackButtonText({
    super.key,
    this.color = AppColors.latteFoam,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.arrow_back_ios_new, size: 18, color: color),
        const SizedBox(width: 4),
        Text(
          'back',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}

//home button
class HomeButton extends StatelessWidget {
  final Color iconColor;

  const HomeButton({
    super.key,
    this.iconColor = AppColors.brown,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.home),
      color: iconColor,
      iconSize: 34,
      tooltip: 'Back to Home',
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }
}

class EditButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.sage,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.edit, color: AppColors.brown, size: 24),
        ),
      ),
    );
  }
}

//light/dark mode
class ThemeToggleButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? iconColor;

  const ThemeToggleButton({super.key, this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        // TODO: Implement theme switch logic here
        print("Theme toggle tapped!");
      },
      child: Icon(
        Icons.dark_mode,
        color: iconColor ?? AppColors.brown,
        size: 30,
      ),
    );
  }
}

//text field
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: buildInputDecoration(label),
    );
  }
}

//password for signup/login
class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;

  const PasswordField({
    super.key,
    this.label = "password",
    this.controller,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

//password for signup/login
class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: buildInputDecoration(
        widget.label,
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.brown,
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        ),
      ),
    );
  }
}

//confirm password for sign up
class ConfirmPasswordField extends StatefulWidget {
  final TextEditingController? controller;

  const ConfirmPasswordField({
    super.key,
    this.controller,
  });

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

//confirm password for sign up
class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: buildInputDecoration(
        "confirm password",
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.brown,
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        ),
      ),
    );
  }
}

//enter code field after forgot password
class CodeInputField extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;

  const CodeInputField({
    super.key,
    this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 5,
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(15),
        fieldHeight: 60,
        fieldWidth: 50,
        activeColor: AppColors.brown,
        selectedColor: AppColors.primary,
        inactiveColor: AppColors.brown.withOpacity(0.4),
        activeFillColor: AppColors.latteFoam,
        inactiveFillColor: AppColors.latteFoam,
        selectedFillColor: AppColors.latteFoam,
        borderWidth: 2.5,
      ),
      cursorColor: AppColors.brown,
      animationDuration: const Duration(milliseconds: 100),
      enableActiveFill: true,
      onChanged: onChanged ?? (value) {},
      onCompleted: onCompleted ?? (value) {},
    );
  }
}

//bottom nav for after logging in
class NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const NavIcon({
    super.key,
    required this.icon,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.latteFoam.withOpacity(0.8)
            : AppColors.latteFoam.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.withOpacity(0.3),
            offset: const Offset(3, 9),
            blurRadius: 9,
          )
        ],
      ),
      child: Icon(
        icon,
        color: AppColors.brown,
        size: 38,
      ),
    );
  }
}
class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.map,
      Icons.photo,
      Icons.book,
      Icons.person,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.brown.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (index) {
          return GestureDetector(
            onTap: () => onTap(index),
            child: NavIcon(
              icon: icons[index],
              isActive: currentIndex == index,
            ),
          );
        }),
      ),
    );
  }
}

//cards used for home page
class HomeCard extends StatelessWidget {
  final List<Widget> children; // Accept multiple widgets

  const HomeCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 45),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.withOpacity(0.3),
            offset: const Offset(3, 9),
            blurRadius: 9,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // centers vertically
        crossAxisAlignment: CrossAxisAlignment.center, // centers horizontally
        children: children,
      ),
    );
  }
}

//star rating
class StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: AppColors.brown,
          ),
        );
      }),
    );
  }
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
