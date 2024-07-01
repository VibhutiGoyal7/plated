import 'package:flutter/material.dart';

import 'AppColor.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.WHITE,
        ),
        actionsIconTheme: const IconThemeData(color: AppColor.BLACK),
        iconTheme: const IconThemeData(color: AppColor.WHITE),
        backgroundColor: AppColor.BODY_COLOR,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColor.WHITE4,
      ),
      cardTheme: const CardTheme(color: AppColor.WHITE4),
      primaryColor: AppColor.PRIMARY,
      highlightColor: AppColor.PRIMARY,
      scaffoldBackgroundColor: AppColor.BG_COLOR,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.BLACK,
        ),
        displayMedium: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.BLACK,
        ),
        displaySmall: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.BLACK,
        ),
        titleLarge: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.BLACK,
        ),
        titleMedium: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColor.BLACK,
        ),
        titleSmall: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColor.BLACK,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 16,
          color: AppColor.BLACK,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 14,
          color: AppColor.BLACK,
        ),
        bodySmall: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 12,
          color: AppColor.BLACK.withOpacity(0.4),
        ),
      ),
      listTileTheme: ListTileThemeData(
          iconColor: AppColor.BLACK,
          textColor: AppColor.BLACK,
          selectedColor: AppColor.PRIMARY),
      dialogTheme: DialogTheme(
          backgroundColor: AppColor.WHITE,
          titleTextStyle: TextStyle(color: AppColor.BLACK, fontSize: 22),
          iconColor: AppColor.BLACK),
      iconTheme: IconThemeData(color: AppColor.BLACK),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        foregroundColor: MaterialStateProperty.all<Color>(AppColor.BLACK),
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
        titleTextStyle: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.WHITE,
        ),
        actionsIconTheme: const IconThemeData(color: AppColor.WHITE),
        iconTheme: const IconThemeData(color: AppColor.WHITE),
        backgroundColor: AppColor.BODY_COLOR,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColor.DARK_CARD_COLOR,
      ),
      cardTheme: const CardTheme(
        color: AppColor.DARK_CARD_COLOR,
      ),
      primaryColor: AppColor.PRIMARY,
      highlightColor: AppColor.PRIMARY,
      scaffoldBackgroundColor: AppColor.DARK_BG_COLOR,
      dialogTheme: DialogTheme(
        backgroundColor: AppColor.DARK_CARD_COLOR,
        titleTextStyle: TextStyle(color: AppColor.WHITE, fontSize: 22),
        iconColor: AppColor.WHITE,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.WHITE,
        ),
        displayMedium: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.WHITE,
        ),
        displaySmall: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.WHITE,
        ),
        titleLarge: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.WHITE,
        ),
        titleMedium: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColor.WHITE,
        ),
        titleSmall: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColor.WHITE,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 16,
          color: AppColor.WHITE,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 14,
          color: AppColor.WHITE,
        ),
        bodySmall: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 12,
          color: AppColor.WHITE.withOpacity(0.4),
        ),
      ),
      iconTheme: IconThemeData(color: AppColor.WHITE),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        foregroundColor: MaterialStateProperty.all<Color>(AppColor.WHITE),
      )),
      listTileTheme: ListTileThemeData(
          iconColor: AppColor.WHITE,
          textColor: AppColor.WHITE,
          selectedColor: AppColor.PRIMARY),
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
