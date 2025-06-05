// lib/pages/home/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/models/stop.dart';
import 'package:transport_booking/models/transport.dart';
import 'package:transport_booking/repositories/transport_repository.dart';
import 'package:transport_booking/services/api_service.dart';
import 'package:transport_booking/services/local_storage.dart';

import '../../blocs/booking/booking_bloc.dart';
import '../../widgets/transport_card.dart';
import '../../utils/localization/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DateTime? _selectedDate;
  late TransportRepository _transportRepository;
  final LocalStorage localStorage = LocalStorage();

  List<Transport> _transports = [];
  List<Stop> _stops = [];
  Stop? _selectedFromStop;
  Stop? _selectedToStop;

  @override
  void initState() {
    super.initState();
    _transportRepository = TransportRepository(apiService: ApiService(localStorage: localStorage));
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadTransports();
    await _loadStops();
  }

  Future<void> _loadTransports() async {
    final result = await _transportRepository.getTransports();
    print('TRANSPORT : ${result}');
    result.fold(
            (failure) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load transports: ${failure.message}')),
            ),
              (transports) => setState(() {
            _transports = transports;
          }),
        );
    }

  Future<void> _loadStops() async {
    final result = await _transportRepository.getAllStops();
    result.fold(
          (failure) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load stops: ${failure.message}'))),
          (stops) => setState(() {
        _stops = stops;
      }),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('search')!),
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // From Stop Dropdown
              DropdownButtonFormField<Stop>(
                value: _selectedFromStop,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('from')!,
                  prefixIcon: const Icon(Icons.location_on),
                ),
                items: _stops.map((stop) {
                  return DropdownMenuItem<Stop>(
                    value: stop,
                    child: Text(stop.stationName),
                  );
                }).toList(),
                onChanged: (Stop? newValue) {
                  setState(() {
                    _selectedFromStop = newValue;
                    // Reset destination if it's the same as origin
                    if (_selectedToStop == newValue) {
                      _selectedToStop = null;
                    }
                  });
                },
                validator: (value) => value == null
                    ? AppLocalizations.of(context)!.translate('select_departure')!
                    : null,
              ),
              const SizedBox(height: 16),

              // To Stop Dropdown
              DropdownButtonFormField<Stop>(
                value: _selectedToStop,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('to')!,
                  prefixIcon: const Icon(Icons.location_on),
                ),
                items: _stops
                    .where((stop) => stop != _selectedFromStop)
                    .map((stop) {
                  return DropdownMenuItem<Stop>(
                    value: stop,
                    child: Text(stop.stationName),
                  );
                }).toList(),
                onChanged: (Stop? newValue) {
                  setState(() {
                    _selectedToStop = newValue;
                  });
                },
                validator: (value) => value == null
                    ? AppLocalizations.of(context)!.translate('select_destination')!
                    : null,
              ),
              const SizedBox(height: 16),

              // Date Selection
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? AppLocalizations.of(context)!.translate('select_date')!
                          : '${AppLocalizations.of(context)!.translate('date')!}: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                    tooltip: AppLocalizations.of(context)!.translate('choose_date')!,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Button
              ElevatedButton(
                onPressed: () {
                  if (_selectedFromStop == null || _selectedToStop == null || _selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.translate('fill_all_fields')!),
                      ),
                    );
                    return;
                  }
                  context.read<BookingBloc>().add(
                    BookingStarted(
                      from: _selectedFromStop!.stationName,
                      to: _selectedToStop!.stationName,
                      date: _selectedDate!,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.translate('search')!),
              ),
              const SizedBox(height: 24),

              // Results
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BookingLoadSuccess) {
                    return Column(
                      children: state.routes.map((route) {
                        final transport = _transports.firstWhere(
                              (t) => t.id == route.transportId,
                          orElse: () => Transport.empty(),
                        );
                        return TransportCard(
                          route: route,
                          transport: transport,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/booking/seats',
                              arguments: {
                                'route': route,
                                'transport': transport,
                              },
                            );
                          },
                        );
                      }).toList(),
                    );
                  }
                  return const SizedBox.shrink();
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
// import 'package:transport_booking/models/transport.dart';
// import 'package:transport_booking/repositories/transport_repository.dart';
// import 'package:transport_booking/services/api_service.dart';
// import 'package:transport_booking/services/local_storage.dart';
//
// import '../../blocs/booking/booking_bloc.dart';
// import '../../widgets/transport_card.dart';
// import '../../utils/localization/app_localizations.dart';
//
// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   final _fromController = TextEditingController();
//   final _toController = TextEditingController();
//   DateTime? _selectedDate;
//
//   late TransportRepository _transportRepository;
//   final LocalStorage localStorage = LocalStorage();
//
//   List<Transport> _transports = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _transportRepository = TransportRepository(apiService: ApiService(localStorage: localStorage));
//     _loadTransports();
//   }
//
//   @override
//   void dispose() {
//     _fromController.dispose();
//     _toController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadTransports() async {
//     final result = await _transportRepository.getTransports();
//     result.fold(
//           (failure) => ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load transports: ${failure.message}')),
//       ),
//           (transports) => setState(() {
//         _transports = transports;
//       }),
//     );
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('search')!),
//       ),
//       body: BlocListener<BookingBloc, BookingState>(
//         listener: (context, state) {
//           if (state is BookingError/*BookingLoadFailure*/) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message/*error*/)),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _fromController,
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.translate('from')!,
//                   prefixIcon: const Icon(Icons.location_on),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _toController,
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.translate('to')!,
//                   prefixIcon: const Icon(Icons.location_on),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       _selectedDate == null
//                           ? AppLocalizations.of(context)!
//                           .translate('select_date')!
//                           : '${AppLocalizations.of(context)!.translate('date')!}: ${_selectedDate!.toLocal()}'.split(' ')[0],
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => _selectDate(context),
//                     child: Text(
//                         AppLocalizations.of(context)!.translate('choose_date')!),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_fromController.text.isEmpty ||
//                       _toController.text.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             AppLocalizations.of(context)!.translate('fill_all_fields')!),
//                       ),
//                     );
//                     return;
//                   }
//                   context.read<BookingBloc>().add(
//                     BookingStarted(
//                       from: _fromController.text,
//                       to: _toController.text,
//                       date: _selectedDate!,
//                     ),
//                   );
//                 },
//                 child: Text(AppLocalizations.of(context)!.translate('search')!),
//               ),
//               const SizedBox(height: 24),
//               BlocBuilder<BookingBloc, BookingState>(
//                 builder: (context, state) {
//                   if (state is BookingLoading || state is BookingSubmissionInProgress/*BookingLoadInProgress*/) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is BookingLoadSuccess/*BookingsLoaded*/) {
//                     return Column(
//                       children: state.routes.map((route) {
//                         // find the transport object for this route.transportId from somewhere (maybe state.transports)
//                         // final transport = yourTransportList.firstWhere((t) => t.id == route.transportId);
//                         final transport = _transports.firstWhere(
//                               (t) => t.id == route.transportId,
//                           orElse: () => Transport.empty(), // You should implement a way to create empty or default Transport
//                         );
//
//                         return TransportCard(
//                           route: route,
//                           transport: transport,//route.transport,
//                           onTap: () {
//                             Navigator.pushNamed(
//                               context,
//                               '/booking/seats',
//                               arguments: {
//                                 'route': route,
//                                 'transport': route.transportId//route.transport,
//                               },
//                             );
//                           },
//                         );
//                       }).toList(),
//                     );
//                   }
//                   return const SizedBox.shrink();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }