// lib/pages/home/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/models/stop.dart';
import 'package:transport_booking/models/transport.dart';
import 'package:transport_booking/repositories/transport_repository.dart';
import 'package:transport_booking/services/api_service.dart';
import 'package:transport_booking/services/local_storage.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';
import 'package:transport_booking/widgets/main_navigation.dart';
import 'package:transport_booking/widgets/neu_dropdown.dart';
import 'package:transport_booking/widgets/neu_button.dart';
import 'package:transport_booking/widgets/transport_card.dart';
import 'package:transport_booking/models/route.dart' as r;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  DateTime? _selectedDate;
  late TransportRepository _transportRepository;
  final LocalStorage localStorage = LocalStorage();
  List<Transport> _transports = [];
  List<Stop> _stops = [];
  Stop? _selectedFromStop;
  Stop? _selectedToStop;
  bool _isLoadingStops = true;
  Map<String, dynamic>? _queuedArguments; // Store arguments until stops load
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  HomeDataLoaded? cachedHomeData;

  @override
  void initState() {
    super.initState();
    _transportRepository = TransportRepository(apiService: ApiService(localStorage: localStorage));
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadTransports();
    await _loadStops().then((_) {
      // After stops load, process any queued arguments
      if (_queuedArguments != null) {
        _processArguments(_queuedArguments!);
        _queuedArguments = null;
      }
    });
  }

  Future<void> _loadTransports() async {
    final result = await _transportRepository.getTransports();
    result.fold(
          (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load transports: ${failure.message}')),
      ),
          (transports) => setState(() => _transports = transports),
    );
  }

  Future<void> _loadStops() async {
    setState(() => _isLoadingStops = true);
    final result = await _transportRepository.getAllStops();
    result.fold(
          (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load stops: ${failure.message}'))
        );
        setState(() => _isLoadingStops = false);
      },
          (stops) {
        setState(() {
          _stops = stops;
          _isLoadingStops = false;
        });
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      if (_isLoadingStops) {
        // Queue arguments if stops are still loading
        _queuedArguments = args;
      } else {
        _processArguments(args);
      }
    }
  }

  void _processArguments(Map<String, dynamic> args) {
    if (args['prefilledRoute'] != null) {
      final route = args['prefilledRoute'] as r.Route;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedFromStop = _stops.firstWhere(
                (s) => s.stationName == route.origin,
            orElse: () => Stop.empty(),
          );
          _selectedToStop = _stops.firstWhere(
                (s) => s.stationName == route.destination,
            orElse: () => Stop.empty(),
          );

          // Update the text controllers
          if (_selectedFromStop != null) {
            _fromController.text = _selectedFromStop!.stationName;
          }
          if (_selectedToStop != null) {
            _toController.text = _selectedToStop!.stationName;
          }
        });

        // if (_selectedFromStop != null && _selectedToStop != null) {
        //   context.read<BookingBloc>().add(
        //     BookingStarted(
        //       from: _selectedFromStop!.stationName,
        //       to: _selectedToStop!.stationName,
        //       date: _selectedDate,
        //     ),
        //   );
        // }
        _processSearch();
      });
    } else if (args['preloaded'] == true && args['transportType'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<BookingBloc>().add(
          LoadRoutesByTransportType(args['transportType']),
        );
      });
    }
  }

  void _processSearch() {
    if (_selectedFromStop != null && _selectedToStop != null) {
      // Cache current home data before starting search
      context.read<BookingBloc>().add(CacheCurrentState());
      final currentState = context.read<BookingBloc>().state;
      if (currentState is HomeDataLoaded) {
        cachedHomeData = currentState;
      }

      context.read<BookingBloc>().add(
        BookingStarted(
          from: _selectedFromStop!.stationName,
          to: _selectedToStop!.stationName,
          date: _selectedDate,
        ),
      );
    }
  }

  void restoreHomeData() {
    context.read<BookingBloc>().add(RestoreCachedState());
    if (cachedHomeData != null) {
      context.read<BookingBloc>().add(RestoreHomeData(cachedHomeData!));
    }
    context.read<BookingBloc>().add(RestorePreviousState());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
            dialogBackgroundColor: Theme.of(context).colorScheme.background,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('find_your_ride')!,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // // From Stop Dropdown
                      // NeuDropdown<Stop>(
                      //   value: _selectedFromStop,
                      //   hint: AppLocalizations.of(context)!.translate('from'),
                      //   items: _stops.map((stop) {
                      //     return DropdownMenuItem<Stop>(
                      //       value: stop,
                      //       child: Text(
                      //         stop.stationName,
                      //         style: Theme.of(context).textTheme.bodyLarge,
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (Stop? newValue) {
                      //     setState(() {
                      //       _selectedFromStop = newValue;
                      //       if (_selectedToStop == newValue) {
                      //         _selectedToStop = null;
                      //       }
                      //     });
                      //   },
                      //   icon: Icons.location_on_outlined,
                      // ),
                      // SizedBox(
                      //   width: double.infinity, // or a fixed width if you prefer
                      //   child: SearchableDropdown<Stop>(
                      //     value: _selectedFromStop,
                      //     hint: AppLocalizations.of(context)!.translate('from'),
                      //     items: _stops.map((stop) {
                      //       return DropdownMenuItem<Stop>(
                      //         value: stop,
                      //         child: Text(
                      //           stop.stationName,
                      //           style: Theme.of(context).textTheme.bodyLarge,
                      //         ),
                      //       );
                      //     }).toList(),
                      //     onChanged: (Stop? newValue) {
                      //       setState(() {
                      //         _selectedFromStop = newValue;
                      //         if (_selectedToStop == newValue) {
                      //           _selectedToStop = null;
                      //         }
                      //       });
                      //     },
                      //     icon: Icons.location_on_outlined,
                      //   ),
                      // ),
                      StopAutocompleteField(
                        hint: AppLocalizations.of(context)!.translate('from')!,
                        selectedStop: _selectedFromStop,
                        stops: _stops,
                        controller: _fromController,
                        onSelected: (Stop? stop) {
                          setState(() {
                            _selectedFromStop = stop;
                            _fromController.text = stop?.stationName ?? '';
                            if (_selectedToStop == stop) {
                              _selectedToStop = null;
                              _toController.text = '';
                            }
                          });
                        },
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 16),

                      // // To Stop Dropdown
                      // NeuDropdown<Stop>(
                      //   value: _selectedToStop,
                      //   hint: AppLocalizations.of(context)!.translate('to'),
                      //   items: _stops.where((stop) => stop != _selectedFromStop).map((stop) {
                      //     return DropdownMenuItem<Stop>(
                      //       value: stop,
                      //       child: Text(
                      //         stop.stationName,
                      //         style: Theme.of(context).textTheme.bodyLarge,
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (Stop? newValue) {
                      //     setState(() => _selectedToStop = newValue);
                      //   },
                      //   icon: Icons.location_on_outlined,
                      // ),
                      // SizedBox(
                      //   width: double.infinity, // or a fixed width if you prefer
                      //   child: SearchableDropdown<Stop>(
                      //     value: _selectedToStop,
                      //     hint: AppLocalizations.of(context)!.translate('to'),
                      //     items: _stops.where((stop) => stop != _selectedFromStop).map((stop) {
                      //       return DropdownMenuItem<Stop>(
                      //         value: stop,
                      //         child: Text(
                      //           stop.stationName,
                      //           style: Theme.of(context).textTheme.bodyLarge,
                      //         ),
                      //       );
                      //     }).toList(),
                      //     onChanged: (Stop? newValue) {
                      //       setState(() => _selectedToStop = newValue);
                      //     },
                      //     icon: Icons.location_on_outlined,
                      //   ),
                      // ),
                      StopAutocompleteField(
                        hint: AppLocalizations.of(context)!.translate('to')!,
                        selectedStop: _selectedToStop,
                        stops: _stops.where((stop) => stop != _selectedFromStop).toList(),
                        controller: _toController,
                        onSelected: (Stop? stop) {
                          setState(() {
                            _selectedToStop = stop;
                            _toController.text = stop?.stationName ?? '';
                          });
                        },
                        icon: Icons.location_on_outlined,
                        enabled: _selectedFromStop != null,
                      ),
                      const SizedBox(height: 16),

                      // Date Selection
                      Row(
                        children: [
                          Expanded(
                            child: GlassCard(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              borderRadius: 12,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _selectedDate == null
                                        ? AppLocalizations.of(context)!.translate('select_date')!
                                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          NeuButton(
                            onPressed: () => _selectDate(context),
                            child: Icon(
                              Icons.calendar_month_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Search Button
                      NeuButton(
                        onPressed: () {
                          if (_selectedFromStop == null || _selectedToStop == null /*|| _selectedDate == null*/) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.translate('fill_all_fields')!,
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                            return;
                          }
                          // context.read<BookingBloc>().add(
                          //   BookingStarted(
                          //     from: _selectedFromStop!.stationName,
                          //     to: _selectedToStop!.stationName,
                          //     date: _selectedDate,
                          //   ),
                          // );
                          _processSearch();
                        },
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate('search')!,
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
                        return GlassCard(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: TransportCard(
                            route: route,
                            transport: transport,
                            onTap: () {
                              // Get the parent navigator state
                              final mainNavState = context.findAncestorStateOfType<MainNavigationState>();
                              try {
                                mainNavState?.navigateToSeatSelection(context, {
                                  'route': route,
                                  'transport': transport,
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to navigate: $e')),
                                );
                              }

                              // if (mainNavState != null) {
                              //   // Use the root navigator instead of current context
                              //   Navigator.of(context, rootNavigator: true).pushNamed(
                              //     '/booking/seats',
                              //     arguments: {
                              //       'route': route,
                              //       'transport': transport,
                              //     },
                              //   );
                              // }
                            },
                          ),
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
      ],
    );
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  //
  //   if (args != null) {
  //     if (args['prefilledRoute'] != null) {
  //       final route = args['prefilledRoute'] as r.Route;
  //       print('Pre: ${args['prefilledRoute']} : ${route} : ${route.origin} : ${route.destination}');
  //       print('Stops: ${_stops.length} : ${_stops} : ${_stops.firstWhere((s) => s.stationName == route.origin)} ');
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         setState(() {
  //           _selectedFromStop = _stops.firstWhere(
  //                 (s) => s.stationName == route.origin,
  //             orElse: () => Stop.empty(),
  //           );
  //           _selectedToStop = _stops.firstWhere(
  //                 (s) => s.stationName == route.destination,
  //             orElse: () => Stop.empty(),
  //           );
  //         });
  //         if (_selectedFromStop != null && _selectedToStop != null) {
  //           context.read<BookingBloc>().add(
  //             BookingStarted(
  //               from: _selectedFromStop!.stationName,
  //               to: _selectedToStop!.stationName,
  //               date: _selectedDate,
  //             ),
  //           );
  //         }
  //       });
  //     }
  //     else if (args['preloaded'] == true && args['transportType'] != null) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         context.read<BookingBloc>().add(
  //           LoadRoutesByTransportType(args['transportType']),
  //         );
  //       });
  //     }
  //   }
  // }
}



// // lib/pages/home/search_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transport_booking/models/stop.dart';
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
//   DateTime? _selectedDate;
//   late TransportRepository _transportRepository;
//   final LocalStorage localStorage = LocalStorage();
//
//   List<Transport> _transports = [];
//   List<Stop> _stops = [];
//   Stop? _selectedFromStop;
//   Stop? _selectedToStop;
//
//   @override
//   void initState() {
//     super.initState();
//     _transportRepository = TransportRepository(apiService: ApiService(localStorage: localStorage));
//     _loadInitialData();
//   }
//
//   Future<void> _loadInitialData() async {
//     await _loadTransports();
//     await _loadStops();
//   }
//
//   Future<void> _loadTransports() async {
//     final result = await _transportRepository.getTransports();
//     print('TRANSPORT : ${result}');
//     result.fold(
//             (failure) => ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load transports: ${failure.message}')),
//             ),
//               (transports) => setState(() {
//             _transports = transports;
//           }),
//         );
//     }
//
//   Future<void> _loadStops() async {
//     final result = await _transportRepository.getAllStops();
//     result.fold(
//           (failure) => ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load stops: ${failure.message}'))),
//           (stops) => setState(() {
//         _stops = stops;
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
//           if (state is BookingError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)));
//           }
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // From Stop Dropdown
//               DropdownButtonFormField<Stop>(
//                 value: _selectedFromStop,
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.translate('from')!,
//                   prefixIcon: const Icon(Icons.location_on),
//                 ),
//                 items: _stops.map((stop) {
//                   return DropdownMenuItem<Stop>(
//                     value: stop,
//                     child: Text(stop.stationName),
//                   );
//                 }).toList(),
//                 onChanged: (Stop? newValue) {
//                   setState(() {
//                     _selectedFromStop = newValue;
//                     // Reset destination if it's the same as origin
//                     if (_selectedToStop == newValue) {
//                       _selectedToStop = null;
//                     }
//                   });
//                 },
//                 validator: (value) => value == null
//                     ? AppLocalizations.of(context)!.translate('select_departure')!
//                     : null,
//               ),
//               const SizedBox(height: 16),
//
//               // To Stop Dropdown
//               DropdownButtonFormField<Stop>(
//                 value: _selectedToStop,
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.translate('to')!,
//                   prefixIcon: const Icon(Icons.location_on),
//                 ),
//                 items: _stops
//                     .where((stop) => stop != _selectedFromStop)
//                     .map((stop) {
//                   return DropdownMenuItem<Stop>(
//                     value: stop,
//                     child: Text(stop.stationName),
//                   );
//                 }).toList(),
//                 onChanged: (Stop? newValue) {
//                   setState(() {
//                     _selectedToStop = newValue;
//                   });
//                 },
//                 validator: (value) => value == null
//                     ? AppLocalizations.of(context)!.translate('select_destination')!
//                     : null,
//               ),
//               const SizedBox(height: 16),
//
//               // Date Selection
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       _selectedDate == null
//                           ? AppLocalizations.of(context)!.translate('select_date')!
//                           : '${AppLocalizations.of(context)!.translate('date')!}: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.calendar_today),
//                     onPressed: () => _selectDate(context),
//                     tooltip: AppLocalizations.of(context)!.translate('choose_date')!,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Search Button
//               ElevatedButton(
//                 onPressed: () {
//                   if (_selectedFromStop == null || _selectedToStop == null || _selectedDate == null) {
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
//                       from: _selectedFromStop!.stationName,
//                       to: _selectedToStop!.stationName,
//                       date: _selectedDate!,
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(AppLocalizations.of(context)!.translate('search')!),
//               ),
//               const SizedBox(height: 24),
//
//               // Results
//               BlocBuilder<BookingBloc, BookingState>(
//                 builder: (context, state) {
//                   if (state is BookingLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is BookingLoadSuccess) {
//                     return Column(
//                       children: state.routes.map((route) {
//                         final transport = _transports.firstWhere(
//                               (t) => t.id == route.transportId,
//                           orElse: () => Transport.empty(),
//                         );
//                         return TransportCard(
//                           route: route,
//                           transport: transport,
//                           onTap: () {
//                             Navigator.pushNamed(
//                               context,
//                               '/booking/seats',
//                               arguments: {
//                                 'route': route,
//                                 'transport': transport,
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
// // ****************************



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