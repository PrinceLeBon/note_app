import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.grey[100],
      primaryColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
        surface: Colors.white,
        background: Colors.grey[100]!,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: Colors.black87,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: Colors.black87,
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        //fillColor: Colors.grey[200],
        //filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: blackColor,
      primaryColor: blackColor,
      appBarTheme: AppBarTheme(
        backgroundColor: blackColor,
        elevation: 0,
        iconTheme: IconThemeData(color: whiteColor),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
        surface: Colors.grey[900]!,
        background: blackColor,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          color: whiteColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.poppins(
          color: whiteColor,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: whiteColor,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: whiteColor,
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.poppins(
          color: whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        //fillColor: Colors.grey[800],
        //filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: whiteColor,
        foregroundColor: blackColor,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: blackColor,
      ),
    );
  }
}
