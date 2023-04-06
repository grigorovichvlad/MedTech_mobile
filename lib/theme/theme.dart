import 'package:flutter/material.dart';

final defaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    bodyMedium: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 20,
    ),
    labelSmall: TextStyle(
      color: Colors.white.withOpacity(0.6),
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    headlineLarge: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 40,
    ),
  ),
);
