import 'package:flutter/material.dart';
import 'package:party_booking/res/assets.dart';

class LogoAppWidget extends StatelessWidget {
  final double mLogoSize;
  final String imageUrl;

  LogoAppWidget({this.mLogoSize = 150.0, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: imageUrl == null
          ? Image.asset(
              Assets.icLogoApp,
              fit: BoxFit.fill,
              height: mLogoSize,
            )
          : Image.network(
              imageUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
    );
  }
}
