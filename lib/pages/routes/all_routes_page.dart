import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_booking/blocs/booking/booking_bloc.dart';
import 'package:transport_booking/config/routes.dart';
import 'package:transport_booking/utils/localization/app_localizations.dart';
import 'package:transport_booking/widgets/glass_card.dart';
import 'package:transport_booking/widgets/main_navigation.dart';

class AllRoutesPage extends StatefulWidget {
  const AllRoutesPage({super.key});

  @override
  State<AllRoutesPage> createState() => _AllRoutesPageState();
}

class _AllRoutesPageState extends State<AllRoutesPage> {
  @override
  void initState() {
    super.initState();
    // context.read<BookingBloc>().add(LoadAllRoutes());
    // context.read<BookingBloc>().add(LoadInitialData());

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient
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

        // Main content
        BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            print('[UI] Current state: ${state.toString()}'); // 👈 Log state
            if (state is InitialDataLoaded || state is AllRoutesLoaded) {
              final routes = state is InitialDataLoaded
                  ? state.allRoutes
                  : (state as AllRoutesLoaded).routes;

              print('[UI] Loaded ${routes.length} routes');
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: routes.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        AppLocalizations.of(context)!.translate('all_routes') ?? 'All Routes',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  final route = routes[index - 1];
                  return GlassCard(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text('${route.origin} → ${route.destination}'),
                      subtitle: Text('Tsh ${route.basePrice.toStringAsFixed(2)}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        final mainNav = context.findAncestorStateOfType<MainNavigationState>();
                        mainNav?.handleSearchArguments({
                          'prefilledRoute': route,
                        });
                        // Navigator.pushNamed(
                        //   context,
                        //   AppRoutes.search,
                        //   arguments: {
                        //     'prefilledRoute': route,
                        //   },
                        // );
                      },
                    ),
                  );
                },
              );
            }
            if (state is BookingError) {
              print('[UI] Error: ${state.message}');
              return Center(child: Text('Error: ${state.message}'));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
