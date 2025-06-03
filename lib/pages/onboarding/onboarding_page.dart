import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/language/language_bloc.dart';
import '../../config/routes.dart';
import '../../utils/localization/app_localizations.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_bus, size: 100),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.translate('welcome')!,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                AppLocalizations.of(context)!.translate('onboarding_message')!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 32),
            BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, state) {
                Locale currentLocale = const Locale('en');
                if (state is LanguageChanged) {
                  currentLocale = state.locale;
                }
                return DropdownButton<Locale>(
                  value: currentLocale,
                  items: const [
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('sw'),
                      child: Text('Swahili'),
                    ),
                    DropdownMenuItem(
                      value: Locale('es'),
                      child: Text('Spanish'),
                    ),
                    DropdownMenuItem(
                      value: Locale('fr'),
                      child: Text('French'),
                    ),
                  ],
                  onChanged: (locale) {
                    if (locale != null) {
                      context.read<LanguageBloc>().add(ChangeLanguage(locale: locale));
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              child: Text(AppLocalizations.of(context)!.translate('get_started')!),
            ),
          ],
        ),
      ),
    );
  }
}