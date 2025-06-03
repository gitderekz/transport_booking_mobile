import 'package:flutter/material.dart'hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/booking/booking_bloc.dart';
import '../../models/route.dart';
import '../../models/transport.dart';
import '../../widgets/stop_timeline.dart';
import '../../utils/localization/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('select_stops')!),
      ),
      body: SingleChildScrollView(
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
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.translate('pickup_point')!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...widget.route.stops.map((stop) {
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
              );
            }),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.translate('dropoff_point')!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...widget.route.stops.map((stop) {
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
              );
            }),
            const SizedBox(height: 16),
            StopTimeline(
              stops: widget.route.stops,
              pickupStopId: _pickupStop,
              dropoffStopId: _dropoffStop,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickupStop != null && _dropoffStop != null
                  ? () {
                context.read<BookingBloc>().add(
                  BookingStopsSelected(
                    // pickupStopId: _pickupStop!.id,
                    // dropoffStopId: _dropoffStop!.id,
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
              }
                  : null,
              child: Text(
                  AppLocalizations.of(context)!.translate('continue')!),
            ),
          ],
        ),
      ),
    );
  }
}