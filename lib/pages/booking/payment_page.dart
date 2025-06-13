import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/auth/auth_bloc.dart';
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
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  bool _passengerDetailsInitialized = false;

  String _selectedPaymentMethod = 'mpesa'; // Default to Mpesa
  final List<Map<String, dynamic>> _passengerDetails = [];
  bool _saveCard = false;
  bool _useLoggedInUserDetails = true;

  @override
  void initState() {
    super.initState();
    // Initialize passenger details with seat numbers
    _passengerDetails.addAll(
        widget.selectedSeats.map((seat) => {'seat_number': seat})
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updatePassengerDetail(String seat, String field, String? value) {
    final index = _passengerDetails.indexWhere((p) => p['seat_number'] == seat);
    if (index != -1) {
      setState(() {
        _passengerDetails[index][field] = value;
      });
    }
  }

  Widget _buildPaymentMethodFields(BuildContext context) {
    switch (_selectedPaymentMethod) {
      case 'card':
        return Column(
          children: [
            TextFormField(
              controller: _cardNumberController,
              decoration: _inputDecoration(
                context,
                AppLocalizations.of(context)!.translate('card_number')!,
                Icons.credit_card_outlined,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? AppLocalizations.of(context)!.translate('card_number_required')!
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryDateController,
                    decoration: _inputDecoration(
                      context,
                      AppLocalizations.of(context)!.translate('expiry_date')!,
                      Icons.calendar_today_outlined,
                      hintText: 'MM/YY',
                    ),
                    keyboardType: TextInputType.datetime,
                    validator: (value) => value?.isEmpty ?? true
                        ? AppLocalizations.of(context)!.translate('expiry_date_required')!
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: _inputDecoration(
                      context,
                      AppLocalizations.of(context)!.translate('cvv')!,
                      Icons.lock_outline,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true
                        ? AppLocalizations.of(context)!.translate('cvv_required')!
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration(
                context,
                AppLocalizations.of(context)!.translate('cardholder_name')!,
                Icons.person_outline,
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? AppLocalizations.of(context)!.translate('cardholder_name_required')!
                  : null,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(
                AppLocalizations.of(context)!.translate('save_card')!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              value: _saveCard,
              onChanged: (value) => setState(() => _saveCard = value),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        );

      case 'paypal':
        return Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration(
                context,
                AppLocalizations.of(context)!.translate('paypal_email')!,
                Icons.email_outlined,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value?.isEmpty ?? true
                  ? 'PayPal email is required'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration(
                context,
                AppLocalizations.of(context)!.translate('account_holder_name')!,
                Icons.person_outline,
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Name is required'
                  : null,
            ),
          ],
        );

      case 'mpesa':
      case 'airtel-money':
      case 'halopesa':
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state is AuthAuthenticated ? state.user : null;
            if (user?.phone != null && _phoneController.text.isEmpty) {
              _phoneController.text = user!.phone!;
            }

            return TextFormField(
              controller: _phoneController,
              decoration: _inputDecoration(
                context,
                AppLocalizations.of(context)!.translate('phone_number')!,
                Icons.phone_outlined,
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Phone number is required'
                  : null,
            );
          },
        );

      default: // cash
        return const SizedBox.shrink();
    }
  }

  InputDecoration _inputDecoration(BuildContext context, String label, IconData icon, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (!_passengerDetailsInitialized && authState is AuthAuthenticated && _useLoggedInUserDetails) {
      _nameController.text = '${authState.user.firstName} ${authState.user.lastName}';
      _notesController.text = AppLocalizations.of(context)!.translate('payment')!;
      for (var seat in widget.selectedSeats) {
        _updatePassengerDetail(seat, 'passenger_name', '${authState.user.firstName} ${authState.user.lastName}');
        _updatePassengerDetail(seat, 'passenger_age', '${authState.user.age}');
        _updatePassengerDetail(seat, 'passenger_gender', authState.user.gender);
      }
      _passengerDetailsInitialized = true;
    }

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
                          DropdownButtonFormField<String>(
                            value: _selectedPaymentMethod,
                            decoration: _inputDecoration(
                              context,
                              AppLocalizations.of(context)!.translate('payment_method')!,
                              Icons.payment,
                            ),
                            items: [
                              'mpesa',
                              'airtel-money',
                              'halopesa',
                              'card',
                              'paypal',
                              'cash'
                            ].map((method) {
                              return DropdownMenuItem(
                                value: method,
                                child: Text(method.replaceAll('-', ' ').toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                          ),
                          const SizedBox(height: 16),
                          _buildPaymentMethodFields(context),
                          const SizedBox(height: 16),
                          ExpansionTile(
                            title: Text(AppLocalizations.of(context)!.translate('passenger_details')!),
                            children: widget.selectedSeats.map((seat) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: [
                                    BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, state) {
                                        final user = state is AuthAuthenticated ? state.user : null;
                                        // if (_useLoggedInUserDetails && user != null) {
                                        //   _updatePassengerDetail(seat, 'name', '${user.firstName} ${user.lastName}');
                                        //   _updatePassengerDetail(seat, 'gender', user.gender);
                                        // }

                                        return TextFormField(
                                          initialValue: _passengerDetails
                                              .firstWhere((p) => p['seat_number'] == seat,
                                              orElse: () => {})['passenger_name'],
                                          decoration: InputDecoration(
                                            labelText: '${AppLocalizations.of(context)!.translate('name_for_seat')!} $seat',
                                            suffixIcon: user != null ? IconButton(
                                              icon: Icon(
                                                _useLoggedInUserDetails
                                                    ? Icons.check_circle
                                                    : Icons.person_outline,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                              onPressed: () => setState(() {
                                                _useLoggedInUserDetails = !_useLoggedInUserDetails;
                                              }),
                                            ) : null,
                                          ),
                                          onChanged: (value) => _updatePassengerDetail(seat, 'name', value),
                                          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                        );
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: _passengerDetails
                                                .firstWhere((p) => p['seat_number'] == seat,
                                                orElse: () => {})['passenger_age'],
                                            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('age')!),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) => _updatePassengerDetail(seat, 'age', value),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: DropdownButtonFormField<String>(
                                            value: _passengerDetails
                                                .firstWhere((p) => p['seat_number'] == seat,
                                                orElse: () => {})['passenger_gender'],
                                            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('gender')??'Jinsia'),
                                            items: ['male', 'female', 'prefer not to say']
                                                .map((g) => DropdownMenuItem(
                                              value: g,
                                              child: Text(g),
                                            ))
                                                .toList(),
                                            onChanged: (value) => _updatePassengerDetail(seat, 'gender', value),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _notesController,
                            decoration: _inputDecoration(
                              context,
                              AppLocalizations.of(context)!.translate('special_notes')!,
                              Icons.note_add_outlined,
                            ),
                            maxLines: 3,
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
                            final paymentDetails = {
                              'method': _selectedPaymentMethod,
                              if (_selectedPaymentMethod == 'card') ...{
                                'card_number': _cardNumberController.text,
                                'expiry_date': _expiryDateController.text,
                                'cvv': _cvvController.text,
                                'cardholder_name': _nameController.text,
                                'save_card': _saveCard,
                              },
                              if (_selectedPaymentMethod == 'paypal') ...{
                                'email': _emailController.text,
                                'name': _nameController.text,
                              },
                              if (['mpesa', 'airtel-money', 'halopesa'].contains(_selectedPaymentMethod)) ...{
                                'phone': _phoneController.text,
                              },
                            };

                            context.read<BookingBloc>().add(
                              BookingSubmitted(
                                routeId: widget.route.id,
                                transportId: widget.transport.id,
                                pickupStopId: widget.pickupStop,
                                dropoffStopId: widget.dropoffStop,
                                seats: _passengerDetails,
                                paymentMethod: _selectedPaymentMethod,
                                paymentDetails: paymentDetails,
                                notes: _notesController.text,
                              ),
                            );
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
              'Tsh ${(widget.route.basePrice! * widget.selectedSeats.length).toStringAsFixed(2)}',
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



// // lib/pages/booking/payment_page.dart
// import 'package:flutter/material.dart' hide Route;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/blocs/booking/booking_bloc.dart';
// import 'package:transport_booking/models/route.dart';
// import 'package:transport_booking/models/transport.dart';
// import 'package:transport_booking/utils/localization/app_localizations.dart';
// import 'package:transport_booking/widgets/glass_card.dart';
// import 'package:transport_booking/widgets/main_scaffold.dart';
// import 'package:transport_booking/widgets/neu_button.dart';
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
//   String? _selectedPaymentMethod;
//   final List<Map<String, dynamic>> _passengerDetails = [];
//   final _notesController = TextEditingController();
//   bool _saveCard = false;
//
//   @override
//   void dispose() {
//     _cardNumberController.dispose();
//     _expiryDateController.dispose();
//     _cvvController.dispose();
//     _nameController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }
//
// // Helper method
//   void _updatePassengerDetail(String seat, String field, String? value) {
//     final index = _passengerDetails.indexWhere((p) => p['seat_number'] == seat);
//     if (index == -1) {
//       _passengerDetails.add({'seat_number': seat, field: value});
//     } else {
//       _passengerDetails[index][field] = value;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MainScaffold(
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Background gradient
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                   Theme.of(context).colorScheme.primary.withOpacity(0.05),
//                 ],
//               ),
//             ),
//           ),
//
//           // Content
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 const SizedBox(height: 16),
//                 GlassCard(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           AppLocalizations.of(context)!.translate('payment')!,
//                           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildBookingSummary(context),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // payment method selector
//                 GlassCard(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           Text(
//                             AppLocalizations.of(context)!.translate('payment_details')!,
//                             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           DropdownButtonFormField<String>(                // 1. Opening main widget
//                             value: _selectedPaymentMethod,
//                             decoration: InputDecoration(                  // 2. Opening InputDecoration
//                               labelText: 'Payment Method',
//                               prefixIcon: Icon(                           // 3. Opening Icon
//                                 Icons.payment,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),                                          // 3. Closing Icon
//                               filled: true,
//                               fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
//                               border: OutlineInputBorder(                 // 4. Opening OutlineInputBorder
//                                 borderRadius: BorderRadius.circular(12),
//                               ),                                          // 4. Closing OutlineInputBorder
//                             ),                                            // 2. Closing InputDecoration
//
//                             items: [                                      // 5. Opening items list
//                               'card',
//                               'paypal',
//                               'mpesa',
//                               'airtel-money',
//                               'halopesa',
//                               'cash'
//                             ].map((method) {
//                               return DropdownMenuItem<String>(            // 6. Opening DropdownMenuItem
//                                 value: method,
//                                 child: Text(method.replaceAll('-', ' ').toUpperCase()),
//                               );                                          // 6. Closing DropdownMenuItem
//                             }).toList(),                                  // 5. Closing items list
//
//                             onChanged: (value) => setState(() => _selectedPaymentMethod = value),
//                             validator: (value) => value == null ? 'Select payment method' : null,
//                           ),
//                           const SizedBox(height: 16),
//                           TextFormField(
//                             controller: _cardNumberController,
//                             decoration: InputDecoration(
//                               labelText: AppLocalizations.of(context)!.translate('card_number')!,
//                               prefixIcon: Icon(
//                                 Icons.credit_card_outlined,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                               filled: true,
//                               fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                             keyboardType: TextInputType.number,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return AppLocalizations.of(context)!
//                                     .translate('card_number_required')!;
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: _expiryDateController,
//                                   decoration: InputDecoration(
//                                     labelText: AppLocalizations.of(context)!
//                                         .translate('expiry_date')!,
//                                     hintText: 'MM/YY',
//                                     prefixIcon: Icon(
//                                       Icons.calendar_today_outlined,
//                                       color: Theme.of(context).colorScheme.primary,
//                                     ),
//                                     filled: true,
//                                     fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                                   keyboardType: TextInputType.datetime,
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return AppLocalizations.of(context)!
//                                           .translate('expiry_date_required')!;
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: _cvvController,
//                                   decoration: InputDecoration(
//                                     labelText: AppLocalizations.of(context)!.translate('cvv')!,
//                                     prefixIcon: Icon(
//                                       Icons.lock_outline,
//                                       color: Theme.of(context).colorScheme.primary,
//                                     ),
//                                     filled: true,
//                                     fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                                   keyboardType: TextInputType.number,
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return AppLocalizations.of(context)!
//                                           .translate('cvv_required')!;
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           TextFormField(
//                             controller: _nameController,
//                             decoration: InputDecoration(
//                               labelText: AppLocalizations.of(context)!
//                                   .translate('cardholder_name')!,
//                               prefixIcon: Icon(
//                                 Icons.person_outline,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                               filled: true,
//                               fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return AppLocalizations.of(context)!
//                                     .translate('cardholder_name_required')!;
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           // Add passenger details section
//                           ExpansionTile(
//                             title: Text('Passenger Details'),
//                             children: widget.selectedSeats.map((seat) {
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                 child: Column(
//                                   children: [
//                                     TextFormField(
//                                       decoration: InputDecoration(labelText: 'Name for Seat $seat'),
//                                       onChanged: (value) => _updatePassengerDetail(seat, 'name', value),
//                                       validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                                     ),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: TextFormField(
//                                             decoration: InputDecoration(labelText: 'Age'),
//                                             keyboardType: TextInputType.number,
//                                             onChanged: (value) => _updatePassengerDetail(seat, 'age', value),
//                                           ),
//                                         ),
//                                         SizedBox(width: 16),
//                                         Expanded(
//                                           child: DropdownButtonFormField<String>(
//                                             decoration: InputDecoration(labelText: 'Gender'),
//                                             items: ['male', 'female', 'other', 'prefer not to say']
//                                                 .map((g) => DropdownMenuItem(value: g, child: Text(g)))
//                                                 .toList(),
//                                             onChanged: (value) => _updatePassengerDetail(seat, 'gender', value),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                           const SizedBox(height: 16),
//                           // Notes field
//                           TextFormField(
//                             controller: _notesController,
//                             decoration: InputDecoration(
//                               labelText: 'Special Notes',
//                               prefixIcon: Icon(Icons.note_add_outlined),
//                             ),
//                             maxLines: 3,
//                           ),
//                           const SizedBox(height: 16),
//                           SwitchListTile(
//                             title: Text(
//                               AppLocalizations.of(context)!.translate('save_card')!,
//                               style: Theme.of(context).textTheme.bodyLarge,
//                             ),
//                             value: _saveCard,
//                             onChanged: (value) {
//                               setState(() {
//                                 _saveCard = value;
//                               });
//                             },
//                             activeColor: Theme.of(context).colorScheme.primary,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 BlocListener<BookingBloc, BookingState>(
//                   listener: (context, state) {
//                     if (state is BookingSubmissionSuccess) {
//                       Navigator.pushReplacementNamed(
//                         context,
//                         '/booking/confirmation',
//                         arguments: {'booking': state.booking},
//                       );
//                     } else if (state is BookingSubmissionFailure) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(state.error),
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   child: BlocBuilder<BookingBloc, BookingState>(
//                     builder: (context, state) {
//                       if (state is BookingSubmissionInProgress) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       return NeuButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             final seats = widget.selectedSeats.map((seat) => {
//                               'seat_number': seat,
//                               'passenger_name': _nameController.text,
//                               'passenger_age': null,
//                               'passenger_gender': null,
//                             }).toList();
//
//                             context.read<BookingBloc>().add(
//                               BookingSubmitted(
//                                 routeId: widget.route.id,
//                                 transportId: widget.transport.id,
//                                 pickupStopId: widget.pickupStop,
//                                 dropoffStopId: widget.dropoffStop,
//                                 seats: seats,
//                               ),
//                             );
//
//                             // Navigator.pushNamed(
//                             //   context,
//                             //   '/booking/confirmation',
//                             //   // arguments: {
//                             //   //   'route': widget.route,
//                             //   //   'transport': widget.transport,
//                             //   //   'selectedSeats': selectedSeats,
//                             //   // },
//                             // );
//                           }
//                         },
//                         gradient: LinearGradient(
//                           colors: [
//                             Theme.of(context).colorScheme.primary,
//                             Theme.of(context).colorScheme.secondary,
//                           ],
//                         ),
//                         child: Text(
//                           AppLocalizations.of(context)!.translate('pay_now')!,
//                           style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBookingSummary(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '${widget.transport.name} - ${widget.transport.type.toUpperCase()}',
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         const SizedBox(height: 8),
//         Text(
//           '${widget.route.origin} to ${widget.route.destination}',
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Icon(
//               Icons.event_seat_outlined,
//               color: Theme.of(context).colorScheme.primary,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               '${widget.selectedSeats.length} ${AppLocalizations.of(context)!.translate('seats')!}',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             Icon(
//               Icons.location_on_outlined,
//               color: Theme.of(context).colorScheme.primary,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               '${AppLocalizations.of(context)!.translate('pickup')!}: ${widget.pickupStop}',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             Icon(
//               Icons.location_on_outlined,
//               color: Theme.of(context).colorScheme.primary,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               '${AppLocalizations.of(context)!.translate('dropoff')!}: ${widget.dropoffStop}',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Divider(
//           color: Theme.of(context).dividerColor.withOpacity(0.2),
//           thickness: 1,
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               AppLocalizations.of(context)!.translate('total')!,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               '\$${(widget.route.basePrice * widget.selectedSeats.length).toStringAsFixed(2)}',
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
// // *****************************************