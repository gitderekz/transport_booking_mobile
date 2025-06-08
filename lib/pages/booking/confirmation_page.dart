// lib/pages/booking/confirmation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/config/routes.dart';
import 'package:transport_booking/models/booking.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';
import 'package:transport_booking/widgets/main_scaffold.dart';
import 'package:transport_booking/widgets/neu_button.dart';

class BookingConfirmationPage extends StatelessWidget {
  final Booking booking;

  const BookingConfirmationPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    if (booking == null) {
      return const Center(child: Text('Booking information not available'));
    }
    return MainScaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.primary.withOpacity(0.05),
                ],
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 32),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('booking_confirmed')!,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 60,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          booking.bookingReference,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.translate('confirmation_message')!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('booking_details')!,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          context,
                          Icons.directions_bus_outlined,
                          '${booking.route.transportName} (${booking.route.transportType})',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.route_outlined,
                          '${booking.route.origin} → ${booking.route.destination}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.directions_bus_outlined,
                          '${booking.route.origin} → ${booking.route.destination}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.calendar_today_outlined,
                          '${booking.date.day}/${booking.date.month}/${booking.date.year}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.event_seat_outlined,
                          '${booking.seats.length} ${AppLocalizations.of(context)!.translate('seats')}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.event_seat_outlined,
                          'Seats: ${booking.seats.map((s) => s['seat_number']).join(', ')}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.attach_money_outlined,
                          '\$${booking.totalPrice.toStringAsFixed(2)}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.person_outline,
                          'Passengers: ${booking.seats.map((s) => s['passenger_name']).join(', ')}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    NeuButton(
                      onPressed: () {
                        context.read<BookingBloc>().add(
                          DownloadTicket(bookingId: booking.bookingReference),
                        );
                      },
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate('download_ticket')!,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                              (route) => false,
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate('back_to_home')!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}



// // lib/pages/booking/confirmation_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/models/booking.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class BookingConfirmationPage extends StatelessWidget {
//   const BookingConfirmationPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final booking = ModalRoute.of(context)!.settings.arguments as Booking;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('confirmation')!),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.translate('booking_confirmed')!,
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     ),
//                     const SizedBox(height: 16),
//                     Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                       size: 80,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       booking.bookingReference,
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.translate('booking_details')!,
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildDetailRow(
//                       context,
//                       Icons.directions_bus,
//                       '${booking.route.origin} → ${booking.route.destination}',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.event,
//                       booking.date.toString(),
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.confirmation_number,
//                       '${booking.seats.length} ${AppLocalizations.of(context)!.translate('seats')}',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.attach_money,
//                       '\$${booking.totalPrice.toStringAsFixed(2)}',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   context.read<BookingBloc>().add(DownloadTicket(bookingId: booking.bookingReference));
//                 },
//                 child: Text(
//                   AppLocalizations.of(context)!.translate('download_ticket')!,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon),
//           const SizedBox(width: 16),
//           Text(text),
//         ],
//       ),
//     );
//   }
// }
// // *********************************************



// // lib/pages/booking/confirmation_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/models/booking.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
//
// class BookingConfirmationPage extends StatelessWidget {
//   const BookingConfirmationPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final booking = ModalRoute.of(context)!.settings.arguments as Booking;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('confirmation')!),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.translate('booking_confirmed')!,
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     ),
//                     const SizedBox(height: 16),
//                     Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                       size: 80,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       booking.bookingReference,
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.translate('booking_details')!,
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildDetailRow(
//                       context,
//                       Icons.directions_bus,
//                       '${booking.route.origin} → ${booking.route.destination}',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.event,
//                       booking.date.toString(),
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.confirmation_number,
//                       '${booking.seats.length} ${AppLocalizations.of(context)!.translate('seats')}',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.attach_money,
//                       '\$${booking.totalPrice.toStringAsFixed(2)}',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Implement download ticket functionality
//                   context.read<BookingBloc>().add(DownloadTicket(booking));
//                 },
//                 child: Text(
//                   AppLocalizations.of(context)!.translate('download_ticket')!,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon),
//           const SizedBox(width: 16),
//           Text(text),
//         ],
//       ),
//     );
//   }
// }