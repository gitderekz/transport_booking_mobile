// lib/widgets/custom_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/theme/theme_bloc.dart';
import 'package:transport_booking/config/routes.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final themeMode = state.themeMode;
        final isDark = themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);

        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BottomAppBar(
              height: 80,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              padding: EdgeInsets.zero,
              color: isDark ? const Color(0xFF16213E) : Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, 0, Icons.home_filled, 'home'),
                  _buildNavItem(context, 1, Icons.search, 'search'),
                  const SizedBox(width: 40), // Space for FAB
                  _buildNavItem(context, 2, Icons.confirmation_num, 'tickets'),
                  _buildNavItem(context, 3, Icons.person, 'profile'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String labelKey) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.search);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.tickets);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.profile);
              break;
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.translate(labelKey)!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../blocs/theme/theme_bloc.dart';
// import '../../config/routes.dart';
// import '../../utils/localization/app_localizations.dart';
//
// class CustomBottomNav extends StatelessWidget {
//   const CustomBottomNav({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeBloc, ThemeState>(
//       builder: (context, state) {
//         // final themeMode = state is ThemeLoadSuccess ? state.themeMode : ThemeMode.system;
//         // final isDark = themeMode == ThemeMode.dark ||
//         //     (themeMode == ThemeMode.system &&
//         //         MediaQuery.of(context).platformBrightness == Brightness.dark);
//         final themeMode = state.themeMode;
//         final isDark = themeMode == ThemeMode.dark ||
//             (themeMode == ThemeMode.system &&
//                 MediaQuery.of(context).platformBrightness == Brightness.dark);
//
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: isDark
//                   ? [const Color(0xFF6A3CBC), const Color(0xFF8253D7)]
//                   : [const Color(0xFF461B93), const Color(0xFF6A3CBC)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: BottomNavigationBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             selectedItemColor: Colors.white,
//             unselectedItemColor: Colors.white.withOpacity(0.7),
//             items: [
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.home),
//                 label: AppLocalizations.of(context)!.translate('home')!,
//               ),
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.search),
//                 label: AppLocalizations.of(context)!.translate('search')!,
//               ),
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.confirmation_number),
//                 label: AppLocalizations.of(context)!.translate('tickets')!,
//               ),
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.person),
//                 label: AppLocalizations.of(context)!.translate('profile')!,
//               ),
//             ],
//             onTap: (index) {
//               switch (index) {
//                 case 0:
//                   Navigator.pushNamed(context, AppRoutes.home);
//                   break;
//                 case 1:
//                   Navigator.pushNamed(context, AppRoutes.search);
//                   break;
//                 case 2:
//                 Navigator.pushNamed(context, AppRoutes.tickets);
//                   break;
//                 case 3:
//                 Navigator.pushNamed(context, AppRoutes.profile);
//                   break;
//               }
//             },
//           ),
//         );
//       },
//     );
//   }
// }