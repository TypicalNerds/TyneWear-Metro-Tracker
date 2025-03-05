import 'package:flutter/material.dart';

class AppColors {
  // Metro Colour Scheme
  static const Color metroColor = Color.fromARGB(255, 245, 179, 37);

  static const MaterialColor metroMaterial = MaterialColor(
  0xFFF5B325, // Primary color (matches metroColor)
  <int, Color>{
    50: Color(0xFFFFF3E0),  // Lightest shade
    100: Color(0xFFFFE0B2),
    200: Color(0xFFFFCC80),
    300: Color(0xFFFFB74D),
    400: Color(0xFFFFA726),
    500: Color(0xFFF5B325),  // Original color
    600: Color(0xFFEF9A22),
    700: Color(0xFFE68E1E),
    800: Color(0xFFDC811B),
    900: Color(0xFFD07016),  // Darkest shade
  },
);

  // Define Standard Colours
  static const Color primary = metroColor;
  static const Color secondary = Colors.red;
  static const Color background = Colors.black;
  static const Color text = Colors.white;
  static const Color subtext = Colors.white70;

  // AppBar Colors
  static const Color appBarBackground = Color.fromARGB(255, 26, 26, 26);
  static const Color appBarForeground = metroColor;

  // Dividers
  static const Color listDivider = Colors.white60;
  static const Color dropdownToLists = Colors.white10;

  // Dropdown Colour Scheme
  static const Color disabledDropdown = Colors.white60;
  static const Color dropdown = Colors.white60;
  static const Color dropdownBackground = Color.fromARGB(255, 26, 26, 26);
  static const Color dropdownFocusBackground = Colors.white24;
  
  // Define train line colors
  static const Color yellowLine = Colors.yellow;
  static const Color greenLine = Colors.green;
  static const Color defaultLine = Colors.grey;



}

// Put Text And other Various App Styles Here
class AppStyles {
    // Define Text Styles
  static const TextStyle titleLarge = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.text); // Headlines
  static const TextStyle bodyLarge = TextStyle(fontSize: 13, color: AppColors.text); // Normal text
  static const TextStyle bodyMedium = TextStyle(fontSize: 11, color: AppColors.text); // Smaller text
  static const TextStyle bodySmall = TextStyle(fontSize: 9, color: AppColors.text);
  static const TextStyle labelLarge = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.secondary); // Labels
  static const TextStyle labelMedium = TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.subtext); // Labels
  static const TextStyle labelSmall = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.subtext); // Labels
  static const TextStyle displayLarge = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary,); // Big Ass Text

}

// Define a centralized ThemeData
ThemeData appTheme = ThemeData(
  primarySwatch: AppColors.metroMaterial,

  scaffoldBackgroundColor: AppColors.background,

    // Text Styles
  textTheme: const TextTheme(
    titleLarge: AppStyles.titleLarge,
    bodyLarge: AppStyles.bodyLarge,
    bodyMedium: AppStyles.bodyMedium,
    bodySmall: AppStyles.bodySmall,
    labelLarge: AppStyles.labelLarge,
    labelMedium: AppStyles.labelMedium,
    labelSmall: AppStyles.labelSmall,
    displayLarge: AppStyles.displayLarge,
  ),

  // Theme the App Bar
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.appBarBackground,
    foregroundColor: AppColors.appBarForeground,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.appBarBackground,
    selectedItemColor: AppColors.appBarForeground,
    unselectedItemColor: AppColors.metroMaterial.shade800,
  ),

  

  

);
