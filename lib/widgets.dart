import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:brew_notes/main.dart';

// App Button
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.dark,
        foregroundColor: AppColors.latteFoam(context),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 6,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: AppTextStyles.button(context).copyWith(
          color: textColor ?? AppColors.latteFoam(context),
        ),
      ),
    );
  }
}

// Curves
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
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.25, size.height + 20, size.width, size.height * 0.1);
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
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 1.5, -size.height * 0.2, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

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
            height: 230,
            color: AppColors.dark,
          ),
        ),
        ClipPath(
          clipper: TopInverseCurveClipper(),
          child: Container(
            height: 180,
            color: AppColors.shadow(context),
          ),
        ),
        ClipPath(
          clipper: TopInverseCurveClipper(),
          child: Container(
            height: 140,
            color: AppColors.shadow(context),
          ),
        ),
        Positioned(
          top: 40,
          right: 16,
          child: ThemeToggleButton(iconColor: AppColors.brown(context)),
        ),
      ],
    );
  }
}

// Back/Home Buttons
class BackButtonText extends StatelessWidget {
  final Color? color;

  const BackButtonText({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? AppColors.latteFoam(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.arrow_back_ios_new, size: 18, color: iconColor),
        const SizedBox(width: 4),
        Text(
          'back',
          style: TextStyle(color: iconColor, fontSize: 16, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

class HomeButton extends StatelessWidget {
  final Color? iconColor;

  const HomeButton({super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.home),
      color: iconColor ?? AppColors.brown(context),
      iconSize: 34,
      tooltip: 'Back to Home',
      onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
    );
  }
}

// Edit Icon
class EditButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.sage(context),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(Icons.edit, color: AppColors.brown(context), size: 24),
        ),
      ),
    );
  }
}

// Theme Toggle
class ThemeToggleButton extends StatelessWidget {
  final Color? iconColor;

  const ThemeToggleButton({super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final isDark = themeModeNotifier.value == ThemeMode.dark;

    return GestureDetector(
      onTap: () {
        themeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        ),
        child: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          size: 26,
          color: iconColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

// Text Fields
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const CustomTextField({super.key, required this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: buildInputDecoration(context, label),
    );
  }
}

class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;

  const PasswordField({super.key, this.label = "password", this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: buildInputDecoration(
        context,
        widget.label,
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.brown(context),
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

class ConfirmPasswordField extends StatefulWidget {
  final TextEditingController? controller;

  const ConfirmPasswordField({super.key, this.controller});

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: buildInputDecoration(
        context,
        "confirm password",
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.brown(context),
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

// Pin Code Field
class CodeInputField extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;

  const CodeInputField({super.key, this.onChanged, this.onCompleted});

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
        activeColor: AppColors.brown(context),
        selectedColor: AppColors.primary(context),
        inactiveColor: AppColors.brown(context).withOpacity(0.4),
        activeFillColor: AppColors.latteFoam(context),
        inactiveFillColor: AppColors.latteFoam(context),
        selectedFillColor: AppColors.latteFoam(context),
        borderWidth: 2.5,
      ),
      cursorColor: AppColors.brown(context),
      animationDuration: const Duration(milliseconds: 100),
      enableActiveFill: true,
      onChanged: onChanged ?? (_) {},
      onCompleted: onCompleted ?? (_) {},
    );
  }
}

// NavBar
class NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const NavIcon({super.key, required this.icon, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    const baseColor = AppColors.light;
    const shadowColor = AppColors.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? baseColor.withOpacity(0.8) : baseColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            offset: const Offset(3, 9),
            blurRadius: 9,
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.dark, size: 38),
    );
  }
}

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icons = [Icons.map, Icons.photo, Icons.book, Icons.person];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.dark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (index) {
          return GestureDetector(
            onTap: () => onTap(index),
            child: NavIcon(icon: icons[index], isActive: currentIndex == index),
          );
        }),
      ),
    );
  }
}


// HomeCard
class HomeCard extends StatelessWidget {
  final List<Widget> children;

  const HomeCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 45),
      decoration: BoxDecoration(
        color: AppColors.shadow(context).withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            offset: const Offset(2, 4),
            blurRadius: 3,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

// Star Rating
class StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const StarRating({super.key, required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: AppColors.dark,
          ),
        );
      }),
    );
  }
}

InputDecoration buildInputDecoration(BuildContext context, String label, {Widget? suffixIcon}) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: AppColors.brown(context)),
    suffixIcon: suffixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColors.brown(context), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.brown(context), width: 2.5),
    ),
    filled: true,
    fillColor: AppColors.latteFoam(context),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  );
}
