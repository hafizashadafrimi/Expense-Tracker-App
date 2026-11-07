import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF07111F);
  static const inkDeep = Color(0xFF050B16);
  static const card = Color(0xFF132038);
  static const cardSoft = Color(0xFF1A2B48);
  static const cream = Color(0xFFF6F1E7);
  static const muted = Color(0xFFB7C3D4);
  static const line = Color(0x22F6F1E7);
  static const income = Color(0xFF3DDC97);
  static const incomeDeep = Color(0xFF123D2E);
  static const expense = Color(0xFFFF6B7A);
  static const expenseDeep = Color(0xFF3D1824);
  static const gold = Color(0xFFF0C36A);
  static const goldDeep = Color(0xFF3C2E12);
}

ThemeData buildAppTheme() {
  const textTheme = TextTheme(
    headlineMedium: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      color: AppColors.cream,
      letterSpacing: -0.8,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: AppColors.cream,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.cream,
    ),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.muted, height: 1.4),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.ink,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      onPrimary: AppColors.ink,
      secondary: AppColors.income,
      surface: AppColors.card,
      error: AppColors.expense,
      onSurface: AppColors.cream,
    ),
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: AppColors.cream,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.cream,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.cream),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF101C31),
      hintStyle: const TextStyle(color: AppColors.muted),
      labelStyle: const TextStyle(color: AppColors.muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.expense),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.expense, width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.ink,
        minimumSize: const Size.fromHeight(56),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.cream),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.ink,
      extendedPadding: EdgeInsets.symmetric(horizontal: 22),
    ),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: AppColors.card,
      headerBackgroundColor: Color(0xFF1A3054),
      headerForegroundColor: AppColors.cream,
    ),
    dividerColor: AppColors.line,
  );
}

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF16305A), AppColors.ink, Color(0xFF0C241C)],
          stops: [0, 0.52, 1],
        ),
      ),
      child: child,
    );
  }
}
