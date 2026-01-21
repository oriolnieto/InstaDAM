import 'package:flutter/material.dart';

class TemaClaro {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),

    // TextField
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black),
      floatingLabelStyle: TextStyle(color: Color(0xFF4CB7CD)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF4CB7CD),
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
            return const Color(0xFF4CB7CD);
          }
          return const Color(0xFF1F140F);
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return const Color(0xFF1F140F);
          }
          return const Color(0xFFFFFFFF);
        }),
      ),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF4CB7CD);
        }
        return const Color(0xFFFFFFFF);
      }),
      checkColor: WidgetStateProperty.all(const Color(0xFF1F140F)),
    ),
  );
}
