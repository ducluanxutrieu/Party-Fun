import 'package:flutter/material.dart';
import 'package:party_booking/res/assets.dart';

class LogoCheckWidget extends StatelessWidget {
  final double mLogoSize;
  LogoCheckWidget({this.mLogoSize = 100.0});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        Assets.icCheck,
        fit: BoxFit.fill,
        height: mLogoSize,
      ),
    );
  }
}
