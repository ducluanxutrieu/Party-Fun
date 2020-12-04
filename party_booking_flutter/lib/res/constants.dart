import 'package:flutter/material.dart';

class Constants {
  static const String ACCOUNT_MODEL_KEY = 'account_model_key';
  static const String LIST_DISH_MODEL_KEY = 'list_dish_model_key';
  static const String AUTH_HEADER = 'authorization';
  static const String DARK_THEME_ENABLED = 'dark_theme_enabled';

  static const String USER_TOKEN = 'user_token';
  static const String LIST_CATEGORIES_KEY = 'list_categories_key';

  static const String DATE_TIME_FORMAT_SERVER = 'MM/dd/yyyy hh:mm';

  static const String BASE_URL = 'https://partybooking.herokuapp.com/';
}

// Colors
const kBackgroundColor = Color(0xFFFEFEFE);
const kTitleTextColor = Color(0xFF303030);
const kBodyTextColor = Color(0xFF4B4B4B);
const kTextLightColor = Color(0xFF959595);
const kInfectedColor = Color(0xFFFF8748);
const kDeathColor = Color(0xFFFF4848);
const kRecovercolor = Color(0xFF36C12C);
const kPrimaryColor = Color(0xff8bc34a);
const kPrimaryDarkColor = Color(0xff1F1F1F);
final kShadowColor = Color(0xFFB7B7B7).withOpacity(.16);
final kActiveShadowColor = Color(0xFF4056C6).withOpacity(.15);

const kSecondaryLightColor = Color(0xFF80e27e);
const kSecondaryDarkColor = Color(0xFF404040);
const kAccentLightColor = Color(0xffbef67a);
const kAccentDarkColor = Color(0xFF4E4E4E);
const kBackgroundDarkColor = Color(0xFF121212);
const kSurfaceDarkColor = Color(0xFF1E1E1E);
// Icon Colors
const kAccentIconLightColor = Color(0xFF5a9216);
const kAccentIconDarkColor = Color(0xFF4caf50);
const kPrimaryIconLightColor = Color(0xFFECEFF5);
const kPrimaryIconDarkColor = Color(0xFF232323);
//text colors
const kBodyTextColorLight = Color(0xFF000000);
const kBodyTextColorDark = Color(0xFF7C7C7C);
const kTitleTextLightColor = Color(0xFF101112);
const kTitleTextDarkColor = Colors.white;

// Text Style
const kHeadingTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
);

const kSubTextStyle = TextStyle(fontSize: 16, color: kTextLightColor);

const kTitleTextstyle = TextStyle(
  fontSize: 23,
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);

const kPrimaryTextStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

//size
const kDefaultPadding = 20.0;
