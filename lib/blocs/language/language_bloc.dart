import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:transport_booking/services/local_storage.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LocalStorage localStorage;

  LanguageBloc({required this.localStorage}) : super(LanguageInitial()) {
    on<ChangeLanguage>(_onChangeLanguage);
    on<LoadLanguagePreference>(_onLoadLanguagePreference);
  }

  FutureOr<void> _onChangeLanguage(
      ChangeLanguage event,
      Emitter<LanguageState> emit,
      ) async {
    await localStorage.saveLanguagePreference(event.locale.languageCode);
    emit(LanguageChanged(locale: event.locale));
  }

  FutureOr<void> _onLoadLanguagePreference(
      LoadLanguagePreference event,
      Emitter<LanguageState> emit,
      ) async {
    final languageCode = await localStorage.getLanguagePreference();
    final locale = languageCode != null
        ? Locale(languageCode)
        : const Locale('en');
    emit(LanguageChanged(locale: locale));
  }
}