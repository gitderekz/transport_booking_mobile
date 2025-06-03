import 'package:flutter/material.dart';

import '../../models/stop.dart';

class StopTimeline extends StatelessWidget {
  final List<Stop> stops;
  final String? pickupStopId;
  final String? dropoffStopId;

  const StopTimeline({
    super.key,
    required this.stops,
    this.pickupStopId,
    this.dropoffStopId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: stops.map((stop) {
        final isPickup = stop.id == pickupStopId;
        final isDropoff = stop.id == dropoffStopId;
        final isBetween = pickupStopId != null &&
            dropoffStopId != null &&
            stops.firstWhere((s) => s.id == pickupStopId).sequenceOrder <
                stop.sequenceOrder &&
            stops.firstWhere((s) => s.id == dropoffStopId).sequenceOrder >
                stop.sequenceOrder;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isPickup
                          ? Colors.green
                          : isDropoff
                          ? Colors.red
                          : isBetween
                          ? Colors.blue
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        stop.sequenceOrder.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (stop != stops.last)
                    Container(
                      width: 2,
                      height: 40,
                      color: Colors.grey,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop.stationName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPickup
                            ? Colors.green
                            : isDropoff
                            ? Colors.red
                            : isBetween
                            ? Colors.blue
                            : null,
                      ),
                    ),
                    if (stop.arrivalTime != null || stop.departureTime != null)
                      Text(
                        '${stop.arrivalTime ?? ''} - ${stop.departureTime ?? ''}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}