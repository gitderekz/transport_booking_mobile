part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;

  const ChangeLanguage({required this.locale});

  @override
  List<Object> get props => [locale];
}

class LoadLanguagePreference extends LanguageEvent {}