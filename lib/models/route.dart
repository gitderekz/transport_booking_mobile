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

  // Optional extras from booking response
  final String? transportType;
  final String? transportName;
  final String? pickupStationName;
  final String? dropoffStationName;
  final String? pickupTime;
  final String? dropoffTime;

  const Route({
    required this.id,
    required this.transportId,
    required this.origin,
    required this.destination,
    required this.basePrice,
    required this.durationMinutes,
    required this.stops,
    this.transportType,
    this.transportName,
    this.pickupStationName,
    this.dropoffStationName,
    this.pickupTime,
    this.dropoffTime,
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
      transportType: json['transport_type'],
      transportName: json['transport_name'],
      pickupStationName: json['pickup_station_name'],
      dropoffStationName: json['dropoff_station_name'],
      pickupTime: json['pickup_time'],
      dropoffTime: json['dropoff_time'],
    );
  }

  factory Route.empty() {
    return Route(
      id: '',
      transportId: '',
      origin: '',
      destination: '',
      basePrice: 0.0,
      durationMinutes: 0,
      stops: [],
      transportType: '',
      transportName: '',
      pickupStationName: '',
      dropoffStationName: '',
      pickupTime: '',
      dropoffTime: '',
    );
  }


  @override
  List<Object?> get props => [
    id,
    transportId,
    origin,
    destination,
    basePrice,
    durationMinutes,
    stops,
    transportType,
    transportName,
    pickupStationName,
    dropoffStationName,
    pickupTime,
    dropoffTime,
  ];
}




// import 'package:equatable/equatable.dart';
// import 'package:transport_booking/models/stop.dart';
//
// class Route extends Equatable {
//   final String id;
//   final String transportId;
//   final String origin;
//   final String destination;
//   final double basePrice;
//   final int durationMinutes;
//   final List<Stop> stops;
//
//   const Route({
//     required this.id,
//     required this.transportId,
//     required this.origin,
//     required this.destination,
//     required this.basePrice,
//     required this.durationMinutes,
//     required this.stops,
//   });
//
//   factory Route.fromJson(Map<String, dynamic> json) {
//     return Route(
//       id: json['id'].toString(),
//       transportId: json['transport_id'].toString(),
//       origin: json['origin'],
//       destination: json['destination'],
//       basePrice: double.parse(json['base_price'].toString()),
//       durationMinutes: int.parse(json['duration_minutes'].toString()),
//       stops: (json['stops'] as List<dynamic>? ?? [])
//           .map((e) => Stop.fromJson(e))
//           .toList(),
//     );
//   }
//
//   @override
//   List<Object> get props => [
//     id,
//     transportId,
//     origin,
//     destination,
//     basePrice,
//     durationMinutes,
//     stops,
//   ];
// }