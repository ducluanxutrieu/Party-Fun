import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:party_booking/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState());

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if(event is ChangeThemeEvent) {
      yield ThemeState(
          darkThemeEnabled: event.darkThemeEnabled);
      _saveDarkThemeToShared(event.darkThemeEnabled);
    } else if(event is GetThemeEvent) {
      bool darkThemeEnabled = await _getDarkTheme();
      yield ThemeState(darkThemeEnabled: darkThemeEnabled);
    }
  }

  Future<void> _saveDarkThemeToShared(bool darkThemeEnabled) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constants.DARK_THEME_ENABLED, darkThemeEnabled);
  }

  Future<bool> _getDarkTheme() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool darkThemeEnabled = sharedPreferences.getBool(Constants.DARK_THEME_ENABLED);
    if(darkThemeEnabled == null) darkThemeEnabled = false;
    return darkThemeEnabled;
  }
}
