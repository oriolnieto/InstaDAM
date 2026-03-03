import 'package:flutter/material.dart';

final ThemeData temaOscuro = ThemeData(
  brightness: Brightness.dark,

  scaffoldBackgroundColor: const Color(0xFF000000),

  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0BD2E0),
    brightness: Brightness.dark,
  ),

  // TextField
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white),
    floatingLabelStyle: TextStyle(color: Color(0xFF0BD2E0)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFF0BD2E0),
        width: 2,
      ),
    ),
    border: OutlineInputBorder(),
  ),

  // ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFF0BD2E0);
        }
        return const Color(0xFFFFFFFF);
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFFFFFFFF);
        }
        return const Color(0xFF000000);
      }),
    ),
  ),

  // Checkbox
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF0BD2E0);
      }
      return const Color(0xFF000000);
    }),
    checkColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
  ),
);
