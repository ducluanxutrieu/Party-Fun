import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.yes),
              color: Color(0xff4CAF50),
              textColor: Colors.white,
              splashColor: Colors.grey,
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.abort),
              color: Color(0xff4CAF50),
              textColor: Colors.white,
              splashColor: Colors.grey,
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}
