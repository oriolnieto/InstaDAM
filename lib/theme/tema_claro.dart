import 'package:flutter/material.dart';

final ThemeData temaClaro = ThemeData(
  brightness: Brightness.light,

  scaffoldBackgroundColor: const Color(0xFFFFFFFF),

  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4CB7CD),
    brightness: Brightness.light,
  ),

  // Card
  cardTheme: const CardThemeData(
    color: Color(0xFFFFFFFF),
    shadowColor: Color(0xFF4CB7CD),
    elevation: 3,
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),

  // Iconos
  iconTheme: const IconThemeData(
    color: Color(0xFF4CB7CD), // TODOS los iconos heredarán este color
  ),

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

  // FloatingActionButton
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF4CB7CD), // fondo
    foregroundColor: Colors.white,      // icono dentro
  ),

  // BottomAppBar
  bottomAppBarTheme: const BottomAppBarThemeData(
    color: Color(0xFF424242),
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
