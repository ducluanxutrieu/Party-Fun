import 'package:flutter/material.dart';

class Constants {
  static const String ACCOUNT_MODEL_KEY = 'account_model_key';
  static const String LIST_DISH_MODEL_KEY = 'list_dish_model_key';
  static const String AUTH_HEADER = 'authorization';

  static const String USER_TOKEN = 'user_token';
  static const String LIST_CATEGORIES_KEY = 'list_categories_key';

  static const String DATE_TIME_FORMAT_SERVER = 'MM/dd/yyyy hh:mm';
  
}

// Colors
const kBackgroundColor = Color(0xFFFEFEFE);
const kTitleTextColor = Color(0xFF303030);
const kBodyTextColor = Color(0xFF4B4B4B);
const kTextLightColor = Color(0xFF959595);
const kInfectedColor = Color(0xFFFF8748);
const kDeathColor = Color(0xFFFF4848);
const kRecovercolor = Color(0xFF36C12C);
const kPrimaryColor = Color(0xFF3382CC);
final kShadowColor = Color(0xFFB7B7B7).withOpacity(.16);
final kActiveShadowColor = Color(0xFF4056C6).withOpacity(.15);

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

const kPrimaryTextStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black);
