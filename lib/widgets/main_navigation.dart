import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/pages/home/home_page.dart';
import 'package:transport_booking/pages/home/search_page.dart';
import 'package:transport_booking/pages/profile/profile_page.dart';
import 'package:transport_booking/pages/routes/all_routes_page.dart';
import 'package:transport_booking/pages/tickets/tickets_page.dart';
import 'package:transport_booking/pages/tutorial/tutorial_overlay.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  final GlobalKey<NavigatorState> _searchNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<SearchPageState> _searchPageKey = GlobalKey<SearchPageState>();

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const AllRoutesPage(),
      Navigator(
        key: _searchNavigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => SearchPage(key: _searchPageKey), // ✅ attach key
            settings: settings,
          );
        },
      ),
      const TicketsPage(),
      const ProfilePage(),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TutorialOverlay.showTutorialIfNeeded(context);
    });
  }

  void handleSearchArguments(Map<String, dynamic>? args) {
    if (args != null) {
      setState(() => _currentIndex = 2);
      _searchNavigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SearchPage(),
          settings: RouteSettings(arguments: args),
        ),
      );
    }
  }
  // In your MainNavigation class, add this method:
  void navigateToSeatSelection(BuildContext context, Map<String, dynamic> args) {
    // Use root navigator for global routes
    Navigator.of(context, rootNavigator: true).pushNamed(
      '/booking/seats',
      arguments: args,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'main_fab',
      onPressed: () {
        setState(() => _currentIndex = 2);
        _searchNavigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SearchPage(),
          ),
        );
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6A3CBC), Color(0xFF461B93)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A3CBC).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.car_rental_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    final localizer = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BottomAppBar(
          height: 70,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          padding: EdgeInsets.zero,
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home_outlined, localizer.translate('home')!),
              _buildNavItem(context, 1, Icons.roundabout_right, localizer.translate('routes')??'routes'),
              const SizedBox(width: 40),
              _buildNavItem(context, 3, Icons.confirmation_num_outlined, localizer.translate('tickets')!),
              _buildNavItem(context, 4, Icons.person_outlined, localizer.translate('profile')!),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      // If leaving search tab
      if (_currentIndex == 2) {
        _searchPageKey.currentState?.restoreHomeData();
      }

      setState(() => _currentIndex = index);
    }
  }

//   void _onItemTapped(int index) {
//     if (_currentIndex != index) {
//       // If leaving search tab, restore home data
//       if (_currentIndex == 2) { // 2 is search tab index
//         final searchPageState = _pages[2] as Navigator;
//         final searchState = searchPageState.key?currentState?.widget.pages.first as SearchPage;
//         searchState.restoreHomeData();
//       }
//
//       setState(() => _currentIndex = index);
//     }
//   }
  // void _onItemTapped(int index) {
  //   if (_currentIndex != index) {
  //     // Reset booking state when switching away from search
  //     if (index != 2) { // 2 is the search tab index
  //       context.read<BookingBloc>().add(ResetToInitialState());
  //     }
  //     setState(() => _currentIndex = index);
  //   }
  // }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        // onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
// import 'package:transport_booking/config/routes.dart';
// import 'package:transport_booking/pages/home/home_page.dart';
// import 'package:transport_booking/pages/home/search_page.dart';
// import 'package:transport_booking/pages/profile/profile_page.dart';
// import 'package:transport_booking/pages/routes/all_routes_page.dart';
// import 'package:transport_booking/pages/tickets/tickets_page.dart';
// import 'package:transport_booking/pages/tutorial/tutorial_overlay.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class MainNavigation extends StatefulWidget {
//   const MainNavigation({super.key});
//
//   @override
//   State<MainNavigation> createState() => _MainNavigationState();
// }
//
// class _MainNavigationState extends State<MainNavigation> {
//   int _currentIndex = 0;
//   late final List<Widget> _pages;
//   final GlobalKey<NavigatorState> _searchNavigatorKey = GlobalKey<NavigatorState>();
//
//   @override
//   void initState() {
//     super.initState();
//     _pages = [
//       HomePage(),
//       AllRoutesPage(),
//       // SearchPage(),
//       Navigator(
//         key: _searchNavigatorKey,
//         onGenerateRoute: (settings) {
//           return MaterialPageRoute(
//             builder: (context) => SearchPage(),
//             settings: settings,
//           );
//         },
//       ),
//       TicketsPage(),
//       ProfilePage(),
//     ];
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       TutorialOverlay.showTutorialIfNeeded(context);
//     });
//   }
//
//   // Add this to handle deep linking to search with arguments
//   void _handleSearchArguments(Map<String, dynamic>? args) {
//     if (args != null && args['prefilledRoute'] != null) {
//       _currentIndex = 2; // Switch to search tab
//       _searchNavigatorKey.currentState?.pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => SearchPage(),
//           settings: RouteSettings(arguments: args),
//         ),
//       );
//     }
//   }
//
//   // Add this to handle route changes
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final route = ModalRoute.of(context);
//     if (route != null) {
//       // Check if we're coming from a deep link to search
//       if (route.settings.name == AppRoutes.search) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           setState(() => _currentIndex = 2); // Switch to search tab
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: SafeArea(
//         child: IndexedStack(
//           index: _currentIndex,
//           children: _pages,
//         ),
//       ),
//       floatingActionButton: _buildFloatingActionButton(context),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: _buildBottomAppBar(context),
//     );
//   }
//
//   Widget _buildFloatingActionButton(BuildContext context) {
//     return FloatingActionButton(
//       heroTag: 'main_fab',
//       onPressed: () => setState(() => _currentIndex = 2), // Go to search tab
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: const LinearGradient(
//             colors: [Color(0xFF6A3CBC), Color(0xFF461B93)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF6A3CBC).withOpacity(0.3),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: const Icon(Icons.car_rental_outlined, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildBottomAppBar(BuildContext context) {
//     final localizer = AppLocalizations.of(context)!;
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         child: BottomAppBar(
//           height: 70,
//           shape: const CircularNotchedRectangle(),
//           notchMargin: 8,
//           padding: EdgeInsets.zero,
//           color: Theme.of(context).colorScheme.surface,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(context, 0, Icons.home_outlined, localizer.translate('home')!),
//               _buildNavItem(context, 1, Icons.roundabout_right, localizer.translate('routes')??'routes'),
//               const SizedBox(width: 40),
//               _buildNavItem(context, 3, Icons.confirmation_num_outlined, localizer.translate('tickets')!),
//               _buildNavItem(context, 4, Icons.person_outlined, localizer.translate('profile')!),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
//     final isSelected = _currentIndex == index;
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Expanded(
//       child: InkWell(
//         onTap: () => setState(() => _currentIndex = index),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 size: 24,
//                 color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                 color: isSelected
//                     ? colorScheme.primary
//                     : colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // ************************************




// lib/widgets/main_navigation.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/theme/theme_bloc.dart';
// import 'package:transport_booking/config/routes.dart';
// import 'package:transport_booking/pages/home/home_page.dart';
// import 'package:transport_booking/pages/home/home_page.dart';
// import 'package:transport_booking/pages/home/home_page.dart';
// import 'package:transport_booking/pages/home/home_page.dart';
// import 'package:transport_booking/pages/home/search_page.dart';
// import 'package:transport_booking/pages/profile/profile_page.dart';
// import 'package:transport_booking/pages/tickets/tickets_page.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class MainNavigation extends StatefulWidget {
//   const MainNavigation({super.key});
//
//   @override
//   State<MainNavigation> createState() => _MainNavigationState();
// }
//
// class _MainNavigationState extends State<MainNavigation> {
//   int _currentIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         child: BottomAppBar(
//           height: 70,
//           shape: const CircularNotchedRectangle(),
//           notchMargin: 8,
//           padding: EdgeInsets.zero,
//           color: Theme.of(context).colorScheme.surface,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(context, 0, Icons.home_outlined, 'home'),
//               _buildNavItem(context, 1, Icons.search, 'search'),
//               const SizedBox(width: 40), // Space for FAB
//               _buildNavItem(context, 2, Icons.confirmation_num_outlined, 'tickets'),
//               _buildNavItem(context, 3, Icons.person_outlined, 'profile'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(BuildContext context, int index, IconData icon, String labelKey) {
//     final isSelected = _currentIndex == index;
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return Expanded(
//       child: InkWell(
//         onTap: () {
//           setState(() => _currentIndex = index);
//           switch (index) {
//             case 0:
//               Navigator.pushNamed(context, AppRoutes.home);
//               break;
//             case 1:
//               Navigator.pushNamed(context, AppRoutes.search);
//               break;
//             case 2:
//               Navigator.pushNamed(context, AppRoutes.tickets);
//               break;
//             case 3:
//               Navigator.pushNamed(context, AppRoutes.profile);
//               break;
//           }
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? colorScheme.primary.withOpacity(0.1)
//                     : Colors.transparent,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 size: 24,
//                 color: isSelected
//                     ? colorScheme.primary
//                     : colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               AppLocalizations.of(context)!.translate(labelKey)!,
//               style: theme.textTheme.labelSmall?.copyWith(
//                 color: isSelected
//                     ? colorScheme.primary
//                     : colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // **********************************

// // lib/widgets/main_navigation.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/theme/theme_bloc.dart';
// import 'package:transport_booking/config/routes.dart';
// import 'package:transport_booking/pages/home/home_page.dart';
// import 'package:transport_booking/pages/home/search_page.dart';
// import 'package:transport_booking/pages/profile/profile_page.dart';
// import 'package:transport_booking/pages/tickets/tickets_page.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class MainNavigation extends StatefulWidget {
//   const MainNavigation({Key? key}) : super(key: key);
//
//   @override
//   State<MainNavigation> createState() => _MainNavigationState();
// }
//
// class _MainNavigationState extends State<MainNavigation> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = const [
//     HomePage(),
//     SearchPage(),
//     TicketsPage(),
//     ProfilePage(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeBloc, ThemeState>(
//       builder: (context, state) {
//         final theme = Theme.of(context);
//         final isDark = state.themeMode == ThemeMode.dark ||
//             (state.themeMode == ThemeMode.system &&
//                 MediaQuery.of(context).platformBrightness == Brightness.dark);
//
//         return Scaffold(
//           extendBody: true,
//           body: SafeArea(child: _pages[_currentIndex]),
//           floatingActionButton: _buildFloatingActionButton(context),
//           floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//           bottomNavigationBar: _buildBottomAppBar(context, theme, isDark),
//         );
//       },
//     );
//   }
//
//   Widget _buildFloatingActionButton(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () => setState(() => _currentIndex = 1), // Quick access to search tab
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: const LinearGradient(
//             colors: [
//               Color(0xFF6A3CBC),
//               Color(0xFF461B93),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF6A3CBC).withOpacity(0.3),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: const Icon(Icons.search, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildBottomAppBar(BuildContext context, ThemeData theme, bool isDark) {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         child: BottomAppBar(
//           height: 70,
//           shape: const CircularNotchedRectangle(),
//           notchMargin: 8,
//           padding: EdgeInsets.zero,
//           color: isDark ? const Color(0xFF16213E) : theme.colorScheme.surface,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(context, 0, Icons.home_filled, 'home'),
//               _buildNavItem(context, 1, Icons.search, 'search'),
//               const SizedBox(width: 40), // Space for FAB
//               _buildNavItem(context, 2, Icons.confirmation_num, 'tickets'),
//               _buildNavItem(context, 3, Icons.person, 'profile'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(BuildContext context, int index, IconData icon, String labelKey) {
//     final isSelected = _currentIndex == index;
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return Expanded(
//       child: InkWell(
//         onTap: () => setState(() => _currentIndex = index),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? colorScheme.primary.withOpacity(0.1)
//                     : Colors.transparent,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 size: 24,
//                 color: isSelected
//                     ? colorScheme.primary
//                     : colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               AppLocalizations.of(context)!.translate(labelKey)!,
//               style: theme.textTheme.labelSmall?.copyWith(
//                 color: isSelected
//                     ? colorScheme.primary
//                     : colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // ******************************************

// // lib/widgets/main_navigation.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/theme/theme_bloc.dart';
// import 'package:transport_booking/config/routes.dart';
// import 'package:transport_booking/pages/home/home_page.dart';
// import 'package:transport_booking/pages/home/search_page.dart';
// import 'package:transport_booking/pages/profile/profile_page.dart';
// import 'package:transport_booking/pages/tickets/tickets_page.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class MainNavigation extends StatefulWidget {
//   const MainNavigation({Key? key}) : super(key: key);
//
//   @override
//   State<MainNavigation> createState() => _MainNavigationState();
// }
//
// class _MainNavigationState extends State<MainNavigation> {
//   int _currentIndex = 0;
//   late List<Widget> _pages;
//
//   @override
//   void initState() {
//     super.initState();
//     _pages = [
//       const HomePage(),
//       const SearchPage(),
//       const TicketsPage(),
//       const ProfilePage(),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: SafeArea(child: _pages[_currentIndex]),
//       floatingActionButton: _buildFloatingActionButton(context),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: _buildBottomAppBar(context),
//     );
//   }
//
//   Widget _buildFloatingActionButton(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: const LinearGradient(
//             colors: [
//               Color(0xFF6A3CBC),
//               Color(0xFF461B93),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF6A3CBC).withOpacity(0.3),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: const Icon(Icons.search, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildBottomAppBar(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         child: BottomAppBar(
//           height: 70,
//           shape: const CircularNotchedRectangle(),
//           notchMargin: 8,
//           padding: EdgeInsets.zero,
//           color: Theme.of(context).colorScheme.surface,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(context, 0, Icons.home_outlined, AppLocalizations.of(context)!.translate('home')!),
//               _buildNavItem(context, 1, Icons.search, AppLocalizations.of(context)!.translate('search')!),
//               const SizedBox(width: 40), // Space for FAB
//               _buildNavItem(context, 2, Icons.confirmation_num, AppLocalizations.of(context)!.translate('tickets')!),
//               _buildNavItem(context, 3, Icons.person_outline, AppLocalizations.of(context)!.translate('profile')!),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
//     final isSelected = _currentIndex == index;
//     final theme = Theme.of(context);
//
//     return Expanded(
//       child: InkWell(
//         onTap: () => setState(() => _currentIndex = index),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? theme.colorScheme.primary.withOpacity(0.1)
//                     : Colors.transparent,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 size: 24,
//                 color: isSelected
//                     ? theme.colorScheme.primary
//                     : theme.colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: theme.textTheme.labelSmall?.copyWith(
//                 color: isSelected
//                     ? theme.colorScheme.primary
//                     : theme.colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// *****************************



// // lib/widgets/main_navigation.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/theme/theme_bloc.dart';
// import 'package:transport_booking/config/routes.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class CustomBottomNav extends StatefulWidget {
//   const CustomBottomNav({super.key});
//
//   @override
//   State<CustomBottomNav> createState() => _CustomBottomNavState();
// }
//
// class _CustomBottomNavState extends State<CustomBottomNav> {
//   int _currentIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeBloc, ThemeState>(
//       builder: (context, state) {
//         final themeMode = state.themeMode;
//         final isDark = themeMode == ThemeMode.dark ||
//             (themeMode == ThemeMode.system &&
//                 MediaQuery.of(context).platformBrightness == Brightness.dark);
//
//         return Container(
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 20,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//             child: BottomAppBar(
//               height: 80,
//               shape: const CircularNotchedRectangle(),
//               notchMargin: 8,
//               padding: EdgeInsets.zero,
//               color: isDark ? const Color(0xFF16213E) : Colors.white,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildNavItem(context, 0, Icons.home_filled, 'home'),
//                   _buildNavItem(context, 1, Icons.search, 'search'),
//                   const SizedBox(width: 40), // Space for FAB
//                   _buildNavItem(context, 2, Icons.confirmation_num, 'tickets'),
//                   _buildNavItem(context, 3, Icons.person, 'profile'),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildNavItem(BuildContext context, int index, IconData icon, String labelKey) {
//     final isSelected = _currentIndex == index;
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return Expanded(
//       child: InkWell(
//         onTap: () {
//           setState(() => _currentIndex = index);
//           switch (index) {
//             case 0:
//               Navigator.pushNamed(context, AppRoutes.home);
//               break;
//             case 1:
//               Navigator.pushNamed(context, AppRoutes.search);
//               break;
//             case 2:
//               Navigator.pushNamed(context, AppRoutes.tickets);
//               break;
//             case 3:
//               Navigator.pushNamed(context, AppRoutes.profile);
//               break;
//           }
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? colorScheme.primary.withOpacity(0.1)
//                     : Colors.transparent,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 size: 24,
//                 color: isSelected
//                     ? colorScheme.primary
//                     : colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               AppLocalizations.of(context)!.translate(labelKey)!,
//               style: theme.textTheme.labelSmall?.copyWith(
//                 color: isSelected
//                     ? colorScheme.primary
//                     : colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // ************************************


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