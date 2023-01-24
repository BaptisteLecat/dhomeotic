import 'package:dhomeotic/theme/input_decoration_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';
import 'button_theme.dart';
import 'checkbox_themedata.dart';
import 'theme_data.dart';

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    brightness: Brightness.dark,
    primarySwatch: primaryMaterialColor,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: blackColor,
    iconTheme: const IconThemeData(color: Colors.white),
    elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonTheme(borderColor: whileColor20),
    textButtonTheme: textButtonThemeData,
    inputDecorationTheme: darkInputDecorationTheme,
    checkboxTheme: checkboxThemeData,
    appBarTheme: appBarDarkTheme,
    scrollbarTheme: scrollbarThemeData,
    dataTableTheme: dataTableDarkThemeData,
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      headline1: GoogleFonts.plusJakartaSansTextTheme().headline1!.copyWith(
            color: Colors.white,
          ),
      headline2: GoogleFonts.plusJakartaSansTextTheme().headline2!.copyWith(
            color: Colors.white,
          ),
      headline3: GoogleFonts.plusJakartaSansTextTheme().headline3!.copyWith(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
      headline4: GoogleFonts.plusJakartaSansTextTheme().headline4!.copyWith(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
      headline5: GoogleFonts.plusJakartaSansTextTheme().headline5!.copyWith(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
      headline6: GoogleFonts.plusJakartaSansTextTheme().headline6!.copyWith(
            color: Colors.white,
            fontSize: 17,
          ),
      subtitle1: GoogleFonts.plusJakartaSansTextTheme().subtitle1!.copyWith(
            color: Colors.white,
            fontSize: 19,
          ),
      subtitle2: GoogleFonts.plusJakartaSansTextTheme().subtitle2!.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
      bodyText1: GoogleFonts.plusJakartaSansTextTheme().bodyText1!.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
      bodyText2: GoogleFonts.plusJakartaSansTextTheme().bodyText2!.copyWith(
            color: Colors.white,
            fontSize: 14,
          ),
      button: GoogleFonts.plusJakartaSansTextTheme().button!.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
      caption: GoogleFonts.plusJakartaSansTextTheme().caption!.copyWith(
            color: Colors.grey,
            fontSize: 12,
          ),
    ),
  );
}
