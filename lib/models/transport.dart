import 'package:equatable/equatable.dart';

class Transport extends Equatable {
  final String id;
  final String type;
  final String identifier;
  final String name;
  final String? operator;
  final int totalSeats;
  final Map<String, dynamic> seatLayout;
  final Map<String, dynamic>? amenities;

  const Transport({
    required this.id,
    required this.type,
    required this.identifier,
    required this.name,
    this.operator,
    required this.totalSeats,
    required this.seatLayout,
    this.amenities,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['id'].toString(),
      type: json['type'],
      identifier: json['identifier'],
      name: json['name'],
      operator: json['operator'],
      totalSeats: int.parse(json['total_seats'].toString()),
      seatLayout: Map<String, dynamic>.from(json['seat_layout'] ?? {}),
      amenities: json['amenities'] != null
          ? Map<String, dynamic>.from(json['amenities'])
          : null,
    );
  }

  /// Factory constructor for an empty/default Transport
  factory Transport.empty() {
    return const Transport(
      id: '',
      type: 'unknown',
      identifier: '',
      name: 'Unknown Transport',
      operator: null,
      totalSeats: 0,
      seatLayout: {},
      amenities: null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    identifier,
    name,
    operator,
    totalSeats,
    seatLayout,
    amenities,
  ];
}