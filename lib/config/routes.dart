import 'package:flutter/material.dart';
import 'package:transport_booking/models/booking.dart';
import 'package:transport_booking/pages/auth/login_page.dart';
import 'package:transport_booking/pages/auth/register_page.dart';
import 'package:transport_booking/pages/booking/confirmation_page.dart';
import 'package:transport_booking/pages/booking/details_page.dart';
import 'package:transport_booking/pages/booking/payment_page.dart';
import 'package:transport_booking/pages/booking/seat_selection_page.dart';
import 'package:transport_booking/pages/booking/stops_selection_page.dart';
import 'package:transport_booking/pages/help/help_page.dart';
import 'package:transport_booking/pages/home/home_page.dart';
import 'package:transport_booking/pages/home/search_page.dart';
import 'package:transport_booking/pages/onboarding/onboarding_page.dart';
import 'package:transport_booking/pages/privacy/privacy_page.dart';
import 'package:transport_booking/pages/profile/edit_profile_page.dart';
import 'package:transport_booking/pages/profile/profile_page.dart';
import 'package:transport_booking/pages/routes/all_routes_page.dart';
import 'package:transport_booking/pages/settings/settings_page.dart';
import 'package:transport_booking/pages/tickets/tickets_page.dart';
import 'package:transport_booking/widgets/main_navigation.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String home = '/home';
  static const String search = '/search';
  static const String tickets = '/tickets';
  static const String profile = '/profile';
  static const String seatSelection = '/booking/seats';
  static const String stopSelection = '/booking/stops';
  static const String payment = '/booking/payment';
  static const String setting = '/settings';
  static const String editProfile = '/profile/edit';
  static const String help = '/help';
  static const String privacy = '/privacy';
  static const String bookingConfirmation = '/booking/confirmation';
  static const String allRoutes = '/all-routes';
  static const String bookingDetails = '/booking-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case tickets:
        return MaterialPageRoute(builder: (_) => const TicketsPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());
      case help:
        return MaterialPageRoute(builder: (_) => const HelpPage());
      case privacy:
        return MaterialPageRoute(builder: (_) => const PrivacyPage());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case seatSelection:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SeatSelectionPage(
            route: args['route'],
            transport: args['transport'],
          ),
        );
      case stopSelection:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => StopsSelectionPage(
            route: args['route'],
            transport: args['transport'],
            selectedSeats: args['selectedSeats'],
          ),
        );
      case payment:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PaymentPage(
            route: args['route'],
            transport: args['transport'],
            selectedSeats: args['selectedSeats'],
            pickupStop: args['pickupStop'],
            dropoffStop: args['dropoffStop'],
          ),
        );
      case bookingConfirmation:
        final args = settings.arguments as Map<String, dynamic>;
        final booking = args['booking'] as Booking;
        return MaterialPageRoute(
          builder: (_) => BookingConfirmationPage(booking: booking),
        );
      case setting:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case allRoutes:
        return MaterialPageRoute(builder: (_) => const AllRoutesPage());
      case bookingDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BookingDetailsPage(booking: args['booking']),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}




// import 'package:flutter/material.dart';
// import 'package:transport_booking/pages/auth/login_page.dart';
// import 'package:transport_booking/pages/auth/register_page.dart';
// import 'package:transport_booking/pages/booking/payment_page.dart';
// import 'package:transport_booking/pages/booking/seat_selection_page.dart';
// import 'package:transport_booking/pages/booking/stops_selection_page.dart';
// import 'package:transport_booking/pages/home/home_page.dart';
// import 'package:transport_booking/pages/onboarding/onboarding_page.dart';
// import 'package:transport_booking/pages/settings/settings_page.dart';
//
// class AppRoutes {
//   static const String initialRoute = '/';
//   static const String home = '/home';
//   static const String login = '/auth/login';
//   static const String register = '/auth/register';
//   static const String settings = '/settings';
//   static const String seatSelection = '/booking/seats';
//   static const String stopSelection = '/booking/stops';
//   static const String payment = '/booking/payment';
//
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case initialRoute:
//         return MaterialPageRoute(builder: (_) => const OnboardingPage());
//       case home:
//         return MaterialPageRoute(builder: (_) => const HomePage());
//       case login:
//         return MaterialPageRoute(builder: (_) => const LoginPage());
//       case register:
//         return MaterialPageRoute(builder: (_) => const RegisterPage());
//       case settings:
//         return MaterialPageRoute(builder: (_) => const SettingsPage());
//       case seatSelection:
//         final args = settings.arguments as Map<String, dynamic>;
//         return MaterialPageRoute(
//           builder: (_) => SeatSelectionPage(
//             route: args['route'],
//             transport: args['transport'],
//           ),
//         );
//       case stopSelection:
//         final args = settings.arguments as Map<String, dynamic>;
//         return MaterialPageRoute(
//           builder: (_) => StopsSelectionPage(
//             route: args['route'],
//             transport: args['transport'],
//             selectedSeats: args['selectedSeats'],
//           ),
//         );
//       case payment:
//         final args = settings.arguments as Map<String, dynamic>;
//         return MaterialPageRoute(
//           builder: (_) => PaymentPage(
//             route: args['route'],
//             transport: args['transport'],
//             selectedSeats: args['selectedSeats'],
//             pickupStopId: args['pickupStopId'],
//             dropoffStopId: args['dropoffStopId'],
//           ),
//         );
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(
//               child: Text('No route defined for ${settings.name}'),
//             ),
//           ),
//         );
//     }
//   }
// }