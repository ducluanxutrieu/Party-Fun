import 'package:flutter/material.dart';
import 'package:party_booking/res/assets.dart';

class LogoAppWidget extends StatelessWidget {
  final double mLogoSize;
  LogoAppWidget({this.mLogoSize = 150.0});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        Assets.icLogoApp,
        fit: BoxFit.fill,
        height: mLogoSize,
      ),
    );
  }
}
