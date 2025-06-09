// --->lib/pages/booking/details_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/models/booking.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';
import 'package:transport_booking/widgets/main_scaffold.dart';
import 'package:transport_booking/widgets/neu_button.dart';

class BookingDetailsPage extends StatelessWidget {
  final Booking booking;

  const BookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Stack(
        children: [
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Booking #${booking.bookingReference}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(booking.status).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getStatusColor(booking.status),
                                ),
                              ),
                              child: Text(
                                booking.status.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(booking.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildDetailSection(
                          context,
                          'Trip Details',
                          Icons.directions,
                          [
                            _buildDetailRow(
                              context,
                              Icons.route_outlined,
                              '${booking.route.origin} → ${booking.route.destination}',
                            ),
                            _buildDetailRow(
                              context,
                              Icons.directions_bus,
                              '${booking.route.transportName} (${booking.route.transportType?.toUpperCase()})',
                            ),
                            _buildDetailRow(
                              context,
                              Icons.calendar_today,
                              '${booking.date.day}/${booking.date.month}/${booking.date.year}',
                            ),
                            _buildDetailRow(
                              context,
                              Icons.access_time,
                              '${booking.route.pickupTime} - ${booking.route.dropoffTime}',
                            ),
                          ],
                        ),
                        _buildDetailSection(
                          context,
                          'Passenger Details',
                          Icons.people,
                          [
                            _buildDetailRow(
                              context,
                              Icons.event_seat,
                              'Seats: ${booking.seats.map((s) => s['seat_number']).join(', ')}',
                            ),
                            ...booking.seats.map((seat) => _buildDetailRow(
                              context,
                              Icons.person,
                              '${seat['passenger_name']} (Seat ${seat['seat_number']})',
                            )),
                          ],
                        ),
                        _buildDetailSection(
                          context,
                          'Payment Details',
                          Icons.payment,
                          [
                            _buildDetailRow(
                              context,
                              Icons.attach_money,
                              'Total: Tsh ${booking.totalPrice.toStringAsFixed(2)}',
                            ),
                            _buildDetailRow(
                              context,
                              Icons.credit_card,
                              'Payment Method: ${booking.paymentMethod?.toUpperCase() ?? 'CASH'}',
                            ),
                            if (booking.notes?.isNotEmpty ?? false)
                              _buildDetailRow(
                                context,
                                Icons.note,
                                'Notes: ${booking.notes}',
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getStatusColor(booking.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getStatusIcon(booking.status),
                                color: _getStatusColor(booking.status),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Status: ${booking.status.toUpperCase()}',
                                style: TextStyle(
                                  color: _getStatusColor(booking.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        NeuButton(
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context, String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
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
    final theme = Theme.of(context);

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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed': return Colors.green;
      case 'pending': return Colors.orange;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:transport_booking/models/booking.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
// import 'package:transport_booking/widgets/glass_card.dart';
// import 'package:transport_booking/widgets/main_scaffold.dart';
//
// class BookingDetailsPage extends StatelessWidget {
//   final Booking booking;
//
//   const BookingDetailsPage({super.key, required this.booking});
//
//   @override
//   Widget build(BuildContext context) {
//     return MainScaffold(
//       // appBar: AppBar(
//       //   title: Text(AppLocalizations.of(context)!.translate('booking_details')!),
//       // ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GlassCard(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Booking #${booking.bookingReference}',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildDetailRow(
//                       context,
//                       Icons.directions,
//                       '${booking.route.origin} → ${booking.route.destination}',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.directions_bus,
//                       '${booking.route.transportName} (${booking.route.transportType?.toUpperCase()})',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.calendar_today,
//                       '${booking.date.day}/${booking.date.month}/${booking.date.year}',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.access_time,
//                       '${booking.route.pickupTime} - ${booking.route.dropoffTime}',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.event_seat,
//                       'Seats: ${booking.seats.map((s) => s['seat_number']).join(', ')}',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.person,
//                       'Passengers: ${booking.seats.map((s) => s['passenger_name']).join(', ')}',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.attach_money,
//                       'Total: Tsh ${booking.totalPrice.toStringAsFixed(2)}',
//                     ),
//                     _buildDetailRow(
//                       context,
//                       Icons.payment,
//                       'Payment Method: ${booking.paymentMethod?.toUpperCase() ?? 'CASH'}',
//                     ),
//                     if (booking.notes?.isNotEmpty ?? false)
//                       _buildDetailRow(
//                         context,
//                         Icons.note,
//                         'Notes: ${booking.notes}',
//                       ),
//                     const SizedBox(height: 20),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: _getStatusColor(booking.status).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             _getStatusIcon(booking.status),
//                             color: _getStatusColor(booking.status),
//                           ),
//                           const SizedBox(width: 12),
//                           Text(
//                             'Status: ${booking.status.toUpperCase()}',
//                             style: TextStyle(
//                               color: _getStatusColor(booking.status),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
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
//           Icon(icon, color: Theme.of(context).colorScheme.primary),
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
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'confirmed':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'confirmed':
//         return Icons.check_circle;
//       case 'pending':
//         return Icons.pending;
//       case 'cancelled':
//         return Icons.cancel;
//       default:
//         return Icons.help_outline;
//     }
//   }
// }