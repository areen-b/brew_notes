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
    return Expanded(
      child: ElevatedButton(
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
