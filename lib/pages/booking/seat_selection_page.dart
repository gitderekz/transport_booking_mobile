// // lib/pages/booking/seat_selection_page.dart
// import 'package:flutter/material.dart' hide Route;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/models/route.dart';
// import 'package:transport_booking/models/transport.dart';
// import 'package:transport_booking/repositories/transport_repository.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
// import 'package:transport_booking/widgets/glass_card.dart';
// import 'package:transport_booking/widgets/main_scaffold.dart';
// import 'package:transport_booking/widgets/neu_button.dart';
// import 'package:transport_booking/widgets/seat_widget.dart';
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
//   List<List<Map<String, dynamic>>> seatArrangement = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSeatArrangement();
//   }
//
//   Future<void> _loadSeatArrangement() async {
//     final result = await context.read<TransportRepository>().getSeatArrangement(
//       transportId: widget.transport.id,
//       routeId: widget.route.id,
//     );
//
//     setState(() {
//       isLoading = false;
//       result.fold(
//             (failure) => ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(failure.message)),
//         ),
//             (arrangement) => seatArrangement = arrangement,
//       );
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MainScaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 180,
//             floating: true,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(AppLocalizations.of(context)!.translate('select_seats')!),
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Theme.of(context).colorScheme.primary.withOpacity(0.7),
//                       Theme.of(context).colorScheme.primary.withOpacity(0.3),
//                     ],
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GlassCard(
//                         margin: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
//                                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 '${widget.route.origin} → ${widget.route.destination}',
//                                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                   color: Colors.white.withOpacity(0.9),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   _buildSeatLegend(context),
//                   Row(children: [Expanded(child: Text('${widget.transport}'))],),
//                   const SizedBox(height: 24),
//                   _buildSeatMap(context),
//                   if (selectedSeats.isNotEmpty) ...[
//                     const SizedBox(height: 24),
//                     GlassCard(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '${selectedSeats.length} ${AppLocalizations.of(context)!.translate('seats_selected')!}',
//                               style: Theme.of(context).textTheme.titleMedium,
//                             ),
//                             NeuButton(
//                               onPressed: () {
//                                 context.read<BookingBloc>().add(
//                                   BookingSeatsSelected(selectedSeats: selectedSeats),
//                                 );
//                                 Navigator.pushNamed(
//                                   context,
//                                   '/booking/stops',
//                                   arguments: {
//                                     'route': widget.route,
//                                     'transport': widget.transport,
//                                     'selectedSeats': selectedSeats,
//                                   },
//                                 );
//                               },
//                               // style: ElevatedButton.styleFrom(
//                               //   shape: RoundedRectangleBorder(
//                               //     borderRadius: BorderRadius.circular(12),
//                               //   ),
//                               // ),
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Theme.of(context).colorScheme.primary,
//                                   Theme.of(context).colorScheme.secondary,
//                                 ],
//                               ),
//                               child: Text(
//                                 AppLocalizations.of(context)!.translate('continue')!,
//                                 style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                   const SizedBox(height: 60),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSeatLegend(BuildContext context) {
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildLegendItem(
//               context,
//               AppLocalizations.of(context)!.translate('available')!,
//               Colors.green,
//             ),
//             _buildLegendItem(
//               context,
//               AppLocalizations.of(context)!.translate('selected')!,
//               Colors.blue,
//             ),
//             _buildLegendItem(
//               context,
//               AppLocalizations.of(context)!.translate('booked')!,
//               Colors.red,
//             ),
//             _buildLegendItem(context,'Driver', Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLegendItem(BuildContext context, String text, Color color) {
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
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSeatMapS(BuildContext context) {
//     // 4 columns (2 pairs with space in between)
//     const int columns = 4;
//     const int rows = 10;
//     const int driverSeatRow = 0;
//     const int driverSeatCol = 3;
//
//     // In a real app, you'd use the actual seat layout from transport.seatLayout
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: columns,
//             childAspectRatio: 1,
//             crossAxisSpacing: 16/*8*/,
//             mainAxisSpacing: 8,
//           ),
//           itemCount: rows * columns/*40*/,
//           itemBuilder: (context, index) {
//             final row = index ~/ columns;
//             final col = index % columns;
//             final seatNumber = '${row + 1}${String.fromCharCode(65 + col)}';
//             // final seatNumber = '${(index ~/ 4) + 1}${String.fromCharCode(65 + (index % 4))}';
//
//
//             // Driver seat (first row, last column)
//             if (row == driverSeatRow && col == driverSeatCol) {
//               return Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.grey.withOpacity(0.2),
//                 ),
//                 child: const Icon(Icons.directions_bus, color: Colors.grey),
//               );
//             }
//
//             // Space between seat pairs (column 1 and 2)
//             if (col == 1 || col == 2) {
//               return const SizedBox.shrink();
//             }
//
//             // Actual seats
//             final isAvailable = true; // In real app, check against available seats
//             final isSelected = selectedSeats.contains(seatNumber);
//
//             return SeatWidget(
//               seatNumber: seatNumber,
//               status: isSelected
//                   ? SeatStatus.selected
//                   : isAvailable
//                   ? SeatStatus.available
//                   : SeatStatus.booked,
//               onTap: isAvailable
//                   ? () {
//                 setState(() {
//                   if (isSelected) {
//                     selectedSeats.remove(seatNumber);
//                   } else {
//                     selectedSeats.add(seatNumber);
//                   }
//                 });
//               }
//                   : null,
//             );
//           },
//         ),
//       ),
//     );
//   }
//   Widget _buildSeatMap(BuildContext context) {
//     const int seatColumns = 4;
//     const int totalColumns = 5; // 4 seats + 1 gap column
//     const int rows = 10;
//     const int driverSeatRow = 0;
//     const int driverSeatCol = 4; // last column (in 5-column layout)
//
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: totalColumns,
//             childAspectRatio: 1,
//             crossAxisSpacing: 8,
//             mainAxisSpacing: 8,
//           ),
//           itemCount: rows * totalColumns,
//           itemBuilder: (context, index) {
//             final row = index ~/ totalColumns;
//             final col = index % totalColumns;
//
//             // 1️⃣ Driver Seat, Driver Row (row 0)
//             if (row == driverSeatRow) {
//               if (col == driverSeatCol) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.grey.withOpacity(0.2),
//                   ),
//                   alignment: Alignment.center,
//                   child: const Icon(Icons.directions_bus, color: Colors.grey),
//                 );
//               } else {
//                 return const SizedBox.shrink();
//               }
//             }
//
//             // 2️⃣ Add gap between columns 2 & 3
//             if (col == 2) {
//               return const SizedBox.shrink(); // Gap column
//             }
//
//             // 3️⃣ Seat layout (real columns: 0,1,3,4 → map to 0,1,2,3) , Seat numbering starts from row 1
//             final displayCol = col > 2 ? col - 1 : col; // Shift col index if after gap
//             final seatNumber = '${row}${String.fromCharCode(65 + displayCol)}';
//
//             final isAvailable = true; // Replace with real logic
//             final isSelected = selectedSeats.contains(seatNumber);
//
//             return SeatWidget(
//               seatNumber: seatNumber,
//               status: isSelected
//                   ? SeatStatus.selected
//                   : isAvailable
//                   ? SeatStatus.available
//                   : SeatStatus.booked,
//               onTap: isAvailable
//                   ? () {
//                 setState(() {
//                   if (isSelected) {
//                     selectedSeats.remove(seatNumber);
//                   } else {
//                     selectedSeats.add(seatNumber);
//                   }
//                 });
//               }
//                   : null,
//             );
//           },
//         ),
//       ),
//     );
//   }
//   Widget _buildSeatMapSSS(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (seatArrangement.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 48, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               AppLocalizations.of(context)!.translate('failed_to_load_seats')??'failed_to_load_seats',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: _loadSeatArrangement,
//               child: Text(AppLocalizations.of(context)!.translate('retry')??'retry'),
//             ),
//           ],
//         ),
//       );
//     }
//
//     if (seatArrangement.isEmpty) {
//       return Center(
//         child: Text(AppLocalizations.of(context)!.translate('no_seats_available')??'no_seats_available'),
//       );
//     }
//
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Seat legend remains the same
//             const SizedBox(height: 16),
//             // Seat grid
//             Column(
//               children: seatArrangement.map((row) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: row.map((seat) {
//                       final seatNumber = seat['seat_number'];
//                       final isBooked = seat['booked'] ?? false;
//                       final isDriver = seatNumber == '1A'; // Adjust based on your layout
//
//                       if (isDriver) {
//                         return Container(
//                           width: 48,
//                           height: 48,
//                           margin: const EdgeInsets.symmetric(horizontal: 4),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey.withOpacity(0.2),
//                           ),
//                           child: const Icon(Icons.directions_bus, color: Colors.grey),
//                         );
//                       }
//
//                       final isSelected = selectedSeats.contains(seatNumber);
//
//                       return SeatWidget(
//                         seatNumber: seatNumber,
//                         status: isSelected
//                             ? SeatStatus.selected
//                             : isBooked
//                             ? SeatStatus.booked
//                             : SeatStatus.available,
//                         onTap: !isBooked
//                             ? () {
//                           setState(() {
//                             if (isSelected) {
//                               selectedSeats.remove(seatNumber);
//                             } else {
//                               selectedSeats.add(seatNumber);
//                             }
//                           });
//                         }
//                             : null,
//                       );
//                     }).toList(),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildSeatMapSSSS(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (seatArrangement.isEmpty) {
//       return Center(
//         child: Text(AppLocalizations.of(context)!.translate('no_seats_available')!),
//       );
//     }
//
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Seat legend
//             _buildSeatLegend(context),
//             const SizedBox(height: 16),
//
//             // Seat grid
//             Column(
//               children: seatArrangement.map((row) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: row.map((seat) {
//                       if (seat['seat_number'] == '1A') { // Driver seat
//                         return Container(
//                           width: 48,
//                           height: 48,
//                           margin: const EdgeInsets.symmetric(horizontal: 4),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey.withOpacity(0.2),
//                           ),
//                           child: const Icon(Icons.directions_bus, color: Colors.grey),
//                         );
//                       }
//
//                       final isBooked = seat['booked'] ?? false;
//                       final isSelected = selectedSeats.contains(seat['seat_number']);
//
//                       return SeatWidget(
//                         seatNumber: seat['seat_number'],
//                         status: isSelected
//                             ? SeatStatus.selected
//                             : isBooked
//                             ? SeatStatus.booked
//                             : SeatStatus.available,
//                         onTap: !isBooked
//                             ? () {
//                           setState(() {
//                             if (isSelected) {
//                               selectedSeats.remove(seat['seat_number']);
//                             } else {
//                               selectedSeats.add(seat['seat_number']);
//                             }
//                           });
//                         }
//                             : null,
//                       );
//                     }).toList(),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
// }


// // **********************************************************************************

// import 'package:flutter/material.dart' hide Route;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/models/route.dart';
// import 'package:transport_booking/models/transport.dart';
// import 'package:transport_booking/repositories/transport_repository.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
// import 'package:transport_booking/widgets/glass_card.dart';
// import 'package:transport_booking/widgets/main_scaffold.dart';
// import 'package:transport_booking/widgets/neu_button.dart';
// import 'package:transport_booking/widgets/seat_widget.dart';
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
//   List<List<Map<String, dynamic>>> seatArrangement = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSeatArrangement();
//   }
//
//   Future<void> _loadSeatArrangement() async {
//     try {
//       // First check if we already have seat arrangement data in the transport
//       if (widget.transport.seatArrangement != null) {
//         setState(() {
//           seatArrangement = widget.transport.seatArrangement!;
//           isLoading = false;
//         });
//         return;
//       }
//
//       // If not, fetch it from the API
//       final result = await context.read<TransportRepository>().getSeatArrangement(
//         transportId: widget.transport.id,
//         routeId: widget.route.id,
//       );
//
//       setState(() {
//         isLoading = false;
//         result.fold(
//               (failure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(failure.message)),
//             );
//             seatArrangement = [];
//           },
//               (arrangement) => seatArrangement = arrangement,
//         );
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load seat arrangement: $e')),
//         );
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MainScaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 180,
//             floating: true,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(AppLocalizations.of(context)!.translate('select_seats')!),
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Theme.of(context).colorScheme.primary.withOpacity(0.7),
//                       Theme.of(context).colorScheme.primary.withOpacity(0.3),
//                     ],
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GlassCard(
//                         margin: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
//                                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 '${widget.route.origin} → ${widget.route.destination}',
//                                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                   color: Colors.white.withOpacity(0.9),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _buildSeatSelectionContent(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSeatSelectionContent(BuildContext context) {
//     if (seatArrangement.isEmpty) {
//       return Center(
//         child: Text(AppLocalizations.of(context)!.translate('no_seats_available')??'no_seats_available'!),
//       );
//     }
//
//     return Column(
//       children: [
//         _buildSeatLegend(context),
//         const SizedBox(height: 24),
//         _buildSeatGrid(context),
//         if (selectedSeats.isNotEmpty) ...[
//           const SizedBox(height: 24),
//           _buildContinueButton(context),
//         ],
//         const SizedBox(height: 60),
//       ],
//     );
//   }
//
//   Widget _buildSeatLegend(BuildContext context) {
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildLegendItem(
//               context,
//               AppLocalizations.of(context)!.translate('available')!,
//               Colors.green,
//             ),
//             _buildLegendItem(
//               context,
//               AppLocalizations.of(context)!.translate('selected')!,
//               Colors.blue,
//             ),
//             _buildLegendItem(
//               context,
//               AppLocalizations.of(context)!.translate('booked')!,
//               Colors.red,
//             ),
//             _buildLegendItem(context,'Driver', Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLegendItem(BuildContext context, String text, Color color) {
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
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSeatGrid(BuildContext context) {
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: seatArrangement.map((row) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: row.map((seat) {
//                   final seatNumber = seat['seat_number'] as String;
//                   final isBooked = seat['booked'] as bool? ?? false;
//                   final isSelected = selectedSeats.contains(seatNumber);
//
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: SeatWidget(
//                       seatNumber: seatNumber,
//                       status: isSelected
//                           ? SeatStatus.selected
//                           : isBooked
//                           ? SeatStatus.booked
//                           : SeatStatus.available,
//                       onTap: !isBooked
//                           ? () {
//                         setState(() {
//                           if (isSelected) {
//                             selectedSeats.remove(seatNumber);
//                           } else {
//                             selectedSeats.add(seatNumber);
//                           }
//                         });
//                       }
//                           : null,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContinueButton(BuildContext context) {
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               '${selectedSeats.length} ${AppLocalizations.of(context)!.translate('seats_selected')!}',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             NeuButton(
//               onPressed: () {
//                 context.read<BookingBloc>().add(
//                   BookingSeatsSelected(selectedSeats: selectedSeats),
//                 );
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
//               gradient: LinearGradient(
//                 colors: [
//                   Theme.of(context).colorScheme.primary,
//                   Theme.of(context).colorScheme.secondary,
//                 ],
//               ),
//               child: Text(
//                 AppLocalizations.of(context)!.translate('continue')!,
//                 style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// &&&&&&&&&&&&&&&&&&&&&&&&& NZURI 2 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/models/route.dart';
import 'package:transport_booking/models/transport.dart';
import 'package:transport_booking/repositories/transport_repository.dart';
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
  List<List<Map<String, dynamic>>> seatArrangement = [];
  bool isLoading = true;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _loadSeatArrangement();
  }

  Future<void> _loadSeatArrangement() async {
    try {
      // First check if we already have seat arrangement data in the transport
      if (widget.transport.seatArrangement != null) {
        setState(() {
          seatArrangement = widget.transport.seatArrangement!;
          isLoading = false;
        });
        return;
      }

      // If not, fetch it from the API
      await _fetchSeatArrangement();
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load seat arrangement: $e')),
        );
      });
    }
  }

  Future<void> _fetchSeatArrangement() async {
    final result = await context.read<TransportRepository>().getSeatArrangement(
      transportId: widget.transport.id,
      routeId: widget.route.id,
    );

    setState(() {
      isLoading = false;
      result.fold(
            (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
          seatArrangement = [];
        },
            (arrangement) => seatArrangement = arrangement,
      );
    });
  }

  void _onRefresh() async {
    await _fetchSeatArrangement();
    _refreshController.refreshCompleted();
  }

  Widget _buildDriverOrOperatorIcon() {
    IconData icon;
    Color color;
    switch (widget.transport.type.toLowerCase()) {
      case 'bus':
        icon = Icons.directions_bus;
        color = Colors.orange;
        break;
      case 'train':
        icon = Icons.train;
        color = Colors.blue;
        break;
      case 'plane':
        icon = Icons.airplanemode_active;
        color = Colors.blueAccent;
        break;
      case 'ship':
        icon = Icons.directions_boat;
        color = Colors.blueGrey;
        break;
      default:
        icon = Icons.person;
        color = Colors.grey;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.2),
      ),
      child: Icon(icon, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: CustomScrollView(
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
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildSeatSelectionContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatSelectionContent(BuildContext context) {
    if (seatArrangement.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.translate('no_seats_available')??'no_seats_available'!),
      );
    }

    return Column(
      children: [
        _buildSeatLegendWithRefresh(context),
        const SizedBox(height: 24),
        _buildSeatGrid(context),
        if (selectedSeats.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildContinueButton(context),
        ],
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildSeatLegendWithRefresh(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
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
                  _buildLegendItem(
                    context,
                    widget.transport.type == 'bus'
                        ? AppLocalizations.of(context)!.translate('driver')??'driver'!
                        : AppLocalizations.of(context)!.translate('operator')??'operator'!,
                    Colors.orange,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _onRefresh,
              tooltip: AppLocalizations.of(context)!.translate('refresh')??'refresh'!,
            ),
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

  Widget _buildSeatGridS(BuildContext context) {
    final layoutType = widget.transport.layoutType;
    final hasMiddleAisle = layoutType.contains('-');
    final driverPosition = widget.transport.driverPosition;

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: seatArrangement.asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final row = entry.value;

            // Handle driver/operator position for first row
            if (rowIndex == 0) {
              return _buildFirstRowWithDriver(
                context,
                row,
                driverPosition,
                hasMiddleAisle,
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.asMap().entries.map((seatEntry) {
                  final seatIndex = seatEntry.key;
                  final seat = seatEntry.value;
                  final seatNumber = seat['seat_number'] as String;
                  final isBooked = seat['booked'] as bool? ?? false;
                  final isSelected = selectedSeats.contains(seatNumber);

                  // Add spacing based on layout type
                  if (hasMiddleAisle) {
                    final parts = layoutType.split('-');
                    final leftSeats = int.parse(parts[0]);
                    if (seatIndex == leftSeats) {
                      return const SizedBox(width: 24); // Aisle space
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SeatWidget(
                      seatNumber: seatNumber,
                      status: isSelected
                          ? SeatStatus.selected
                          : isBooked
                          ? SeatStatus.booked
                          : SeatStatus.available,
                      onTap: !isBooked
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
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // -------------------------------------------------------

  Widget _buildSeatGrid(BuildContext context) {
    final layout = widget.transport.seatLayout;
    final rows = layout['rows'] as int? ?? 0;
    final columns = layout['columns'] as int? ?? 0;
    final layoutType = layout['layout'] as String? ?? '2-2';
    final hasMiddleAisle = layoutType.contains('-');
    final aislePosition = hasMiddleAisle ? int.parse(layoutType.split('-')[0]) : 0;
    final driverPosition = layout['driver_position'] as String? ?? 'right';

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1️⃣ Driver/Operator Row (always first)
            _buildDriverRow(driverPosition, columns, aislePosition, hasMiddleAisle),

            // 2️⃣ Passenger Seats
            ...seatArrangement.asMap().entries.map((entry) {
              final rowIndex = entry.key;
              final row = entry.value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left seats
                    ...row.take(aislePosition).map((seat) => _buildSeatWidget(seat)),

                    // Aisle space
                    if (hasMiddleAisle) const SizedBox(width: 24),

                    // Right seats
                    ...row.skip(aislePosition).map((seat) => _buildSeatWidget(seat)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverRow(String driverPosition, int columns, int aislePosition, bool hasMiddleAisle) {
    final isRight = driverPosition == 'right' ||
        (driverPosition != 'left' && widget.transport.type == 'bus');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left space
          if (isRight) ...[
            ...List.generate(aislePosition, (i) => const SizedBox(width: 48)),
            if (hasMiddleAisle) const SizedBox(width: 24),
          ],

          // Driver/Operator icon
          _buildDriverOrOperatorIcon(),

          // Right space
          if (!isRight) ...[
            if (hasMiddleAisle) const SizedBox(width: 24),
            ...List.generate(columns - aislePosition - 1, (i) => const SizedBox(width: 48)),
          ],
        ],
      ),
    );
  }

  Widget _buildSeatWidget(Map<String, dynamic> seat) {
    final seatNumber = seat['seat_number'] as String;
    final isBooked = seat['booked'] as bool? ?? false;
    final isSelected = selectedSeats.contains(seatNumber);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SeatWidget(
        seatNumber: seatNumber,
        status: isSelected
            ? SeatStatus.selected
            : isBooked
            ? SeatStatus.booked
            : SeatStatus.available,
        onTap: !isBooked
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
      ),
    );
  }

  Widget _buildDriverOrOperatorIconS() {
    IconData icon;
    Color color;
    switch (widget.transport.type.toLowerCase()) {
      case 'bus':
        icon = Icons.directions_bus;
        color = Colors.orange;
        break;
      case 'train':
        icon = Icons.train;
        color = Colors.blue;
        break;
      case 'plane':
        icon = Icons.airplanemode_active;
        color = Colors.blueAccent;
        break;
      case 'ship':
        icon = Icons.directions_boat;
        color = Colors.blueGrey;
        break;
      default:
        icon = Icons.person;
        color = Colors.grey;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.2),
      ),
      child: Icon(icon, color: color),
    );
  }

  // -------------------------------------------------------


  Widget _buildFirstRowWithDriver(BuildContext context, List<Map<String, dynamic>> row, String? driverPosition, bool hasMiddleAisle,) {
    final layoutType = widget.transport.layoutType;
    final parts = hasMiddleAisle ? layoutType.split('-') : [];
    final leftSeats = hasMiddleAisle ? int.parse(parts[0]) : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left seats
          ...row.take(leftSeats).toList().asMap().entries.map((entry) {
            final seatIndex = entry.key;
            final seat = entry.value;
            final seatNumber = seat['seat_number'] as String;
            final isBooked = seat['booked'] as bool? ?? false;
            final isSelected = selectedSeats.contains(seatNumber);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SeatWidget(
                seatNumber: seatNumber,
                status: isSelected
                    ? SeatStatus.selected
                    : isBooked
                    ? SeatStatus.booked
                    : SeatStatus.available,
                onTap: !isBooked
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
              ),
            );
          }),

          // Aisle space or driver position
          if (hasMiddleAisle) const SizedBox(width: 24),

          // Driver/operator icon position
          if (driverPosition == 'right' ||
              (driverPosition == null && widget.transport.type == 'bus'))
            _buildDriverOrOperatorIcon(),

          // Right seats
          ...row.skip(leftSeats).toList().asMap().entries.map((entry) {
            final seatIndex = entry.key;
            final seat = entry.value;
            final seatNumber = seat['seat_number'] as String;
            final isBooked = seat['booked'] as bool? ?? false;
            final isSelected = selectedSeats.contains(seatNumber);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SeatWidget(
                seatNumber: seatNumber,
                status: isSelected
                    ? SeatStatus.selected
                    : isBooked
                    ? SeatStatus.booked
                    : SeatStatus.available,
                onTap: !isBooked
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
              ),
            );
          }),

          // For non-bus transports, show operator in center if no position specified
          if (driverPosition == null && widget.transport.type != 'bus')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildDriverOrOperatorIcon(),
            ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return GlassCard(
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
    );
  }
}
// // &&&&&&&&&&& NZURI 3 &&&&&&&&&&&&&&
// import 'package:flutter/material.dart' hide Route;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/models/route.dart';
// import 'package:transport_booking/models/transport.dart';
// import 'package:transport_booking/repositories/transport_repository.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
// import 'package:transport_booking/widgets/glass_card.dart';
// import 'package:transport_booking/widgets/main_scaffold.dart';
// import 'package:transport_booking/widgets/neu_button.dart';
// import 'package:transport_booking/widgets/seat_widget.dart';
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
//   List<List<Map<String, dynamic>>> seatArrangement = [];
//   bool isLoading = true;
//   final RefreshController _refreshController = RefreshController(initialRefresh: false);
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSeatArrangement();
//   }
//
//   Future<void> _loadSeatArrangement() async {
//     try {
//       final result = await context.read<TransportRepository>().getSeatArrangement(
//         transportId: widget.transport.id,
//         routeId: widget.route.id,
//       );
//
//       setState(() {
//         isLoading = false;
//         result.fold(
//               (failure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(failure.message)),
//             );
//             seatArrangement = [];
//           },
//               (arrangement) => seatArrangement = arrangement,
//         );
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load seat arrangement: $e')),
//         );
//       });
//     }
//   }
//
//   void _onRefresh() async {
//     await _loadSeatArrangement();
//     _refreshController.refreshCompleted();
//   }
//
//   Widget _buildDriverOrOperatorRow() {
//     IconData icon;
//     Color color;
//     switch (widget.transport.type.toLowerCase()) {
//       case 'bus':
//         icon = Icons.directions_bus;
//         color = Colors.orange;
//         break;
//       case 'train':
//         icon = Icons.train;
//         color = Colors.blue;
//         break;
//       case 'plane':
//         icon = Icons.airplanemode_active;
//         color = Colors.blueAccent;
//         break;
//       case 'ship':
//         icon = Icons.directions_boat;
//         color = Colors.blueGrey;
//         break;
//       default:
//         icon = Icons.person;
//         color = Colors.grey;
//     }
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Spacer(),
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: color.withOpacity(0.2),
//             ),
//             child: Icon(icon, color: color),
//           ),
//           const Spacer(),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MainScaffold(
//       body: SmartRefresher(
//         controller: _refreshController,
//         onRefresh: _onRefresh,
//         child: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               expandedHeight: 180,
//               floating: true,
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(AppLocalizations.of(context)!.translate('select_seats')??'select_seats'!),
//                 background: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Theme.of(context).colorScheme.primary.withOpacity(0.7),
//                         Theme.of(context).colorScheme.primary.withOpacity(0.3),
//                       ],
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         GlassCard(
//                           margin: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
//                                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   '${widget.route.origin} → ${widget.route.destination}',
//                                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                     color: Colors.white.withOpacity(0.9),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : _buildSeatSelectionContent(context),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSeatSelectionContent(BuildContext context) {
//     if (seatArrangement.isEmpty) {
//       return Center(
//         child: Text(AppLocalizations.of(context)!.translate('no_seats_available')??'no_seats_available'!),
//       );
//     }
//
//     return Column(
//       children: [
//         _buildSeatLegendWithRefresh(context),
//         const SizedBox(height: 24),
//         _buildDriverOrOperatorRow(),
//         _buildSeatGrid(context),
//         if (selectedSeats.isNotEmpty) ...[
//           const SizedBox(height: 24),
//           _buildContinueButton(context),
//         ],
//         const SizedBox(height: 60),
//       ],
//     );
//   }
//
//   Widget _buildSeatLegendWithRefresh(BuildContext context) {
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildLegendItem(
//                     context,
//                     AppLocalizations.of(context)!.translate('available')!,
//                     Colors.green,
//                   ),
//                   _buildLegendItem(
//                     context,
//                     AppLocalizations.of(context)!.translate('selected')!,
//                     Colors.blue,
//                   ),
//                   _buildLegendItem(
//                     context,
//                     AppLocalizations.of(context)!.translate('booked')!,
//                     Colors.red,
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: _onRefresh,
//               tooltip: AppLocalizations.of(context)!.translate('refresh')??'refresh'!,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLegendItem(BuildContext context, String text, Color color) {
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
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSeatGrid(BuildContext context) {
//     final layoutType = widget.transport.layoutType;
//     final hasMiddleAisle = layoutType.contains('-');
//     final parts = hasMiddleAisle ? layoutType.split('-') : [];
//     final leftSeats = hasMiddleAisle ? int.parse(parts[0]) : 0;
//
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: seatArrangement.asMap().entries.map((entry) {
//             final rowIndex = entry.key;
//             final row = entry.value;
//
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: row.asMap().entries.map((seatEntry) {
//                   final seatIndex = seatEntry.key;
//                   final seat = seatEntry.value;
//                   final seatNumber = seat['seat_number'] as String;
//                   final isBooked = seat['booked'] as bool? ?? false;
//                   final isSelected = selectedSeats.contains(seatNumber);
//
//                   // Add spacing based on layout type
//                   if (hasMiddleAisle && seatIndex == leftSeats) {
//                     return const SizedBox(width: 24); // Aisle space
//                   }
//
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: SeatWidget(
//                       seatNumber: seatNumber,
//                       status: isSelected
//                           ? SeatStatus.selected
//                           : isBooked
//                           ? SeatStatus.booked
//                           : SeatStatus.available,
//                       onTap: !isBooked
//                           ? () {
//                         setState(() {
//                           if (isSelected) {
//                             selectedSeats.remove(seatNumber);
//                           } else {
//                             selectedSeats.add(seatNumber);
//                           }
//                         });
//                       }
//                           : null,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContinueButton(BuildContext context) {
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               '${selectedSeats.length} ${AppLocalizations.of(context)!.translate('seats_selected')??'seats_selected'!}',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             NeuButton(
//               onPressed: () {
//                 context.read<BookingBloc>().add(
//                   BookingSeatsSelected(selectedSeats: selectedSeats),
//                 );
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
//               gradient: LinearGradient(
//                 colors: [
//                   Theme.of(context).colorScheme.primary,
//                   Theme.of(context).colorScheme.secondary,
//                 ],
//               ),
//               child: Text(
//                 AppLocalizations.of(context)!.translate('continue')!,
//                 style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// *******************************************************************


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