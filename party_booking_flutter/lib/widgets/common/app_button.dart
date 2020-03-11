import 'package:flutter/material.dart';

class AppButtonWidget extends StatelessWidget {
  final Function buttonHandler;
  final String buttonText;
  final int stateButton;

  AppButtonWidget(
      {this.buttonHandler,
      @required this.buttonText,
      this.stateButton = 0});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: buttonHandler,
        child: setUpButtonChild()
      ),
    );
  }

  Widget setUpButtonChild() {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    switch (stateButton) {
      case 0:
        return new Text(
          buttonText,
          textAlign: TextAlign.center,
          style: style.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
        break;

      case 1:
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
        break;

      case 2:
        return Icon(Icons.check, color: Colors.white);
        break;

      default:
        return Icon(Icons.error, color: Colors.white);
    }
  }
}
