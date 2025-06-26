import 'package:flutter/material.dart';

class AppColors{
  //light mode
  static const latteFoam = Color(0xFFE8DFD6);     //background
  static const primary = Color(0xFF4E342E);       //main brown
  static const brown = Color(0xFF392723);     //darker brown
  static const caramel = Color(0xFFDCB893);       //edit entry box color
  static const sage = Color(0xFFA7B89E);          //edit entry box color
  static const error = Color (0xFFC84343);

  //dark mode
  static const darkBackground = Color(0xFF2D241B);  // background
  static const darkCard = Color(0xFF3A3027);        // Elevated surface shade
  static const darkText = Color(0xFFECE1D5);        // Light cream for contrast
  static const darkAccent = Color(0xFFC6A68D);      // Muted caramel highlight
  static const darkSage = Color(0xFF9CA996);        // Dusty sage for dark mode tags
}

class AppTextStyles{
  //button
  static const button = TextStyle(
    fontFamily: 'Barlow',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.latteFoam,
  );
}