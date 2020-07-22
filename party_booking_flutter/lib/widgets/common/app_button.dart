import 'package:flutter/material.dart';
import 'package:party_booking/res/constants.dart';

class AppButtonWidget extends StatelessWidget {
  final Function buttonHandler;
  final String buttonText;
  final AppButtonState stateButton;

  AppButtonWidget(
      {Key key, this.buttonHandler, @required this.buttonText, this.stateButton = AppButtonState.None}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          onPressed: buttonHandler,
          child: setUpButtonChild()),
    );
  }

  Widget setUpButtonChild() {
    switch (stateButton) {
      case AppButtonState.None:
        return new Text(
          buttonText,
          textAlign: TextAlign.center,
          style: kPrimaryTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
        break;

      case AppButtonState.Loading:
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
        break;

      case AppButtonState.Success:
        return Icon(Icons.check, color: Colors.white);
        break;

      default:
        return Icon(Icons.error, color: Colors.white);
    }
  }
}

enum AppButtonState{
  None,
  Loading,
  Success,
  Error,
}
