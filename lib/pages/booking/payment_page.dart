import 'package:flutter/material.dart'hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/models/booking.dart';

import '../../blocs/booking/booking_bloc.dart';
import '../../models/route.dart';
import '../../models/transport.dart';
import '../../utils/localization/app_localizations.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('payment')!),
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingSubmissionSuccess) {
            Navigator.pushReplacementNamed(
              context,
              '/booking/confirmation',
              arguments: {'booking': state.booking},
            );
          } else if (state is BookingSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
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
              Text(
                '${widget.selectedSeats.length} ${AppLocalizations.of(context)!.translate('seats')!}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                '${AppLocalizations.of(context)!.translate('pickup')!}: ${widget.pickupStop}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.translate('dropoff')!}: ${widget.dropoffStop}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _cardNumberController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!
                            .translate('card_number')!,
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
                              labelText:
                              AppLocalizations.of(context)!.translate('cvv')!,
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
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .translate('cardholder_name_required')!;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingSubmissionInProgress) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final seats = widget.selectedSeats.map((seat) => {
                          'seat_number': seat,
                          'passenger_name': _nameController.text,
                          'passenger_age': null,
                          'passenger_gender': null,
                        }).toList();

                        // final booking = Booking(
                        //   routeId: widget.route.id,
                        //   transportId: widget.transport.id,
                        //   pickupStopId: widget.pickupStop,
                        //   dropoffStopId: widget.dropoffStop,
                        //   seats: seats,
                        //   // You may need to fill in userId, date, price, etc., depending on your Booking model
                        // );
                        context.read<BookingBloc>().add(
                          BookingSubmitted(
                            routeId: widget.route.id,
                            transportId: widget.transport.id,
                            pickupStopId: widget.pickupStop,
                            dropoffStopId: widget.dropoffStop,
                            seats: seats,
                          ),
                        );
                      }
                    },
                    child: Text(
                        AppLocalizations.of(context)!.translate('pay_now')!),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}




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