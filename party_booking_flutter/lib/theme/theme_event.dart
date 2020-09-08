part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class ChangeThemeEvent extends ThemeEvent {
  final bool darkThemeEnabled;

  ChangeThemeEvent(this.darkThemeEnabled);

  @override
  List<Object> get props => [darkThemeEnabled];
}

class GetThemeEvent extends ThemeEvent{}
