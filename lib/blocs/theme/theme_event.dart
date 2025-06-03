part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final ThemeMode themeMode;

  const ChangeTheme({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

class LoadThemePreference extends ThemeEvent {}




// part of 'theme_bloc.dart';
//
// abstract class ThemeEvent extends Equatable {
//   const ThemeEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class ChangeTheme extends ThemeEvent {
//   final bool isDarkMode;
//
//   const ChangeTheme({required this.isDarkMode});
//
//   @override
//   List<Object> get props => [isDarkMode];
// }
//
// class LoadThemePreference extends ThemeEvent {}