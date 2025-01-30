import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AppColor.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    final baseTextStyle = GoogleFonts.getFont(
      'DM Sans',
      fontWeight: FontWeight.normal,
      color: AppColor.BLACK,
    );

    final titleTextStyle = GoogleFonts.getFont(
      'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: AppColor.BLACK,
      letterSpacing: 0.5,
    );

    return ThemeData(
      primaryColor: AppColor.PRIMARY_GREEN,
      secondaryHeaderColor: AppColor.PRIMARY_GREEN,
      scaffoldBackgroundColor: AppColor.WHITE,
      highlightColor: AppColor.GREY_TEXT_COLOR,
      focusColor: AppColor.BLACK,
      iconTheme: IconThemeData(color: AppColor.PRIMARY),
      hintColor: Colors.grey[500],
      cardColor: AppColor.WHITE,
      // AppBar
      appBarTheme: AppBarTheme(
        titleTextStyle: titleTextStyle,
        actionsIconTheme: IconThemeData(color: AppColor.BLACK),
        iconTheme: IconThemeData(color: AppColor.BLACK),
        backgroundColor: AppColor.BG_COLOR,
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColor.WHITE4,
      ),

      // TabBar
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.black,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black45,
        indicatorColor: Colors.black,
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      // Time Picker
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColor.WHITE,
        dialBackgroundColor: Colors.blue,
        dialHandColor: AppColor.WHITE,
        confirmButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        cancelButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
        hourMinuteColor: Colors.blue,
        timeSelectorSeparatorColor: MaterialStateProperty.all(Colors.transparent),
        entryModeIconColor: Colors.blue,
      ),

      // Popup Menu
      popupMenuTheme: PopupMenuThemeData(
        color: AppColor.PRIMARY,
      ),

      // Cards
      cardTheme: CardTheme(color: AppColor.WHITE),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: baseTextStyle.copyWith(fontSize: 20),
        displayMedium: baseTextStyle.copyWith(fontSize: 18),
        displaySmall: baseTextStyle.copyWith(fontSize: 18),
        titleLarge: baseTextStyle.copyWith(fontSize: 18),
        titleMedium: baseTextStyle.copyWith(fontSize: 14),
        titleSmall: baseTextStyle.copyWith(fontSize: 12),
        bodyLarge: baseTextStyle.copyWith(fontSize: 16),
        bodyMedium: baseTextStyle.copyWith(fontSize: 14),
        bodySmall: baseTextStyle.copyWith(fontSize: 12),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: baseTextStyle.copyWith(fontSize: 14, color: Colors.grey),
        iconColor: Colors.grey,
        suffixIconColor: AppColor.BLACK,
        prefixIconColor: AppColor.BLACK,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        iconColor: AppColor.BLACK,
        textColor: AppColor.BLACK,
        selectedColor: AppColor.PRIMARY,
      ),

      // Dialogs
      dialogTheme: DialogTheme(
        backgroundColor: AppColor.WHITE,
        titleTextStyle: baseTextStyle.copyWith(fontSize: 22),
        iconColor: AppColor.BLACK,
      ),

      // Date Picker
      datePickerTheme: DatePickerThemeData(
        dayStyle: TextStyle(color: Colors.black, fontSize: 12),
        shape: Border(),
      ),

      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(AppColor.PRIMARY),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColor.BODY_COLOR),
          foregroundColor: MaterialStateProperty.all(AppColor.WHITE),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
      ),

      // Toggle Buttons
      toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor: AppColor.BODY_COLOR,
        fillColor: AppColor.BODY_COLOR.withOpacity(0.1),
        textStyle: TextStyle(color: AppColor.WHITE),
        selectedBorderColor: AppColor.BODY_COLOR,
        borderRadius: BorderRadius.circular(8.0),
      ),

      // Color Scheme
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

      // Dropdown
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(color: Colors.black),
      ),
    );
  }


  static ThemeData getDarkTheme() {
    final baseTextStyle = GoogleFonts.getFont(
      'DM Sans',
      fontWeight: FontWeight.normal,
      color: AppColor.WHITE,
    );

    return ThemeData(
      primaryColor: AppColor.PRIMARY,
      scaffoldBackgroundColor: AppColor.DARK_BG_COLOR,
      highlightColor: AppColor.PRIMARY,
      secondaryHeaderColor: AppColor.BLACK,
      focusColor: AppColor.WHITE,
      hintColor: Colors.white70,
      cardColor: AppColor.BLACK,
      // AppBar
      appBarTheme: AppBarTheme(
        titleTextStyle: baseTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        actionsIconTheme: IconThemeData(color: AppColor.WHITE),
        iconTheme: IconThemeData(color: AppColor.WHITE),
        backgroundColor: AppColor.DARK_BG_COLOR,
      ),

      // Popup Menu
      popupMenuTheme: PopupMenuThemeData(
        color: AppColor.PRIMARY,
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColor.DARK_CARD_COLOR,
      ),

      // Date Picker
      datePickerTheme: DatePickerThemeData(
        dayStyle: TextStyle(color: Colors.white),
      ),

      // Cards
      cardTheme: CardTheme(color: AppColor.DARK_CARD_COLOR),

      // Dialogs
      dialogTheme: DialogTheme(
        backgroundColor: AppColor.DARK_CARD_COLOR,
        titleTextStyle: baseTextStyle.copyWith(fontSize: 22),
        iconColor: AppColor.WHITE,
      ),

      // TabBar
      tabBarTheme: TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white24,
        indicatorColor: Colors.white,
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: baseTextStyle.copyWith(fontSize: 20),
        displayMedium: baseTextStyle.copyWith(fontSize: 18),
        displaySmall: baseTextStyle.copyWith(fontSize: 18),
        titleLarge: baseTextStyle.copyWith(fontSize: 18),
        titleMedium: baseTextStyle.copyWith(fontSize: 14),
        titleSmall: baseTextStyle.copyWith(fontSize: 12),
        bodyLarge: baseTextStyle.copyWith(fontSize: 16),
        bodyMedium: baseTextStyle.copyWith(fontSize: 14),
        bodySmall: baseTextStyle.copyWith(fontSize: 12),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: baseTextStyle.copyWith(fontSize: 14, color: Colors.white70),
        iconColor: Colors.white70,
        suffixIconColor: AppColor.WHITE,
        prefixIconColor: AppColor.WHITE,
      ),

      // Icons
      iconTheme: IconThemeData(color: AppColor.WHITE),

      // Icon Buttons
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(AppColor.PRIMARY),
        ),
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        iconColor: AppColor.WHITE,
        textColor: AppColor.WHITE,
        selectedColor: AppColor.PRIMARY,
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColor.DARK_BG_COLOR),
          foregroundColor: MaterialStateProperty.all(AppColor.WHITE),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
      ),

      // Toggle Buttons
      toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor: AppColor.DARK_BG_COLOR,
        fillColor: AppColor.DARK_BG_COLOR.withOpacity(0.1),
        textStyle: TextStyle(color: AppColor.WHITE),
        selectedBorderColor: AppColor.DARK_BG_COLOR,
        borderRadius: BorderRadius.circular(8.0),
      ),

      // Color Scheme
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
