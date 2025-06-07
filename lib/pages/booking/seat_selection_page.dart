// lib/pages/booking/seat_selection_page.dart
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/models/route.dart';
import 'package:transport_booking/models/transport.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';
import 'package:transport_booking/widgets/main_scaffold.dart';
import 'package:transport_booking/widgets/neu_button.dart';
import 'package:transport_booking/widgets/seat_widget.dart';

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
    return MainScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(AppLocalizations.of(context)!.translate('select_seats')!),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GlassCard(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.route.origin} → ${widget.route.destination}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSeatLegend(context),
                  const SizedBox(height: 24),
                  _buildSeatMap(context),
                  if (selectedSeats.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${selectedSeats.length} ${AppLocalizations.of(context)!.translate('seats_selected')!}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            NeuButton(
                              onPressed: () {
                                context.read<BookingBloc>().add(
                                  BookingSeatsSelected(selectedSeats: selectedSeats),
                                );
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
                              // style: ElevatedButton.styleFrom(
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(12),
                              //   ),
                              // ),
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate('continue')!,
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
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLegend(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem(
              context,
              AppLocalizations.of(context)!.translate('available')!,
              Colors.green,
            ),
            _buildLegendItem(
              context,
              AppLocalizations.of(context)!.translate('selected')!,
              Colors.blue,
            ),
            _buildLegendItem(
              context,
              AppLocalizations.of(context)!.translate('booked')!,
              Colors.red,
            ),
            _buildLegendItem(context,'Driver', Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String text, Color color) {
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
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSeatMapS(BuildContext context) {
    // 4 columns (2 pairs with space in between)
    const int columns = 4;
    const int rows = 10;
    const int driverSeatRow = 0;
    const int driverSeatCol = 3;

    // In a real app, you'd use the actual seat layout from transport.seatLayout
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 1,
            crossAxisSpacing: 16/*8*/,
            mainAxisSpacing: 8,
          ),
          itemCount: rows * columns/*40*/,
          itemBuilder: (context, index) {
            final row = index ~/ columns;
            final col = index % columns;
            final seatNumber = '${row + 1}${String.fromCharCode(65 + col)}';
            // final seatNumber = '${(index ~/ 4) + 1}${String.fromCharCode(65 + (index % 4))}';


            // Driver seat (first row, last column)
            if (row == driverSeatRow && col == driverSeatCol) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: const Icon(Icons.directions_bus, color: Colors.grey),
              );
            }

            // Space between seat pairs (column 1 and 2)
            if (col == 1 || col == 2) {
              return const SizedBox.shrink();
            }

            // Actual seats
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
        ),
      ),
    );
  }
  Widget _buildSeatMap(BuildContext context) {
    const int seatColumns = 4;
    const int totalColumns = 5; // 4 seats + 1 gap column
    const int rows = 10;
    const int driverSeatRow = 0;
    const int driverSeatCol = 4; // last column (in 5-column layout)

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: totalColumns,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: rows * totalColumns,
          itemBuilder: (context, index) {
            final row = index ~/ totalColumns;
            final col = index % totalColumns;

            // 1️⃣ Driver Seat, Driver Row (row 0)
            if (row == driverSeatRow) {
              if (col == driverSeatCol) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.directions_bus, color: Colors.grey),
                );
              } else {
                return const SizedBox.shrink();
              }
            }

            // 2️⃣ Add gap between columns 2 & 3
            if (col == 2) {
              return const SizedBox.shrink(); // Gap column
            }

            // 3️⃣ Seat layout (real columns: 0,1,3,4 → map to 0,1,2,3) , Seat numbering starts from row 1
            final displayCol = col > 2 ? col - 1 : col; // Shift col index if after gap
            final seatNumber = '${row}${String.fromCharCode(65 + displayCol)}';

            final isAvailable = true; // Replace with real logic
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
        ),
      ),
    );
  }


}



// import 'package:flutter/material.dart'hide Route;
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../blocs/booking/booking_bloc.dart';
// import '../../../models/route.dart';
// import '../../../models/transport.dart';
// import '../../../widgets/seat_widget.dart';
//
// class SeatSelectionPage extends StatefulWidget {
//   final Route route;
//   final Transport transport;
//
//   const SeatSelectionPage({
//     super.key,
//     required this.route,
//     required this.transport,
//   });
//
//   @override
//   State<SeatSelectionPage> createState() => _SeatSelectionPageState();
// }
//
// class _SeatSelectionPageState extends State<SeatSelectionPage> {
//   final List<String> selectedSeats = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Seats'),
//         actions: [
//           if (selectedSeats.isNotEmpty)
//             TextButton(
//               onPressed: () {
//                 context.read<BookingBloc>().add(BookingSeatsSelected(selectedSeats:selectedSeats));
//                 Navigator.pushNamed(
//                   context,
//                   '/booking/stops',
//                   arguments: {
//                     'route': widget.route,
//                     'transport': widget.transport,
//                     'selectedSeats': selectedSeats,
//                   },
//                 );
//               },
//               child: Text(
//                 'Next (${selectedSeats.length})',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//         ],
//       ),
//       body: BlocBuilder<BookingBloc, BookingState>(
//         builder: (context, state) {
//           if (state is BookingLoading) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           return SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   '${widget.route.origin} to ${widget.route.destination}',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 SizedBox(height: 24),
//                 _buildSeatLegend(),
//                 SizedBox(height: 16),
//                 _buildSeatMap(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildSeatLegend() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildLegendItem('Available', Colors.green),
//         _buildLegendItem('Selected', Colors.blue),
//         _buildLegendItem('Booked', Colors.red),
//       ],
//     );
//   }
//
//   Widget _buildLegendItem(String text, Color color) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//         SizedBox(width: 4),
//         Text(text),
//       ],
//     );
//   }
//
//   Widget _buildSeatMap() {
//     // In a real app, you'd use the actual seat layout from transport.seatLayout
//     // This is a simplified example with a 4x10 grid
//
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         childAspectRatio: 1,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//       ),
//       itemCount: 40,
//       itemBuilder: (context, index) {
//         final seatNumber = '${(index ~/ 4) + 1}${String.fromCharCode(65 + (index % 4))}';
//         final isAvailable = true; // In real app, check against available seats
//         final isSelected = selectedSeats.contains(seatNumber);
//
//         return SeatWidget(
//           seatNumber: seatNumber,
//           status: isSelected
//               ? SeatStatus.selected
//               : isAvailable
//               ? SeatStatus.available
//               : SeatStatus.booked,
//           onTap: isAvailable
//               ? () {
//             setState(() {
//               if (isSelected) {
//                 selectedSeats.remove(seatNumber);
//               } else {
//                 selectedSeats.add(seatNumber);
//               }
//             });
//           }
//               : null,
//         );
//       },
//     );
//   }
// }