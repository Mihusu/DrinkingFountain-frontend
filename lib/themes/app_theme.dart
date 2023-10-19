// Not used currently

// lib/themes/app_theme.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';

final ThemeData appThemeData = ThemeData(
  // Color Scheme
  colorScheme: const ColorScheme.light(
    primary: primaryButtonColor,
    secondary: secondaryButtonColor,
    background: draggableSheetColor,
    onBackground: listedItemTextColor,
  ),

  // Button themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryButtonColor,
      foregroundColor: primaryButtonTextColor,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: secondaryButtonTextColor,
      backgroundColor: secondaryButtonColor,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: tertiaryButtonTextColor,
      side: const BorderSide(color: tertiaryButtonBorderColor),
    ),
  ),

  // App Bar Theme
  appBarTheme: const AppBarTheme(
    color: bottomAppBarColor,
    iconTheme: IconThemeData(color: bottomAppBarIconColor),
  ),

  // Text Field Theme
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: inputTextFieldColor,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: inputTextFieldBorderColor),
    ),
    hintStyle: TextStyle(color: inputTextFieldSampleTextColor),
  ),

  // Default FontWeight for the entire theme
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyMedium: ThemeData.light().textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
        bodyLarge: ThemeData.light().textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
);
