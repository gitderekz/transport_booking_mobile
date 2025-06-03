import 'package:flutter/material.dart'hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/booking/booking_bloc.dart';
import '../../../models/route.dart';
import '../../../models/transport.dart';
import '../../../widgets/seat_widget.dart';

class SeatSelectionPage extends StatefulWidget {
  final Route route;
  final Transport transport;

  const SeatSelectionPage({
    super.key,
    required this.route,
    required this.transport,
  });

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final List<String> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Seats'),
        actions: [
          if (selectedSeats.isNotEmpty)
            TextButton(
              onPressed: () {
                context.read<BookingBloc>().add(BookingSeatsSelected(selectedSeats:selectedSeats));
                Navigator.pushNamed(
                  context,
                  '/booking/stops',
                  arguments: {
                    'route': widget.route,
                    'transport': widget.transport,
                    'selectedSeats': selectedSeats,
                  },
                );
              },
              child: Text(
                'Next (${selectedSeats.length})',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8),
                Text(
                  '${widget.route.origin} to ${widget.route.destination}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 24),
                _buildSeatLegend(),
                SizedBox(height: 16),
                _buildSeatMap(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Available', Colors.green),
        _buildLegendItem('Selected', Colors.blue),
        _buildLegendItem('Booked', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }

  Widget _buildSeatMap() {
    // In a real app, you'd use the actual seat layout from transport.seatLayout
    // This is a simplified example with a 4x10 grid

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 40,
      itemBuilder: (context, index) {
        final seatNumber = '${(index ~/ 4) + 1}${String.fromCharCode(65 + (index % 4))}';
        final isAvailable = true; // In real app, check against available seats
        final isSelected = selectedSeats.contains(seatNumber);

        return SeatWidget(
          seatNumber: seatNumber,
          status: isSelected
              ? SeatStatus.selected
              : isAvailable
              ? SeatStatus.available
              : SeatStatus.booked,
          onTap: isAvailable
              ? () {
            setState(() {
              if (isSelected) {
                selectedSeats.remove(seatNumber);
              } else {
                selectedSeats.add(seatNumber);
              }
            });
          }
              : null,
        );
      },
    );
  }
}