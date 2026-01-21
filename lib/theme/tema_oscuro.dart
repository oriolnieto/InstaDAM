import 'package:flutter/material.dart';

class TemaOscuro {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF000000),

    // TextField
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
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
          return const Color(0xFF4CB7CD);
        }
        return const Color(0xFF000000);
      }),
      checkColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
    ),
  );
}
