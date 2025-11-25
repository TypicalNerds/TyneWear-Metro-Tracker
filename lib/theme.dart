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

  // Light Mode Colour Scheme
  static ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: metroColor,
    onPrimary: metroColor,
    secondary: secondary,
    onSecondary: onSecondary,
    error: error,
    onError: onError,
    surface: surface,
    onSurface: onSurface,
  );

  // Dark Mode Colour Scheme
    static ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    onSecondary: onSecondary,
    error: error,
    onError: onError,
    surface: surface,
    onSurface: onSurface,
  );

  // Define Standard Colours (dark mode)
  static const Color primary = Color.fromARGB(255, 26, 26, 26);
  static const Color onPrimary = metroColor;
  static const Color secondary = Color.fromARGB(255, 75, 75, 75);
  static const Color onSecondary = Colors.red;
  static const Color background = Colors.black;
  static const Color surface = Color.fromARGB(255, 26, 26, 26);
  static const Color onSurface = Colors.white;
  static const Color error = secondary;
  static const Color onError = Colors.white;

  // Dividers
  // static const Color listDivider = Colors.white60;
  static const Color dropdownToLists = Colors.white10;
  
  // Define train line colors
  static const Color yellowLine = Colors.yellow;
  static const Color greenLine = Colors.green;
  static const Color defaultLine = Colors.grey;

}

// Put Text And other Various App Styles Here
class AppStyles {
    // Define Text Styles
  static const TextStyle titleLarge = TextStyle(fontSize: 15, fontWeight: FontWeight.bold,); // Headlines
  static const TextStyle bodyLarge = TextStyle(fontSize: 13,); // Normal text
  static const TextStyle bodyMedium = TextStyle(fontSize: 11,); // Smaller text
  static const TextStyle bodySmall = TextStyle(fontSize: 9,);
  static const TextStyle labelLarge = TextStyle(fontSize: 15, fontWeight: FontWeight.bold,); // Labels
  static const TextStyle labelMedium = TextStyle(fontSize: 13, fontWeight: FontWeight.w700,); // Labels
  static const TextStyle labelSmall = TextStyle(fontSize: 15, fontWeight: FontWeight.w700,); // Labels
  static const TextStyle displayLarge = TextStyle(fontSize: 20, fontWeight: FontWeight.bold,); // Big Ass Text

}

// Define a centralized Theme (Light Mode)
ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColors.darkColorScheme,

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

  // Force ThemeData to use the correct colour schemes because god forbid it actually uses the primary & secondary colours.
  // Fuck you Flutter.

  // Theme the App Bar
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkColorScheme.primary,
    foregroundColor: AppColors.darkColorScheme.onPrimary,
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkColorScheme.primary,
    selectedItemColor: AppColors.metroMaterial.shade500,
    unselectedItemColor: AppColors.metroMaterial.shade800,
  ),

  drawerTheme: DrawerThemeData(
    backgroundColor: AppColors.darkColorScheme.secondary,
  ),

  listTileTheme: ListTileThemeData(
    iconColor: AppColors.darkColorScheme.onPrimary,
    textColor: AppColors.darkColorScheme.onPrimary,

  ),

  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.darkColorScheme.primary,
    titleTextStyle: AppStyles.titleLarge,
    iconColor: AppColors.onSurface,
    contentTextStyle: AppStyles.bodyMedium,
  ),

  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: AppColors.darkColorScheme.onPrimary,
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      iconSize: WidgetStatePropertyAll(50)
    ),
  ),
);

// Define a centralized Theme (Dark Mode)
ThemeData darkAppTheme = appTheme;