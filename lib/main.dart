// lib/main.dart
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/repositories/booking_repository.dart';
import 'package:transport_booking/blocs/auth/auth_bloc.dart';
import 'package:transport_booking/blocs/language/language_bloc.dart';
import 'package:transport_booking/blocs/theme/theme_bloc.dart';
import 'package:transport_booking/config/routes.dart' as app_routes;
import 'package:transport_booking/config/theme.dart';
import 'package:transport_booking/repositories/auth_repository.dart';
import 'package:transport_booking/repositories/transport_repository.dart';
import 'package:transport_booking/repositories/user_repository.dart';
import 'package:transport_booking/services/api_service.dart';
import 'package:transport_booking/services/local_storage.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorage = LocalStorage();
  await localStorage.init();

  final token = await localStorage.getAuthToken();
  final isLoggedIn = token != null && token.isNotEmpty;

  // Check if onboarding has been completed
  final onboardingCompleted = await localStorage.getOnboardingCompleted();
  print('onboardingCompleted, ${onboardingCompleted}');

  final apiService = ApiService(localStorage: localStorage);
  final authRepository = AuthRepository(apiService: apiService, localStorage: localStorage);
  final transportRepository = TransportRepository(apiService: apiService);
  final bookingRepository = BookingRepository(apiService: apiService);
  final userRepository = UserRepository(apiService: apiService);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: localStorage),
        RepositoryProvider.value(value: apiService),
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: transportRepository),
        RepositoryProvider.value(value: bookingRepository),
        RepositoryProvider.value(value: userRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ThemeBloc(localStorage: localStorage)..add(LoadThemePreference()),
          ),
          BlocProvider(
            create: (_) => LanguageBloc(localStorage: localStorage)..add(LoadLanguagePreference()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(authRepository: authRepository)..add(isLoggedIn ? AuthAutoLogin() : AuthCheckStatus()),
          ),
          BlocProvider(
            create: (context) => BookingBloc(bookingRepository: bookingRepository),
          ),
        ],
        child: TransportBookingApp(showOnboarding: !onboardingCompleted,),
      ),
    ),
  );
}

class TransportBookingApp extends StatelessWidget {
  final bool showOnboarding;
  const TransportBookingApp({super.key, this.showOnboarding = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, languageState) {
            return MaterialApp(
              title: 'Multi-Transport Booking',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.themeMode,
              locale: languageState is LanguageChanged ? languageState.locale : const Locale('en', 'US'),
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('sw', 'TZ'),
                Locale('es', 'ES'),
                Locale('fr', 'FR'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              onGenerateRoute: app_routes.AppRoutes.generateRoute,
              initialRoute: showOnboarding ? app_routes.AppRoutes.onboarding : app_routes.AppRoutes.initialRoute,
            );
          },
        );
      },
    );
  }
}



// import 'package:flutter/material.dart' hide Route; // Add this line
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/repositories/booking_repository.dart';
// // import 'package:transport_booking/config/routes.dart';
//
// import 'blocs/auth/auth_bloc.dart';
// import 'blocs/language/language_bloc.dart';
// import 'blocs/theme/theme_bloc.dart';
// import 'config/routes.dart' as app_routes; // Rename the import
// import 'config/theme.dart';
// import 'repositories/auth_repository.dart';
// import 'repositories/transport_repository.dart';
// import 'services/api_service.dart';
// import 'services/local_storage.dart';
// import 'utils/localization/app_localizations.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final localStorage = LocalStorage();
//   await localStorage.init();
//
// // Check for existing token
//   final token = await localStorage.getAuthToken();
//   final isLoggedIn = token != null && token.isNotEmpty;
//
//   final apiService = ApiService(localStorage: localStorage); // ✅ Fix 1
//   final authRepository = AuthRepository(apiService: apiService, localStorage: localStorage);
//   final transportRepository = TransportRepository(apiService: apiService);
//   final bookingRepository = BookingRepository(apiService: apiService);
//
//   runApp(
//     MultiRepositoryProvider(
//       providers: [
//         RepositoryProvider.value(value: localStorage),
//         RepositoryProvider.value(value: apiService),
//         RepositoryProvider.value(value: authRepository),
//         RepositoryProvider.value(value: transportRepository),
//         RepositoryProvider.value(value: bookingRepository),
//
//       ],
//       child: MultiBlocProvider(
//         providers: [
//           // BlocProvider(
//           //   create: (context) => ThemeBloc(localStorage: localStorage),
//           // ),
//           // BlocProvider(
//           //   create: (context) => LanguageBloc(localStorage: localStorage),
//           // ),
//           BlocProvider(
//             create: (_) => ThemeBloc(localStorage: localStorage)..add(LoadThemePreference()),
//           ),
//           BlocProvider(
//             create: (_) => LanguageBloc(localStorage: localStorage)..add(LoadLanguagePreference()),
//           ),
//           BlocProvider(
//             create: (context) => AuthBloc(authRepository: authRepository)..add(isLoggedIn ? AuthAutoLogin() : AuthInitial()),
//           ),
//           BlocProvider(
//             create: (context) => BookingBloc(bookingRepository: bookingRepository),
//           ),
//
//         ],
//         child: const TransportBookingApp(),
//       ),
//     ),
//   );
// }
//
// class TransportBookingApp extends StatelessWidget {
//   const TransportBookingApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeBloc, ThemeState>(
//       builder: (context, themeState) {
//         return BlocBuilder<LanguageBloc, LanguageState>(
//           builder: (context, languageState) {
//             return MaterialApp(
//               title: 'Multi-Transport Booking',
//               debugShowCheckedModeBanner: false,
//               theme: AppTheme.lightTheme,
//               darkTheme: AppTheme.darkTheme,
//               themeMode: themeState.themeMode,
//               locale: languageState is LanguageChanged ? languageState.locale : const Locale('en', 'US'), // ✅ Fix 3
//               supportedLocales: const [
//                 Locale('en', 'US'), // English
//                 Locale('sw', 'TZ'), // Swahili
//                 Locale('es', 'ES'), // Spanish
//                 Locale('fr', 'FR'), // French
//               ],
//               localizationsDelegates: const [
//                 AppLocalizations.delegate,
//                 GlobalMaterialLocalizations.delegate,
//                 GlobalWidgetsLocalizations.delegate,
//                 GlobalCupertinoLocalizations.delegate,
//               ],
//               onGenerateRoute: app_routes.AppRoutes.generateRoute,
//               initialRoute: app_routes.AppRoutes.initialRoute,
//             );
//           },
//         );
//       },
//     );
//   }
// }