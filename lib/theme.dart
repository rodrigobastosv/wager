import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: ColorScheme(
    background: Colors.grey.shade50,
    brightness: Brightness.light,
    error: Colors.red,
    onBackground: Colors.grey.shade800,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    primary: Colors.orange,
    secondary: Colors.orange.shade800,
    surface: Colors.grey.shade100,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade50,
    foregroundColor: Colors.grey.shade800,
    elevation: 0.5,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    isDense: true,
  ),
);
