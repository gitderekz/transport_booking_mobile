// // lib/blocs/theme/theme_bloc.dart
// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:transport_booking/services/local_storage.dart';
//
// part 'theme_event.dart';
// part 'theme_state.dart';
//
// class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
//   final LocalStorage localStorage;
//
//   ThemeBloc({required this.localStorage}) : super(ThemeInitial()) {
//     on<ChangeTheme>(_onChangeTheme);
//     on<LoadThemePreference>(_onLoadThemePreference);
//   }
//
//   FutureOr<void> _onChangeTheme(
//       ChangeTheme event,
//       Emitter<ThemeState> emit,
//       ) async {
//     await localStorage.saveThemePreference(event.themeMode.toString());
//     emit(ThemeChanged(themeMode: event.themeMode));
//   }
//
//   FutureOr<void> _onLoadThemePreference(
//       LoadThemePreference event,
//       Emitter<ThemeState> emit,
//       ) async {
//     final savedMode = await localStorage.getThemePreference();
//     final themeMode = _mapStringToThemeMode(savedMode);
//     emit(ThemeChanged(themeMode: themeMode));
//   }
//
//   ThemeMode _mapStringToThemeMode(String? mode) {
//     switch (mode) {
//       case 'ThemeMode.light':
//         return ThemeMode.light;
//       case 'ThemeMode.dark':
//         return ThemeMode.dark;
//       case 'ThemeMode.system':
//       default:
//         return ThemeMode.system;
//     }
//   }
// }
// // *******************************



import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:transport_booking/services/local_storage.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final LocalStorage localStorage;

  ThemeBloc({required this.localStorage}) : super(ThemeInitial()) {
    on<ChangeTheme>(_onChangeTheme);
    on<LoadThemePreference>(_onLoadThemePreference);
  }

  FutureOr<void> _onChangeTheme(
      ChangeTheme event,
      Emitter<ThemeState> emit,
      ) async {
    await localStorage.saveThemePreference(event.themeMode.name); // store 'light', 'dark', or 'system'
    emit(ThemeChanged(themeMode: event.themeMode));
  }

  FutureOr<void> _onLoadThemePreference(
      LoadThemePreference event,
      Emitter<ThemeState> emit,
      ) async {
    final savedMode = await localStorage.getThemePreference(); // returns 'light', 'dark', or 'system'

    final themeMode = _mapStringToThemeMode(savedMode);
    emit(ThemeChanged(themeMode: themeMode));
  }

  ThemeMode _mapStringToThemeMode(String? mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
// ****************************************



// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:transport_booking/services/local_storage.dart';
//
// part 'theme_event.dart';
// part 'theme_state.dart';
//
// class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
//   final LocalStorage localStorage;
//
//   ThemeBloc({required this.localStorage}) : super(ThemeInitial()) {
//     on<ChangeTheme>(_onChangeTheme);
//     on<LoadThemePreference>(_onLoadThemePreference);
//   }
//
//   FutureOr<void> _onChangeTheme(
//       ChangeTheme event,
//       Emitter<ThemeState> emit,
//       ) async {
//     await localStorage.saveThemePreference(event.isDarkMode);
//     emit(ThemeChanged(isDarkMode: event.isDarkMode));
//   }
//
//   FutureOr<void> _onLoadThemePreference(
//       LoadThemePreference event,
//       Emitter<ThemeState> emit,
//       ) async {
//     final isDarkMode = await localStorage.getThemePreference() ?? false;
//     emit(ThemeChanged(isDarkMode: isDarkMode));
//   }
// }