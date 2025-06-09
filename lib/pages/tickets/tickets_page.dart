// --->lib/pages/tickets/tickets_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/models/booking.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
              const SizedBox(height: 16),
              GlassCard(
                borderRadius: 16,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.confirmation_number_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate('your_tickets')!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('manage_your_bookings')!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is InitialDataLoaded || state is BookingsLoaded) {
                    final bookings = state is InitialDataLoaded
                        ? state.bookings
                        : (state as BookingsLoaded).bookings;

                    if (bookings.isEmpty) {
                      return GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.confirmation_number_outlined,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!.translate('no_bookings')!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.translate('no_bookings_message')!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _buildBookingCard(context, bookings[index]),
                    );
                  } else if (state is BookingError) {
                    return GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<BookingBloc>().add(LoadBookings()),
                              child: Text(AppLocalizations.of(context)!.translate('try_again')!),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return GlassCard(
      borderRadius: 12,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/booking-details',
            arguments: {'booking': booking},
          );
        },
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status).withOpacity(0.1),
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
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                Icons.route_outlined,
                '${booking.route.origin} → ${booking.route.destination}',
              ),
              _buildDetailRow(
                context,
                Icons.calendar_today_outlined,
                '${booking.date.day}/${booking.date.month}/${booking.date.year} • ${booking.route.pickupTime}',
              ),
              _buildDetailRow(
                context,
                Icons.event_seat_outlined,
                '${booking.seats.length} ${booking.seats.length == 1 ? 'Seat' : 'Seats'}',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () => _showCancelDialog(context, booking.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      label: Text(AppLocalizations.of(context)!.translate('cancel')!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/booking-details',
                          arguments: {'booking': booking},
                        );
                      },
                      label: Text(AppLocalizations.of(context)!.translate('details')!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('confirm_cancel')!),
        content: Text(AppLocalizations.of(context)!.translate('cancel_booking_confirmation')!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.translate('no')!),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BookingBloc>().add(CancelBooking(bookingId: bookingId));
            },
            child: Text(AppLocalizations.of(context)!.translate('yes')!),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
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



// // lib/pages/tickets/tickets_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/models/booking.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
// import 'package:transport_booking/widgets/glass_card.dart';
//
// class TicketsPage extends StatefulWidget {
//   const TicketsPage({super.key});
//
//   @override
//   State<TicketsPage> createState() => _TicketsPageState();
// }
//
// class _TicketsPageState extends State<TicketsPage> {
//   @override
//   void initState() {
//     super.initState();
//     // context.read<BookingBloc>().add(LoadBookings());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Stack(
//       children: [
//         // Background gradient
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                 Theme.of(context).colorScheme.primary.withOpacity(0.05),
//               ],
//             ),
//           ),
//         ),
//
//         // Content
//         SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               GlassCard(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.confirmation_number_outlined,
//                         color: Theme.of(context).colorScheme.primary,
//                         size: 32,
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         AppLocalizations.of(context)!.translate('your_tickets')!,
//                         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               BlocBuilder<BookingBloc, BookingState>(
//                 builder: (context, state) {
//                   if (state is TicketsLoaded/*BookingLoading*/) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is InitialDataLoaded || state is BookingsLoaded || state is TicketsLoaded) {
//                     final bookings = state is InitialDataLoaded
//                         ? state.bookings
//                         : (state is BookingsLoaded
//                         ? state.bookings
//                         : (state as TicketsLoaded).bookings);
//
//                     return Column(
//                       children: bookings.map((booking) =>
//                           GlassCard(
//                             margin: const EdgeInsets.only(bottom: 16),
//                             child: _buildBookingCard(context, booking),
//                           ),
//                       ).toList(),
//                     );
//                   } else if (state is BookingError) {
//                     return Center(child: Text(state.message));
//                   }
//                   return Center(
//                     child: Text(
//                       AppLocalizations.of(context)!.translate('no_bookings')!,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBookingCard(BuildContext context, Booking booking) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Booking #${booking.bookingReference}',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _getStatusColor(booking.status),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   booking.status.toUpperCase(),
//                   style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildDetailRow(
//             context,
//             Icons.directions,
//             '${booking.route.origin} → ${booking.route.destination}',
//           ),
//           _buildDetailRow(
//             context,
//             Icons.calendar_today,
//             '${booking.date.day}/${booking.date.month}/${booking.date.year}',
//           ),
//           _buildDetailRow(
//             context,
//             Icons.event_seat,
//             booking.seats.isNotEmpty
//                 ? 'Seats: ${booking.seats.map((s) => s['seat_number']).join(', ')}'
//                 : 'No seats assigned',
//           ),
//           _buildDetailRow(
//             context,
//             Icons.attach_money,
//             'Total: Tsh ${booking.totalPrice.toStringAsFixed(2)}',
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text(AppLocalizations.of(context)!.translate('confirm_cancel')!),
//                         content: Text(AppLocalizations.of(context)!.translate('cancel_booking_confirmation')!),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: Text(AppLocalizations.of(context)!.translate('no')!),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               context.read<BookingBloc>().add(
//                                 CancelBooking(bookingId: booking.id),
//                               );
//                             },
//                             child: Text(AppLocalizations.of(context)!.translate('yes')!),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   style: OutlinedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     side: BorderSide(
//                       color: Theme.of(context).colorScheme.error,
//                     ),
//                   ),
//                   child: Text(
//                     AppLocalizations.of(context)!.translate('cancel')!,
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.error,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(
//                       context,
//                       '/booking-details',
//                       arguments: {'booking': booking},
//                     );
//                     // View ticket details
//                   },
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Text(
//                     AppLocalizations.of(context)!.translate('details')!,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 20,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//           const SizedBox(width: 12),
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
// }
