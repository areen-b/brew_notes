import 'package:flutter/material.dart';

class AppColors {
  // === Raw Light Mode Colors ===
  static const _latteFoamLight = Color(0xFFE8DFD6);
  static const _primaryLight = Color(0xFF4E342E);
  static const _brownLight = Color(0xFF392723);
  static const _caramelLight = Color(0xFFC6A68D);
  static const _sageLight = Color(0xFF7C8574);
  static const _darkCrmlLight = Color(0xFF9F7453);
  static const _shadow = Color(0xFF392723);

  static const Color constPrimary = Color(0xFF4E342E);
  static const Color light = Color(0xFFE8DFD6);
  static const Color dark = Color(0xFF392723);

  // === Raw Dark Mode Colors ===
  static const _latteFoamDark = Color(0xFF60534B);
  static const _primaryDark = Color(0xFF3A3027);
  static const _brownDark = Color(0xFFECE1D5);
  static const _caramelDark = Color(0xFFC6A68D);
  static const _sageDark = Color(0xFF7C8574);
  static const _darkCrmlDark = Color(0xFF815F45);

  // === Shared Color ===
  static const _error = Color(0xFF972A2A);

  // === Theme-aware Getters ===
  static Color latteFoam(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _latteFoamDark : _latteFoamLight;

  static Color inverse(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _latteFoamLight : _latteFoamDark;

  static Color primary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _primaryDark : _primaryLight;

  static Color brown(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _brownDark : _brownLight;

  static Color caramel(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _caramelDark : _caramelLight;

  static Color sage(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _sageDark : _sageLight;

  static Color darkCrml(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _darkCrmlDark : _darkCrmlLight;

  static Color shadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withOpacity(0.25)
          : Colors.brown.withOpacity(0.2);

  static Color error = _error;

  // Raw access for theme setup
  static const latteFoamLight = _latteFoamLight;
  static const latteFoamDark = _latteFoamDark;
  static const primaryLight = _primaryLight;
  static const primaryDark = _primaryDark;
  static const brownLight = _brownLight;
  static const brownDark = _brownDark;
  static const caramelLight = _caramelLight;
  static const caramelDark = _caramelDark;
  static const sageLight = _sageLight;
  static const sageDark = _sageDark;
  static const darkCrmlLight = _darkCrmlLight;
  static const darkCrmlDark = _darkCrmlDark;
}

class AppTextStyles {
  static TextStyle button(BuildContext context) => TextStyle(
    fontFamily: 'Barlow',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.latteFoam(context),
  );

  static const title = TextStyle(
    fontFamily: 'Playfair Display',
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.latteFoamLight,
    fontFamily: 'Playfair Display',
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.sageLight,
      surface: AppColors.caramelLight,
      background: AppColors.latteFoamLight,
      error: AppColors._error,
      onPrimary: AppColors.latteFoamLight,
      onSurface: AppColors.brownLight,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.brownLight),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.latteFoamDark,
    fontFamily: 'Playfair Display',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.sageDark,
      surface: AppColors.caramelDark,
      background: AppColors.latteFoamDark,
      error: AppColors._error,
      onPrimary: AppColors.latteFoamDark,
      onSurface: AppColors.brownDark,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.brownDark),
    ),
  );
}
