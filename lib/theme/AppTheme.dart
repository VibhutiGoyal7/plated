import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AppColor.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.getFont('Almarai',
            fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        actionsIconTheme: const IconThemeData(color: AppColor.BLACK),
        iconTheme: const IconThemeData(color: AppColor.BLACK),
        backgroundColor: AppColor.WHITE,
      ),
      cardTheme: const CardTheme(color: AppColor.WHITE),
      primaryColor: AppColor.PRIMARY,
      highlightColor: AppColor.PRIMARY,
      scaffoldBackgroundColor: AppColor.BG_COLOR,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.getFont('Almarai',
            fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        displayMedium: GoogleFonts.getFont('Almarai',
            fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        displaySmall: GoogleFonts.getFont('Almarai',
            fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        titleLarge: GoogleFonts.getFont('Almarai',
            fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        titleMedium: GoogleFonts.getFont('Almarai',
            fontSize: 14, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        titleSmall: GoogleFonts.getFont('Almarai',
            fontSize: 12, fontWeight: FontWeight.bold, color: AppColor.BLACK),
        bodyLarge:
            GoogleFonts.getFont('Almarai', fontSize: 16, color: AppColor.BLACK),
        bodyMedium:
            GoogleFonts.getFont('Almarai', fontSize: 14, color: AppColor.BLACK),
        bodySmall: GoogleFonts.getFont('Almarai',
            fontSize: 12, color: AppColor.BLACK.withOpacity(0.4)),
      ),
      iconTheme: IconThemeData(color: AppColor.BLACK),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppColor.BODY_COLOR),
        foregroundColor: MaterialStateProperty.all<Color>(AppColor.WHITE),
      )),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColor.BODY_COLOR),
              foregroundColor: MaterialStateProperty.all<Color>(AppColor.WHITE),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))))),
      toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor: AppColor.BODY_COLOR,
        fillColor: AppColor.BODY_COLOR.withOpacity(0.1),
        textStyle: const TextStyle(color: AppColor.WHITE),
        selectedBorderColor: AppColor.BODY_COLOR,
        borderRadius: BorderRadius.circular(8.0),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColor.PRIMARY,
        onPrimary: AppColor.PRIMARY,
        secondary: AppColor.SECONDARY,
        onSecondary: AppColor.SECONDARY,
        surface: AppColor.BG_COLOR,
        onSurface: AppColor.BG_COLOR,
        error: Colors.red,
        onError: Colors.red,
        background: AppColor.BG_COLOR,
        onBackground: AppColor.BG_COLOR,
        brightness: Brightness.light,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.getFont('Almarai',
            fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.WHITE),
        actionsIconTheme: const IconThemeData(color: AppColor.SECONDARY),
        iconTheme: const IconThemeData(color: AppColor.WHITE),
        backgroundColor: AppColor.WHITE,
      ),
      cardTheme: const CardTheme(
        color: AppColor.DARK_CARD_COLOR,
      ),
      primaryColor: AppColor.PRIMARY,
      highlightColor: AppColor.PRIMARY,
      scaffoldBackgroundColor: AppColor.DARK_BG_COLOR,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.getFont(
          'Almarai',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.WHITE,
        ),
        displayMedium: GoogleFonts.getFont('Almarai',
            fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.WHITE),
        displaySmall: GoogleFonts.getFont('Almarai',
            fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.WHITE),
        titleLarge: GoogleFonts.getFont('Almarai',
            fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.WHITE),
        titleMedium: GoogleFonts.getFont('Almarai',
            fontSize: 14, fontWeight: FontWeight.bold, color: AppColor.WHITE),
        titleSmall: GoogleFonts.getFont('Almarai',
            fontSize: 12, fontWeight: FontWeight.bold, color: AppColor.WHITE),
        bodyLarge:
            GoogleFonts.getFont('Almarai', fontSize: 16, color: AppColor.WHITE),
        bodyMedium:
            GoogleFonts.getFont('Almarai', fontSize: 14, color: AppColor.WHITE),
        bodySmall: GoogleFonts.getFont('Almarai',
            fontSize: 12, color: AppColor.WHITE.withOpacity(0.7)),
      ),
      iconTheme: IconThemeData(color: AppColor.WHITE),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(AppColor.DARK_BG_COLOR),
        foregroundColor: MaterialStateProperty.all<Color>(AppColor.WHITE),
      )),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColor.DARK_BG_COLOR),
              foregroundColor: MaterialStateProperty.all<Color>(AppColor.WHITE),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))))),
      toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor: AppColor.DARK_BG_COLOR,
        fillColor: AppColor.DARK_BG_COLOR.withOpacity(0.1),
        textStyle: const TextStyle(color: AppColor.WHITE),
        selectedBorderColor: AppColor.DARK_BG_COLOR,
        borderRadius: BorderRadius.circular(8.0),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColor.PRIMARY,
        onPrimary: AppColor.PRIMARY,
        secondary: AppColor.SECONDARY,
        onSecondary: AppColor.SECONDARY,
        surface: AppColor.DARK_BG_COLOR,
        onSurface: AppColor.DARK_BG_COLOR,
        error: Colors.red,
        onError: Colors.red,
        background: AppColor.DARK_BG_COLOR,
        onBackground: AppColor.DARK_BG_COLOR,
        brightness: Brightness.dark,
      ),
    );
  }
}
