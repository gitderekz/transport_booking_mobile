import 'package:flutter/material.dart';
import 'package:transport_booking/models/booking.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';

class BookingDetailsPage extends StatelessWidget {
  final Booking booking;

  const BookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('booking_details')!),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking #${booking.bookingReference}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      Icons.directions,
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
                    _buildDetailRow(
                      context,
                      Icons.event_seat,
                      'Seats: ${booking.seats.map((s) => s['seat_number']).join(', ')}',
                    ),
                    _buildDetailRow(
                      context,
                      Icons.person,
                      'Passengers: ${booking.seats.map((s) => s['passenger_name']).join(', ')}',
                    ),
                    _buildDetailRow(
                      context,
                      Icons.attach_money,
                      'Total: Tsh ${booking.totalPrice.toStringAsFixed(2)}',
                    ),
                    _buildDetailRow(
                      context,
                      Icons.payment,
                      'Payment Method: ${booking.paymentMethod?.toUpperCase() ?? 'CASH'}',
                    ),
                    if (booking.notes?.isNotEmpty ?? false)
                      _buildDetailRow(
                        context,
                        Icons.note,
                        'Notes: ${booking.notes}',
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
                  ],
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
}