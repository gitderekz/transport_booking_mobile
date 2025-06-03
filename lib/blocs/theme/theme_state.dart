part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  ThemeMode get themeMode => ThemeMode.system;

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeChanged extends ThemeState {
  final ThemeMode themeMode;

  const ThemeChanged({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}
// ******************************



// part of 'theme_bloc.dart';
//
// abstract class ThemeState extends Equatable {
//   const ThemeState();
//
//   ThemeMode get themeMode => ThemeMode.system; // default fallback
//
//   @override
//   List<Object> get props => [];
// }
//
// class ThemeInitial extends ThemeState {}
//
// class ThemeChanged extends ThemeState {
//   final bool isDarkMode;
//
//   const ThemeChanged({required this.isDarkMode});
//
//   @override
//   List<Object> get props => [isDarkMode];
//
//   @override
//   ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;
// }
// // ***************************



// part of 'theme_bloc.dart';
//
// abstract class ThemeState extends Equatable {
//   const ThemeState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class ThemeInitial extends ThemeState {}
//
// class ThemeChanged extends ThemeState {
//   final bool isDarkMode;
//
//   const ThemeChanged({required this.isDarkMode});
//
//   @override
//   List<Object> get props => [isDarkMode];
// }