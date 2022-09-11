part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class UpdateTheme extends ThemeEvent {
  final AppTheme appTheme;

  UpdateTheme({required this.appTheme});

  List<Object> get props => [appTheme];
}
