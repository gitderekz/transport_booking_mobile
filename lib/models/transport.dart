import 'dart:convert';

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
  final List<List<Map<String, dynamic>>>? seatArrangement;

  const Transport({
    required this.id,
    required this.type,
    required this.identifier,
    required this.name,
    this.operator,
    required this.totalSeats,
    required this.seatLayout,
    this.amenities,
    this.seatArrangement,
  });

  String get layoutType => seatLayout['layout']?.toString() ?? '2-2';
  int get rows => seatLayout['rows'] as int? ?? 0;
  int get columns => seatLayout['columns'] as int? ?? 0;
  String? get driverPosition => seatLayout['driver_position']?.toString();

  factory Transport.fromJson(Map<String, dynamic> json) {
    // Parse seat_layout
    final dynamic rawSeatLayout = json['seat_layout'];
    final Map<String, dynamic> parsedSeatLayout = rawSeatLayout is String
        ? Map<String, dynamic>.from(jsonDecode(rawSeatLayout))
        : Map<String, dynamic>.from(rawSeatLayout ?? {});

    // Parse amenities
    final dynamic rawAmenities = json['amenities'];
    final Map<String, dynamic>? parsedAmenities = rawAmenities == null
        ? null
        : rawAmenities is String
        ? Map<String, dynamic>.from(jsonDecode(rawAmenities))
        : Map<String, dynamic>.from(rawAmenities);

    // Parse seat_arrangement if available
    List<List<Map<String, dynamic>>>? parsedSeatArrangement;
    if (json['seat_arrangement'] != null) {
      parsedSeatArrangement = (json['seat_arrangement'] as List)
          .map((row) => (row as List).map((seat) => Map<String, dynamic>.from(seat)).toList())
          .toList();
    }

    return Transport(
      id: json['id'].toString(),
      type: json['type'],
      identifier: json['identifier'],
      name: json['name'],
      operator: json['operator'],
      totalSeats: int.parse(json['total_seats'].toString()),
      seatLayout: parsedSeatLayout,
      amenities: parsedAmenities,
      seatArrangement: parsedSeatArrangement,
    );
  }

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
      seatArrangement: null,
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
    seatArrangement,
  ];
}



// import 'dart:convert';
//
// import 'package:equatable/equatable.dart';
//
// class Transport extends Equatable {
//   final String id;
//   final String type;
//   final String identifier;
//   final String name;
//   final String? operator;
//   final int totalSeats;
//   final Map<String, dynamic> seatLayout;
//   final Map<String, dynamic>? amenities;
//
//   const Transport({
//     required this.id,
//     required this.type,
//     required this.identifier,
//     required this.name,
//     this.operator,
//     required this.totalSeats,
//     required this.seatLayout,
//     this.amenities,
//   });
//
//
//   factory Transport.fromJson(Map<String, dynamic> json) {
//     // Decode seat_layout if it's a String
//     final dynamic rawSeatLayout = json['seat_layout'];
//     final Map<String, dynamic> parsedSeatLayout = rawSeatLayout is String
//         ? Map<String, dynamic>.from(
//         jsonDecode(rawSeatLayout) as Map<String, dynamic>)
//         : Map<String, dynamic>.from(rawSeatLayout ?? {});
//
//     // Decode amenities if it's a String
//     final dynamic rawAmenities = json['amenities'];
//     final Map<String, dynamic>? parsedAmenities = rawAmenities == null
//         ? null
//         : rawAmenities is String
//         ? Map<String, dynamic>.from(
//         jsonDecode(rawAmenities) as Map<String, dynamic>)
//         : Map<String, dynamic>.from(rawAmenities);
//
//     return Transport(
//       id: json['id'].toString(),
//       type: json['type'],
//       identifier: json['identifier'],
//       name: json['name'],
//       operator: json['operator'],
//       totalSeats: int.parse(json['total_seats'].toString()),
//       seatLayout: parsedSeatLayout,
//       amenities: parsedAmenities,
//     );
//   }
// // factory Transport.fromJson(Map<String, dynamic> json) {
//   //   return Transport(
//   //     id: json['id'].toString(),
//   //     type: json['type'],
//   //     identifier: json['identifier'],
//   //     name: json['name'],
//   //     operator: json['operator'],
//   //     totalSeats: int.parse(json['total_seats'].toString()),
//   //     seatLayout: Map<String, dynamic>.from(json['seat_layout'] ?? {}),
//   //     amenities: json['amenities'] != null
//   //         ? Map<String, dynamic>.from(json['amenities'])
//   //         : null,
//   //   );
//   // }
//
//   /// Factory constructor for an empty/default Transport
//   factory Transport.empty() {
//     return const Transport(
//       id: '',
//       type: 'unknown',
//       identifier: '',
//       name: 'Unknown Transport',
//       operator: null,
//       totalSeats: 0,
//       seatLayout: {},
//       amenities: null,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     id,
//     type,
//     identifier,
//     name,
//     operator,
//     totalSeats,
//     seatLayout,
//     amenities,
//   ];
// }