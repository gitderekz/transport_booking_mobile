// lib/pages/booking/payment_page.dart
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/models/route.dart';
import 'package:transport_booking/models/transport.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';
import 'package:transport_booking/widgets/main_scaffold.dart';
import 'package:transport_booking/widgets/neu_button.dart';

class PaymentPage extends StatefulWidget {
  final Route route;
  final Transport transport;
  final List<String> selectedSeats;
  final String pickupStop;
  final String dropoffStop;

  const PaymentPage({
    super.key,
    required this.route,
    required this.transport,
    required this.selectedSeats,
    required this.pickupStop,
    required this.dropoffStop,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _saveCard = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 16),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('payment')!,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildBookingSummary(context),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate('payment_details')!,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _cardNumberController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.translate('card_number')!,
                              prefixIcon: Icon(
                                Icons.credit_card_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('card_number_required')!;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _expiryDateController,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!
                                        .translate('expiry_date')!,
                                    hintText: 'MM/YY',
                                    prefixIcon: Icon(
                                      Icons.calendar_today_outlined,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate('expiry_date_required')!;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _cvvController,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.translate('cvv')!,
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate('cvv_required')!;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!
                                  .translate('cardholder_name')!,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('cardholder_name_required')!;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: Text(
                              AppLocalizations.of(context)!.translate('save_card')!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            value: _saveCard,
                            onChanged: (value) {
                              setState(() {
                                _saveCard = value;
                              });
                            },
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocListener<BookingBloc, BookingState>(
                  listener: (context, state) {
                    if (state is BookingSubmissionSuccess) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/booking/confirmation',
                        arguments: {'booking': state.booking},
                      );
                    } else if (state is BookingSubmissionFailure) {
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
                  child: BlocBuilder<BookingBloc, BookingState>(
                    builder: (context, state) {
                      if (state is BookingSubmissionInProgress) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return NeuButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final seats = widget.selectedSeats.map((seat) => {
                              'seat_number': seat,
                              'passenger_name': _nameController.text,
                              'passenger_age': null,
                              'passenger_gender': null,
                            }).toList();

                            context.read<BookingBloc>().add(
                              BookingSubmitted(
                                routeId: widget.route.id,
                                transportId: widget.transport.id,
                                pickupStopId: widget.pickupStop,
                                dropoffStopId: widget.dropoffStop,
                                seats: seats,
                              ),
                            );

                            // Navigator.pushNamed(
                            //   context,
                            //   '/booking/confirmation',
                            //   // arguments: {
                            //   //   'route': widget.route,
                            //   //   'transport': widget.transport,
                            //   //   'selectedSeats': selectedSeats,
                            //   // },
                            // );
                          }
                        },
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate('pay_now')!,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.route.origin} to ${widget.route.destination}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.event_seat_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '${widget.selectedSeats.length} ${AppLocalizations.of(context)!.translate('seats')!}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '${AppLocalizations.of(context)!.translate('pickup')!}: ${widget.pickupStop}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '${AppLocalizations.of(context)!.translate('dropoff')!}: ${widget.dropoffStop}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
          thickness: 1,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('total')!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${(widget.route.basePrice * widget.selectedSeats.length).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// *****************************************



// import 'package:flutter/material.dart'hide Route;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/models/booking.dart';
//
// import '../../blocs/booking/booking_bloc.dart';
// import '../../models/route.dart';
// import '../../models/transport.dart';
// import '../../utils/localization/app_localizations.dart';
//
// class PaymentPage extends StatefulWidget {
//   final Route route;
//   final Transport transport;
//   final List<String> selectedSeats;
//   final String pickupStop;
//   final String dropoffStop;
//
//   const PaymentPage({
//     super.key,
//     required this.route,
//     required this.transport,
//     required this.selectedSeats,
//     required this.pickupStop,
//     required this.dropoffStop,
//   });
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _cardNumberController = TextEditingController();
//   final _expiryDateController = TextEditingController();
//   final _cvvController = TextEditingController();
//   final _nameController = TextEditingController();
//
//   @override
//   void dispose() {
//     _cardNumberController.dispose();
//     _expiryDateController.dispose();
//     _cvvController.dispose();
//     _nameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('payment')!),
//       ),
//       body: BlocListener<BookingBloc, BookingState>(
//         listener: (context, state) {
//           if (state is BookingSubmissionSuccess) {
//             Navigator.pushReplacementNamed(
//               context,
//               '/booking/confirmation',
//               arguments: {'booking': state.booking},
//             );
//           } else if (state is BookingSubmissionFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.error)),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 '${widget.route.origin} to ${widget.route.destination}',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 '${widget.selectedSeats.length} ${AppLocalizations.of(context)!.translate('seats')!}',
//                 style: Theme.of(context).textTheme.bodyLarge,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 '${AppLocalizations.of(context)!.translate('pickup')!}: ${widget.pickupStop}',
//                 style: Theme.of(context).textTheme.bodyLarge,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 '${AppLocalizations.of(context)!.translate('dropoff')!}: ${widget.dropoffStop}',
//                 style: Theme.of(context).textTheme.bodyLarge,
//               ),
//               const SizedBox(height: 24),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _cardNumberController,
//                       decoration: InputDecoration(
//                         labelText: AppLocalizations.of(context)!
//                             .translate('card_number')!,
//                       ),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return AppLocalizations.of(context)!
//                               .translate('card_number_required')!;
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: _expiryDateController,
//                             decoration: InputDecoration(
//                               labelText: AppLocalizations.of(context)!
//                                   .translate('expiry_date')!,
//                             ),
//                             keyboardType: TextInputType.datetime,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return AppLocalizations.of(context)!
//                                     .translate('expiry_date_required')!;
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: TextFormField(
//                             controller: _cvvController,
//                             decoration: InputDecoration(
//                               labelText:
//                               AppLocalizations.of(context)!.translate('cvv')!,
//                             ),
//                             keyboardType: TextInputType.number,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return AppLocalizations.of(context)!
//                                     .translate('cvv_required')!;
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: InputDecoration(
//                         labelText: AppLocalizations.of(context)!
//                             .translate('cardholder_name')!,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return AppLocalizations.of(context)!
//                               .translate('cardholder_name_required')!;
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),
//               BlocBuilder<BookingBloc, BookingState>(
//                 builder: (context, state) {
//                   if (state is BookingSubmissionInProgress) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         final seats = widget.selectedSeats.map((seat) => {
//                           'seat_number': seat,
//                           'passenger_name': _nameController.text,
//                           'passenger_age': null,
//                           'passenger_gender': null,
//                         }).toList();
//
//                         // final booking = Booking(
//                         //   routeId: widget.route.id,
//                         //   transportId: widget.transport.id,
//                         //   pickupStopId: widget.pickupStop,
//                         //   dropoffStopId: widget.dropoffStop,
//                         //   seats: seats,
//                         //   // You may need to fill in userId, date, price, etc., depending on your Booking model
//                         // );
//                         context.read<BookingBloc>().add(
//                           BookingSubmitted(
//                             routeId: widget.route.id,
//                             transportId: widget.transport.id,
//                             pickupStopId: widget.pickupStop,
//                             dropoffStopId: widget.dropoffStop,
//                             seats: seats,
//                           ),
//                         );
//                       }
//                     },
//                     child: Text(
//                         AppLocalizations.of(context)!.translate('pay_now')!),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// // *****************************************




// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/models/route.dart';
// import 'package:transport_booking/models/transport.dart';
//
// class PaymentPage extends StatelessWidget {
//   final Route route;
//   final Transport transport;
//   final List<String> selectedSeats;
//   final String pickupStopId;
//   final String dropoffStopId;
//
//   const PaymentPage({
//     super.key,
//     required this.route,
//     required this.transport,
//     required this.selectedSeats,
//     required this.pickupStopId,
//     required this.dropoffStopId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final pickupStop = route.stops.firstWhere(
//           (stop) => stop['id'].toString() == pickupStopId,
//     );
//     final dropoffStop = route.stops.firstWhere(
//           (stop) => stop['id'].toString() == dropoffStopId,
//     );
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Payment')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '${transport.name} - ${transport.type.toUpperCase()}',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '${route.origin} to ${route.destination}',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const Divider(height: 32),
//             Text(
//               'Pickup: ${pickupStop['station_name']} at ${pickupStop['departure_time']}',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             Text(
//               'Dropoff: ${dropoffStop['station_name']} at ${dropoffStop['arrival_time']}',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             const Divider(height: 32),
//             Text(
//               'Selected Seats: ${selectedSeats.join(', ')}',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             const Divider(height: 32),
//             Text(
//               'Total Price: \$${(route.basePrice * selectedSeats.length).toStringAsFixed(2)}',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const Spacer(),
//             BlocBuilder<BookingBloc, BookingState>(
//               builder: (context, state) {
//                 if (state is BookingLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 return SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       context.read<BookingBloc>().add(
//                         CreateBooking(
//                           routeId: route.id,
//                           transportId: transport.id,
//                           pickupStopId: pickupStopId,
//                           dropoffStopId: dropoffStopId,
//                           seats: selectedSeats.map((seat) => {
//                             'seatNumber': seat,
//                             'passengerName': 'Primary Passenger',
//                           }).toList(),
//                         ),
//                       );
//                     },
//                     child: const Text('Confirm Booking'),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }