// lib/pages/booking/stops_selection_page.dart
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/models/route.dart';
import 'package:transport_booking/models/transport.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';
import 'package:transport_booking/widgets/main_scaffold.dart';
import 'package:transport_booking/widgets/neu_button.dart';
import 'package:transport_booking/widgets/stop_timeline.dart';

class StopsSelectionPage extends StatefulWidget {
  final Route route;
  final Transport transport;
  final List<String> selectedSeats;

  const StopsSelectionPage({
    super.key,
    required this.route,
    required this.transport,
    required this.selectedSeats,
  });

  @override
  State<StopsSelectionPage> createState() => _StopsSelectionPageState();
}

class _StopsSelectionPageState extends State<StopsSelectionPage> {
  String? _pickupStop;
  String? _dropoffStop;
  final ScrollController _pickupController = ScrollController();
  final ScrollController _dropoffController = ScrollController();

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

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
              title: Text(AppLocalizations.of(context)!.translate('select_stops')!),
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
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.confirmation_number_outlined,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 32,
                                      ),
                                      Text(
                                        '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.route.origin} → ${widget.route.destination}',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.selectedSeats.length} ${AppLocalizations.of(context)!.translate('seats')!}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
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
                  // Pickup and Dropoff side-by-side
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pickup section
                      Expanded(
                        child: GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate('pickup_point')!,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 300, // Fixed height
                                  child: Scrollbar(
                                    controller: _pickupController,
                                    thumbVisibility: true,
                                    child: ListView(
                                      controller: _pickupController,
                                      children: widget.route.stops.map((stop) {
                                        return RadioListTile<String>(
                                          title: Text(stop.stationName),
                                          subtitle: Text(stop.departureTime ?? ''),
                                          value: stop.id,
                                          groupValue: _pickupStop,
                                          onChanged: (value) {
                                            setState(() {
                                              _pickupStop = value;
                                              if (_dropoffStop != null &&
                                                  widget.route.stops
                                                      .firstWhere((s) => s.id == _pickupStop)
                                                      .sequenceOrder >=
                                                      widget.route.stops
                                                          .firstWhere((s) => s.id == _dropoffStop)
                                                          .sequenceOrder) {
                                                _dropoffStop = null;
                                              }
                                            });
                                          },
                                          activeColor: Theme.of(context).colorScheme.primary,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Dropoff section
                      if (_pickupStop != null)
                        Expanded(
                          child: GlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.translate('dropoff_point')!,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 300, // Fixed height
                                    child: Scrollbar(
                                      controller: _dropoffController,
                                      thumbVisibility: true,
                                      child: ListView(
                                        controller: _dropoffController,
                                        children: widget.route.stops.map((stop) {
                                          if (_pickupStop != null &&
                                              widget.route.stops
                                                  .firstWhere((s) => s.id == _pickupStop)
                                                  .sequenceOrder >=
                                                  stop.sequenceOrder) {
                                            return const SizedBox.shrink();
                                          }
                                          return RadioListTile<String>(
                                            title: Text(stop.stationName),
                                            subtitle: Text(stop.arrivalTime ?? ''),
                                            value: stop.id,
                                            groupValue: _dropoffStop,
                                            onChanged: (value) {
                                              setState(() {
                                                _dropoffStop = value;
                                              });
                                            },
                                            activeColor: Theme.of(context).colorScheme.primary,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Timeline & Button
                  if (_pickupStop != null && _dropoffStop != null) ...[
                    GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: StopTimeline(
                          stops: widget.route.stops,
                          pickupStopId: _pickupStop,
                          dropoffStopId: _dropoffStop,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    NeuButton(
                      onPressed: () {
                        context.read<BookingBloc>().add(
                          BookingStopsSelected(
                            pickupStopId: _pickupStop!,
                            dropoffStopId: _dropoffStop!,
                          ),
                        );
                        Navigator.pushNamed(
                          context,
                          '/booking/payment',
                          arguments: {
                            'route': widget.route,
                            'transport': widget.transport,
                            'selectedSeats': widget.selectedSeats,
                            'pickupStop': _pickupStop,
                            'dropoffStop': _dropoffStop,
                          },
                        );
                      },
                      // style: ElevatedButton.styleFrom(
                      //   minimumSize: const Size(double.infinity, 50),
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
                    const SizedBox(height: 100),
                  ],
                ],
              ),
            ),
          ),


          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: Column(
          //       children: [
          //         // Row for Pickup and Dropoff
          //         Row(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             // Pickup Section
          //             Expanded(
          //               child: GlassCard(
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(16),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         AppLocalizations.of(context)!.translate('pickup_point')!,
          //                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                       ),
          //                       const SizedBox(height: 16),
          //                       ...widget.route.stops.map((stop) => RadioListTile<String>(
          //                         title: Text(stop.stationName),
          //                         subtitle: Text(stop.departureTime ?? ''),
          //                         value: stop.id,
          //                         groupValue: _pickupStop,
          //                         onChanged: (value) {
          //                           setState(() {
          //                             _pickupStop = value;
          //                             if (_dropoffStop != null &&
          //                                 widget.route.stops
          //                                     .firstWhere((s) => s.id == _pickupStop)
          //                                     .sequenceOrder >=
          //                                     widget.route.stops
          //                                         .firstWhere((s) => s.id == _dropoffStop)
          //                                         .sequenceOrder) {
          //                               _dropoffStop = null;
          //                             }
          //                           });
          //                         },
          //                         activeColor: Theme.of(context).colorScheme.primary,
          //                       )),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //
          //             const SizedBox(width: 16),
          //
          //             // Dropoff Section
          //             if (_pickupStop != null)
          //               Expanded(
          //                 child: GlassCard(
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(16),
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           AppLocalizations.of(context)!.translate('dropoff_point')!,
          //                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                         ),
          //                         const SizedBox(height: 16),
          //                         ...widget.route.stops.map((stop) {
          //                           if (_pickupStop != null &&
          //                               widget.route.stops
          //                                   .firstWhere((s) => s.id == _pickupStop)
          //                                   .sequenceOrder >=
          //                                   stop.sequenceOrder) {
          //                             return const SizedBox.shrink();
          //                           }
          //                           return RadioListTile<String>(
          //                             title: Text(stop.stationName),
          //                             subtitle: Text(stop.arrivalTime ?? ''),
          //                             value: stop.id,
          //                             groupValue: _dropoffStop,
          //                             onChanged: (value) {
          //                               setState(() {
          //                                 _dropoffStop = value;
          //                               });
          //                             },
          //                             activeColor: Theme.of(context).colorScheme.primary,
          //                           );
          //                         }),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //           ],
          //         ),
          //
          //         const SizedBox(height: 16),
          //
          //         // Timeline and Continue button
          //         if (_pickupStop != null && _dropoffStop != null) ...[
          //           GlassCard(
          //             child: Padding(
          //               padding: const EdgeInsets.all(16),
          //               child: StopTimeline(
          //                 stops: widget.route.stops,
          //                 pickupStopId: _pickupStop,
          //                 dropoffStopId: _dropoffStop,
          //               ),
          //             ),
          //           ),
          //           const SizedBox(height: 16),
          //           ElevatedButton(
          //             onPressed: () {
          //               context.read<BookingBloc>().add(
          //                 BookingStopsSelected(
          //                   pickupStopId: _pickupStop!,
          //                   dropoffStopId: _dropoffStop!,
          //                 ),
          //               );
          //               Navigator.pushNamed(
          //                 context,
          //                 '/booking/payment',
          //                 arguments: {
          //                   'route': widget.route,
          //                   'transport': widget.transport,
          //                   'selectedSeats': widget.selectedSeats,
          //                   'pickupStop': _pickupStop,
          //                   'dropoffStop': _dropoffStop,
          //                 },
          //               );
          //             },
          //             style: ElevatedButton.styleFrom(
          //               minimumSize: const Size(double.infinity, 50),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(12),
          //               ),
          //             ),
          //             child: Text(
          //               AppLocalizations.of(context)!.translate('continue')!,
          //             ),
          //           ),
          //           const SizedBox(height: 100),
          //         ],
          //       ],
          //     ),
          //   ),
          // ),

          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: Column(
          //       children: [
          //         GlassCard(
          //           child: Padding(
          //             padding: const EdgeInsets.all(16),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   AppLocalizations.of(context)!.translate('pickup_point')!,
          //                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 const SizedBox(height: 16),
          //                 ...widget.route.stops.map((stop) =>
          //                     RadioListTile<String>(
          //                       title: Text(stop.stationName),
          //                       subtitle: Text(stop.departureTime ?? ''),
          //                       value: stop.id,
          //                       groupValue: _pickupStop,
          //                       onChanged: (value) {
          //                         setState(() {
          //                           _pickupStop = value;
          //                           if (_dropoffStop != null &&
          //                               widget.route.stops
          //                                   .firstWhere((s) => s.id == _pickupStop)
          //                                   .sequenceOrder >=
          //                                   widget.route.stops
          //                                       .firstWhere((s) => s.id == _dropoffStop)
          //                                       .sequenceOrder) {
          //                             _dropoffStop = null;
          //                           }
          //                         });
          //                       },
          //                       activeColor: Theme.of(context).colorScheme.primary,
          //                     ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         const SizedBox(height: 16),
          //         if (_pickupStop != null) ...[
          //           GlassCard(
          //             child: Padding(
          //               padding: const EdgeInsets.all(16),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     AppLocalizations.of(context)!.translate('dropoff_point')!,
          //                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                   const SizedBox(height: 16),
          //                   ...widget.route.stops.map((stop) {
          //                     if (_pickupStop != null &&
          //                         widget.route.stops
          //                             .firstWhere((s) => s.id == _pickupStop)
          //                             .sequenceOrder >=
          //                             stop.sequenceOrder) {
          //                       return const SizedBox.shrink();
          //                     }
          //                     return RadioListTile<String>(
          //                       title: Text(stop.stationName),
          //                       subtitle: Text(stop.arrivalTime ?? ''),
          //                       value: stop.id,
          //                       groupValue: _dropoffStop,
          //                       onChanged: (value) {
          //                         setState(() {
          //                           _dropoffStop = value;
          //                         });
          //                       },
          //                       activeColor: Theme.of(context).colorScheme.primary,
          //                     );
          //                   }),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           const SizedBox(height: 16),
          //           GlassCard(
          //             child: Padding(
          //               padding: const EdgeInsets.all(16),
          //               child: StopTimeline(
          //                 stops: widget.route.stops,
          //                 pickupStopId: _pickupStop,
          //                 dropoffStopId: _dropoffStop,
          //               ),
          //             ),
          //           ),
          //           const SizedBox(height: 16),
          //           if (_dropoffStop != null)
          //             ElevatedButton(
          //               onPressed: () {
          //                 context.read<BookingBloc>().add(
          //                   BookingStopsSelected(
          //                     pickupStopId: _pickupStop!,
          //                     dropoffStopId: _dropoffStop!,
          //                   ),
          //                 );
          //                 Navigator.pushNamed(
          //                   context,
          //                   '/booking/payment',
          //                   arguments: {
          //                     'route': widget.route,
          //                     'transport': widget.transport,
          //                     'selectedSeats': widget.selectedSeats,
          //                     'pickupStop': _pickupStop,
          //                     'dropoffStop': _dropoffStop,
          //                   },
          //                 );
          //               },
          //               style: ElevatedButton.styleFrom(
          //                 minimumSize: const Size(double.infinity, 50),
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(12),
          //                 ),
          //               ),
          //               child: Text(
          //                 AppLocalizations.of(context)!.translate('continue')!,
          //                 // style: Theme.of(context).textTheme.labelLarge?.copyWith(
          //                 //   color: Colors.white,
          //                 // ),
          //               ),
          //             ),
          //           SizedBox(height: 100,)
          //         ],
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart'hide Route;
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../blocs/booking/booking_bloc.dart';
// import '../../models/route.dart';
// import '../../models/transport.dart';
// import '../../widgets/stop_timeline.dart';
// import '../../utils/localization/app_localizations.dart';
//
// class StopsSelectionPage extends StatefulWidget {
//   final Route route;
//   final Transport transport;
//   final List<String> selectedSeats;
//
//   const StopsSelectionPage({
//     super.key,
//     required this.route,
//     required this.transport,
//     required this.selectedSeats,
//   });
//
//   @override
//   State<StopsSelectionPage> createState() => _StopsSelectionPageState();
// }
//
// class _StopsSelectionPageState extends State<StopsSelectionPage> {
//   String? _pickupStop;
//   String? _dropoffStop;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('select_stops')!),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '${widget.route.origin} to ${widget.route.destination}',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               '${widget.selectedSeats.length} ${AppLocalizations.of(context)!.translate('seats')!}',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             const SizedBox(height: 24),
//             Text(
//               AppLocalizations.of(context)!.translate('pickup_point')!,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             ...widget.route.stops.map((stop) {
//               return RadioListTile<String>(
//                 title: Text(stop.stationName),
//                 subtitle: Text(stop.departureTime ?? ''),
//                 value: stop.id,
//                 groupValue: _pickupStop,
//                 onChanged: (value) {
//                   setState(() {
//                     _pickupStop = value;
//                     if (_dropoffStop != null &&
//                         widget.route.stops
//                             .firstWhere((s) => s.id == _pickupStop)
//                             .sequenceOrder >=
//                             widget.route.stops
//                                 .firstWhere((s) => s.id == _dropoffStop)
//                                 .sequenceOrder) {
//                       _dropoffStop = null;
//                     }
//                   });
//                 },
//               );
//             }),
//             const SizedBox(height: 24),
//             Text(
//               AppLocalizations.of(context)!.translate('dropoff_point')!,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             ...widget.route.stops.map((stop) {
//               if (_pickupStop != null &&
//                   widget.route.stops
//                       .firstWhere((s) => s.id == _pickupStop)
//                       .sequenceOrder >=
//                       stop.sequenceOrder) {
//                 return const SizedBox.shrink();
//               }
//               return RadioListTile<String>(
//                 title: Text(stop.stationName),
//                 subtitle: Text(stop.arrivalTime ?? ''),
//                 value: stop.id,
//                 groupValue: _dropoffStop,
//                 onChanged: (value) {
//                   setState(() {
//                     _dropoffStop = value;
//                   });
//                 },
//               );
//             }),
//             const SizedBox(height: 16),
//             StopTimeline(
//               stops: widget.route.stops,
//               pickupStopId: _pickupStop,
//               dropoffStopId: _dropoffStop,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _pickupStop != null && _dropoffStop != null
//                   ? () {
//                 context.read<BookingBloc>().add(
//                   BookingStopsSelected(
//                     // pickupStopId: _pickupStop!.id,
//                     // dropoffStopId: _dropoffStop!.id,
//                     pickupStopId: _pickupStop!,
//                     dropoffStopId: _dropoffStop!,
//
//                   ),
//                 );
//                 Navigator.pushNamed(
//                   context,
//                   '/booking/payment',
//                   arguments: {
//                     'route': widget.route,
//                     'transport': widget.transport,
//                     'selectedSeats': widget.selectedSeats,
//                     'pickupStop': _pickupStop,
//                     'dropoffStop': _dropoffStop,
//                   },
//                 );
//               }
//                   : null,
//               child: Text(
//                   AppLocalizations.of(context)!.translate('continue')!),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }