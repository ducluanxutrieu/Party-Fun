import 'package:flutter/material.dart';
import 'package:party_booking/theme/theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DarkThemeWidget extends StatelessWidget {
  const DarkThemeWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous.darkThemeEnabled != current.darkThemeEnabled,
      builder: (context, state) {
        return SwitchListTile(
          title: Row(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.adjust,
                size: 28,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Dark Theme'),
              )
            ],
          ),
          onChanged: (value) => context
              .read<ThemeBloc>()
              .add(ChangeThemeEvent(value)),
          value: state.darkThemeEnabled,
        );
      },
    );
  }
}
