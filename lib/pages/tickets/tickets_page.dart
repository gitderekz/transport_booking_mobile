// lib/pages/tickets/tickets_page.dart
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
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(LoadBookings());
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
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
              const SizedBox(height: 16),
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.translate('your_tickets')!,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
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
                  } else if (state is BookingsLoaded) {
                    return Column(
                      children: state.bookings.map((booking) =>
                          GlassCard(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: _buildBookingCard(context, booking),
                          ),
                      ).toList(),
                    );
                  } else if (state is BookingError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate('no_bookings')!,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return Padding(
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
                  color: _getStatusColor(booking.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            context,
            Icons.directions,
            '${booking.route.origin} → ${booking.route.destination}',
          ),
          _buildDetailRow(
            context,
            Icons.calendar_today,
            '${booking.date.day}/${booking.date.month}/${booking.date.year}',
          ),
          _buildDetailRow(
            context,
            Icons.event_seat,
            booking.seats.isNotEmpty
                ? 'Seats: ${booking.seats.map((s) => s['seat_number']).join(', ')}'
                : 'No seats assigned',
          ),
          _buildDetailRow(
            context,
            Icons.attach_money,
            'Total: \$${booking.totalPrice.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<BookingBloc>().add(
                      CancelBooking(bookingId: booking.id),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('cancel')!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // View ticket details
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('details')!,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
// ***************************



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../blocs/booking/booking_bloc.dart';
// import '../../models/booking.dart';
// import '../../utils/localization/app_localizations.dart';
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
//     // TODO: implement initState
//     super.initState();
//     context.read<BookingBloc>().add(LoadBookings());
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('tickets')!),
//       ),
//       body: BlocBuilder<BookingBloc, BookingState>(
//         builder: (context, state) {
//           if (state is BookingLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is BookingsLoaded) {
//             return ListView.builder(
//               itemCount: state.bookings.length,
//               itemBuilder: (context, index) {
//                 final booking = state.bookings[index];
//                 return BookingCard(booking: booking);
//               },
//             );
//           } else if (state is BookingError) {
//             return Center(child: Text(state.message));
//           }
//           return const Center(child: Text('No bookings found'));
//         },
//       ),
//     );
//   }
// }
//
// class BookingCard extends StatelessWidget {
//   final Booking booking;
//
//   const BookingCard({super.key, required this.booking});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Booking #${booking.bookingReference}',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               booking.seats.isNotEmpty
//                   ? 'Seats: ${booking.seats.map((s) => s['seat_number']).join(', ')}'
//                   : 'No seats assigned',
//             ),
//             Text('Status: ${booking.status}'),
//             Text('Payment: ${booking.paymentStatus}'),
//             Text('Total: \$${booking.totalPrice.toStringAsFixed(2)}'),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 context.read<BookingBloc>().add(CancelBooking(bookingId: booking.id));
//               },
//               child: Text(AppLocalizations.of(context)!.translate('cancel')!),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }