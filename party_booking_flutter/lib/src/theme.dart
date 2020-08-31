import 'package:flutter/material.dart';
import 'package:party_booking/res/constants.dart';


// Our light/Primary Theme
ThemeData themeData(BuildContext context) {
  return ThemeData(
//    appBarTheme: appBarTheme,
    primaryColor: kPrimaryColor,
/*    accentColor: kAccentLightColor,
    scaffoldBackgroundColor: Colors.white,*/
    colorScheme: ColorScheme.light(
      secondary: kSecondaryLightColor,
      // on light theme surface = Colors.white by default
    ),
/*    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: kBodyTextColorLight),
    accentIconTheme: IconThemeData(color: kAccentIconLightColor),
    primaryIconTheme: IconThemeData(color: kPrimaryIconLightColor),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      bodyText1: TextStyle(color: kBodyTextColorLight, fontSize: 17),
      bodyText2: TextStyle(color: kBodyTextColorLight, fontSize: 20),
      headline4: TextStyle(color: kTitleTextLightColor, fontSize: 32),
      headline1: TextStyle(color: kTitleTextLightColor, fontSize: 80),
    ),*/
  );
}

// Dark Them
ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryDarkColor,
    /*accentColor: kAccentDarkColor,
    scaffoldBackgroundColor: Color(0xFF0D0C0E),
//    appBarTheme: appBarTheme,
    colorScheme: ColorScheme.light(
      secondary: kSecondaryDarkColor,
      surface: kSurfaceDarkColor,
      onSecondary: kPrimaryDarkColor
    ),
    backgroundColor: kBackgroundDarkColor,
    iconTheme: IconThemeData(color: kBodyTextColorDark),
    accentIconTheme: IconThemeData(color: kAccentIconDarkColor),
    primaryIconTheme: IconThemeData(color: kPrimaryIconDarkColor),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      bodyText1: TextStyle(color: kBodyTextColorDark, fontSize: 17),
      bodyText2: TextStyle(color: kBodyTextColorDark, fontSize: 20),
      headline4: TextStyle(color: kTitleTextDarkColor, fontSize: 32),
      headline1: TextStyle(color: kTitleTextDarkColor, fontSize: 80),
    ),*/
  );
}

//AppBarTheme appBarTheme = AppBarTheme(color: Colors.transparent, elevation: 0);
