// lib/pages/booking/confirmation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/models/booking.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';

class BookingConfirmationPage extends StatelessWidget {
  const BookingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = ModalRoute.of(context)!.settings.arguments as Booking;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('confirmation')!),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('booking_confirmed')!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      booking.bookingReference,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('booking_details')!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      Icons.directions_bus,
                      '${booking.route.origin} → ${booking.route.destination}',
                    ),
                    _buildDetailRow(
                      context,
                      Icons.event,
                      booking.date.toString(),
                    ),
                    _buildDetailRow(
                      context,
                      Icons.confirmation_number,
                      '${booking.seats.length} ${AppLocalizations.of(context)!.translate('seats')}',
                    ),
                    _buildDetailRow(
                      context,
                      Icons.attach_money,
                      '\$${booking.totalPrice.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<BookingBloc>().add(DownloadTicket(bookingId: booking.bookingReference));
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('download_ticket')!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Text(text),
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