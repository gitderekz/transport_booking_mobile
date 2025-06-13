import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/config/routes.dart';
import 'package:transport_booking/models/booking.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';
import 'package:transport_booking/widgets/main_scaffold.dart';
import 'package:transport_booking/widgets/neu_button.dart';
import 'package:share_plus/share_plus.dart';

class BookingConfirmationPage extends StatelessWidget {
  final Booking booking;

  const BookingConfirmationPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    // final booking = ModalRoute.of(context)!.settings.arguments as Booking?;

    if (booking == null) {
      return Scaffold(
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.translate('booking_not_found') ?? 'Booking information not available',
          ),
        ),
      );
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
                          '${booking.route.transportName} (${booking.route.transportType?.toUpperCase()})',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.route_outlined,
                          '${booking.route.origin} → ${booking.route.destination}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.calendar_today_outlined,
                          '${booking.date.day}/${booking.date.month}/${booking.date.year}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.access_time_outlined,
                          '${booking.route.pickupTime} - ${booking.route.dropoffTime}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.event_seat_outlined,
                          'Seats: ${booking.seats.map((s) => s['seat_number']).join(', ')}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.person_outline,
                          'Passengers: ${booking.seats.map((s) => s['passenger_name']).join(', ')}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.monetization_on_outlined,
                          'Total: Tsh ${booking.totalPrice.toStringAsFixed(2)}',
                        ),
                        _buildDetailRow(
                          context,
                          Icons.payment_outlined,
                          'Paid via: ${booking.paymentMethod?.toUpperCase() ?? 'CASH'}',
                        ),
                        if (booking.notes?.isNotEmpty ?? false)
                          _buildDetailRow(
                            context,
                            Icons.note_outlined,
                            'Notes: ${booking.notes}',
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    BlocConsumer<BookingBloc, BookingState>(
                      listener: (context, state) {
                        if (state is TicketDownloadSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.translate('ticket_downloaded')!,
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        } else if (state is TicketDownloadFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is TicketDownloadInProgress) {
                          return const CircularProgressIndicator();
                        }
                        return NeuButton(
                          onPressed: () async {
                            final pdfFile = await _generateTicketPdf(booking, context);
                            await Share.shareXFiles(
                              [XFile(pdfFile.path)],
                              text: 'Your booking ticket for ${booking.route.origin} to ${booking.route.destination}',
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
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.initialRoute,
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
          Icon(icon, color: Theme.of(context).colorScheme.primary),
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

  Future<File> _generateTicketPdf(Booking booking, BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Booking Confirmation',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Reference: ${booking.bookingReference}',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.Divider(),
              pw.Text(
                'Route: ${booking.route.origin} to ${booking.route.destination}',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.Text(
                'Transport: ${booking.route.transportName} (${booking.route.transportType?.toUpperCase()})',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.Text(
                'Date: ${booking.date.day}/${booking.date.month}/${booking.date.year}',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.Text(
                'Time: ${booking.route.pickupTime} - ${booking.route.dropoffTime}',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Passenger Details:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              ...booking.seats.map((seat) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Seat: ${seat['seat_number']}'),
                  pw.Text('Name: ${seat['passenger_name']}'),
                  if (seat['passenger_age'] != null)
                    pw.Text('Age: ${seat['passenger_age']}'),
                  if (seat['passenger_gender'] != null)
                    pw.Text('Gender: ${seat['passenger_gender']}'),
                  pw.Divider(),
                ],
              )),
              pw.SizedBox(height: 20),
              pw.Text(
                'Payment Details:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('Amount: Tsh ${booking.totalPrice.toStringAsFixed(2)}'),
              pw.Text('Method: ${booking.paymentMethod?.toUpperCase() ?? 'CASH'}'),
              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.BarcodeWidget(
                  data: booking.bookingReference,
                  barcode: pw.Barcode.qrCode(),
                  width: 150,
                  height: 150,
                ),
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/ticket_${booking.bookingReference}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}



// // lib/pages/booking/confirmation_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/config/routes.dart';
// import 'package:transport_booking/models/booking.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
// import 'package:transport_booking/widgets/glass_card.dart';
// import 'package:transport_booking/widgets/main_scaffold.dart';
// import 'package:transport_booking/widgets/neu_button.dart';
//
// class BookingConfirmationPage extends StatelessWidget {
//   final Booking booking;
//
//   const BookingConfirmationPage({super.key, required this.booking});
//
//   @override
//   Widget build(BuildContext context) {
//
//     if (booking == null) {
//       return Scaffold(
//         body: Center(
//           child: Text(
//             AppLocalizations.of(context)!.translate('booking_not_found') ?? 'Booking information not available',
//           ),
//         ),
//       );
//     }
//     return MainScaffold(
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Background gradient
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                   Theme.of(context).colorScheme.primary.withOpacity(0.05),
//                 ],
//               ),
//             ),
//           ),
//
//           // Content
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 const SizedBox(height: 32),
//                 GlassCard(
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       children: [
//                         Text(
//                           AppLocalizations.of(context)!.translate('booking_confirmed')!,
//                           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 16),
//                         Container(
//                           width: 100,
//                           height: 100,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.green.withOpacity(0.2),
//                           ),
//                           child: const Icon(
//                             Icons.check_circle,
//                             color: Colors.green,
//                             size: 60,
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         Text(
//                           booking.bookingReference,
//                           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           AppLocalizations.of(context)!.translate('confirmation_message')!,
//                           textAlign: TextAlign.center,
//                           style: Theme.of(context).textTheme.bodyLarge,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 GlassCard(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           AppLocalizations.of(context)!.translate('booking_details')!,
//                           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildDetailRow(
//                           context,
//                           Icons.directions_bus_outlined,
//                           '${booking.route.transportName} (${booking.route.transportType})',
//                         ),
//                         _buildDetailRow(
//                           context,
//                           Icons.route_outlined,
//                           '${booking.route.origin} → ${booking.route.destination}',
//                         ),
//                         _buildDetailRow(
//                           context,
//                           Icons.directions_bus_outlined,
//                           '${booking.route.origin} → ${booking.route.destination}',
//                         ),
//                         _buildDetailRow(
//                           context,
//                           Icons.calendar_today_outlined,
//                           '${booking.date.day}/${booking.date.month}/${booking.date.year}',
//                         ),
//                         _buildDetailRow(
//                           context,
//                           Icons.event_seat_outlined,
//                           '${booking.seats.length} ${AppLocalizations.of(context)!.translate('seats')}',
//                         ),
//                         _buildDetailRow(
//                           context,
//                           Icons.event_seat_outlined,
//                           'Seats: ${booking.seats.map((s) => s['seat_number']).join(', ')}',
//                         ),
//                         _buildDetailRow(
//                           context,
//                           Icons.attach_money_outlined,
//                           'Tsh ${booking.totalPrice.toStringAsFixed(2)}',
//                         ),
//                         _buildDetailRow(
//                           context,
//                           Icons.person_outline,
//                           'Passengers: ${booking.seats.map((s) => s['passenger_name']).join(', ')}',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Column(
//                   children: [
//                     NeuButton(
//                       onPressed: () {
//                         context.read<BookingBloc>().add(
//                           DownloadTicket(bookingId: booking.bookingReference),
//                         );
//                       },
//                       gradient: LinearGradient(
//                         colors: [
//                           Theme.of(context).colorScheme.primary,
//                           Theme.of(context).colorScheme.secondary,
//                         ],
//                       ),
//                       child: Text(
//                         AppLocalizations.of(context)!.translate('download_ticket')!,
//                         style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushNamedAndRemoveUntil(
//                           context,
//                           AppRoutes.home,
//                               (route) => false,
//                         );
//                       },
//                       child: Text(
//                         AppLocalizations.of(context)!.translate('back_to_home')!,
//                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 32),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               text,
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }