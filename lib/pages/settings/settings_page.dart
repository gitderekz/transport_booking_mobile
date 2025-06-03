import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/language/language_bloc.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../config/routes.dart';
import '../../utils/localization/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('settings')!),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('appearance')!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: Text(
                          AppLocalizations.of(context)!.translate('light_theme')!),
                      value: ThemeMode.light,
                      groupValue: state is ThemeChanged ? state.themeMode : ThemeMode.system,
                      onChanged: (value) {
                        if (value != null) {
                          // context.read<ThemeBloc>().add(ThemeChanged(value));
                          context.read<ThemeBloc>().add(ChangeTheme(themeMode: value));
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text(
                          AppLocalizations.of(context)!.translate('dark_theme')!),
                      value: ThemeMode.dark,
                      groupValue: state is ThemeChanged ? state.themeMode : ThemeMode.system,
                      onChanged: (value) {
                        if (value != null) {
                          // context.read<ThemeBloc>().add(ThemeChanged(value));
                          context.read<ThemeBloc>().add(ChangeTheme(themeMode: value));
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text(
                          AppLocalizations.of(context)!.translate('system_theme')!),
                      value: ThemeMode.system,
                      groupValue: state is ThemeChanged ? state.themeMode : ThemeMode.system,
                      onChanged: (value) {
                        if (value != null) {
                          // context.read<ThemeBloc>().add(ThemeChanged(value));
                          context.read<ThemeBloc>().add(ChangeTheme(themeMode: value));
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.translate('language')!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, state) {
                return Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('English'),
                      value: 'en',
                      groupValue: state is LanguageChanged ? state.locale.languageCode : 'en',
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<LanguageBloc>()
                              // .add(LanguageChanged(Locale(value)));
                              .add(ChangeLanguage(locale: Locale(value)));
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Swahili'),
                      value: 'sw',
                      groupValue: state is LanguageChanged ? state.locale.languageCode : 'en',
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<LanguageBloc>()
                              // .add(LanguageChanged(Locale(value)));
                              .add(ChangeLanguage(locale: Locale(value)));
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Spanish'),
                      value: 'es',
                      groupValue: state is LanguageChanged ? state.locale.languageCode : 'en',
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<LanguageBloc>()
                              // .add(LanguageChanged(Locale(value)));
                              .add(ChangeLanguage(locale: Locale(value)));
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('French'),
                      value: 'fr',
                      groupValue: state is LanguageChanged ? state.locale.languageCode : 'en',
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<LanguageBloc>()
                              // .add(LanguageChanged(Locale(value)));
                              .add(ChangeLanguage(locale: Locale(value)));
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.onboarding);
                      },
                      child: Text(
                          AppLocalizations.of(context)!.translate('logout')!),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}