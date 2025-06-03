import 'package:equatable/equatable.dart';

class Stop extends Equatable {
  final String id;
  final String routeId;
  final String stationName;
  final String? stationCode;
  final String? arrivalTime;
  final String? departureTime;
  final int sequenceOrder;
  final double additionalFee;

  const Stop({
    required this.id,
    required this.routeId,
    required this.stationName,
    this.stationCode,
    this.arrivalTime,
    this.departureTime,
    required this.sequenceOrder,
    required this.additionalFee,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'].toString(),
      routeId: json['route_id'].toString(),
      stationName: json['station_name'],
      stationCode: json['station_code'],
      arrivalTime: json['arrival_time'],
      departureTime: json['departure_time'],
      sequenceOrder: int.parse(json['sequence_order'].toString()),
      additionalFee: double.parse(json['additional_fee'].toString()),
    );
  }

  @override
  List<Object?> get props => [
    id,
    routeId,
    stationName,
    stationCode,
    arrivalTime,
    departureTime,
    sequenceOrder,
    additionalFee,
  ];
}