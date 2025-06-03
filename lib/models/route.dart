import 'package:equatable/equatable.dart';
import 'package:transport_booking/models/stop.dart';

class Route extends Equatable {
  final String id;
  final String transportId;
  final String origin;
  final String destination;
  final double basePrice;
  final int durationMinutes;
  final List<Stop> stops;

  const Route({
    required this.id,
    required this.transportId,
    required this.origin,
    required this.destination,
    required this.basePrice,
    required this.durationMinutes,
    required this.stops,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'].toString(),
      transportId: json['transport_id'].toString(),
      origin: json['origin'],
      destination: json['destination'],
      basePrice: double.parse(json['base_price'].toString()),
      durationMinutes: int.parse(json['duration_minutes'].toString()),
      stops: (json['stops'] as List<dynamic>? ?? [])
          .map((e) => Stop.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object> get props => [
    id,
    transportId,
    origin,
    destination,
    basePrice,
    durationMinutes,
    stops,
  ];
}