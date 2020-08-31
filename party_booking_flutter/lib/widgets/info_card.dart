import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPressed;
  final bool isShowEdit;

  const InfoCard({Key key, this.text, this.icon, this.onPressed, this.isShowEdit = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.teal,
          ),
          title: Text(
            text,
            style: Theme.of(context).textTheme.headline6.copyWith(
              fontFamily: 'Source Sans Pro',
              fontSize: 18
            ),
          ),
          trailing: isShowEdit ? Icon(Icons.edit) : null,
        ),
      ),
    );
  }
}