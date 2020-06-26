import 'package:flutter/material.dart';

class PickImageButton extends StatelessWidget {
  final Function loadAssets;

  const PickImageButton({Key key, this.loadAssets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle mStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightGreen,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          onPressed: loadAssets,
          child: Text(
            'Pick Dish Image',
            textAlign: TextAlign.center,
            style: mStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
