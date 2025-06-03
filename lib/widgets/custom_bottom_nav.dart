import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_bloc.dart';
import '../../config/routes.dart';
import '../../utils/localization/app_localizations.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        // final themeMode = state is ThemeLoadSuccess ? state.themeMode : ThemeMode.system;
        // final isDark = themeMode == ThemeMode.dark ||
        //     (themeMode == ThemeMode.system &&
        //         MediaQuery.of(context).platformBrightness == Brightness.dark);
        final themeMode = state.themeMode;
        final isDark = themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF6A3CBC), const Color(0xFF8253D7)]
                  : [const Color(0xFF461B93), const Color(0xFF6A3CBC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: AppLocalizations.of(context)!.translate('home')!,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: AppLocalizations.of(context)!.translate('search')!,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.confirmation_number),
                label: AppLocalizations.of(context)!.translate('tickets')!,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: AppLocalizations.of(context)!.translate('profile')!,
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, AppRoutes.home);
                  break;
                case 1:
                  Navigator.pushNamed(context, AppRoutes.search);
                  break;
                case 2:
                // Navigator.pushNamed(context, AppRoutes.tickets);
                  break;
                case 3:
                // Navigator.pushNamed(context, AppRoutes.profile);
                  break;
              }
            },
          ),
        );
      },
    );
  }
}