import 'package:equatable/equatable.dart';
import 'package:transport_booking/models/route.dart';
import 'package:transport_booking/utils/parsers.dart';

class Booking extends Equatable {
  final String id;
  final String bookingReference;
  final String routeId;
  final String transportId;
  final String pickupStopId;
  final String dropoffStopId;
  final double totalPrice;
  final String status;
  final String paymentStatus;
  final String? paymentMethod;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Map<String, dynamic>> seats;
  final Route route;
  // final Map<String, dynamic> route;
  final DateTime date;

  const Booking({
    required this.id,
    required this.bookingReference,
    required this.routeId,
    required this.transportId,
    required this.pickupStopId,
    required this.dropoffStopId,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.seats,
    required this.route,
    required this.date,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {

    return Booking(
      id: json['id'].toString(),
      bookingReference: json['booking_reference'] ?? '',
      routeId: json['route_id'].toString(),
      transportId: json['transport_id'].toString(),
      pickupStopId: json['pickup_stop_id'].toString(),
      dropoffStopId: json['dropoff_stop_id'].toString(),
      totalPrice: safeParseDouble(json['total_price']), // ✅ use helper
      status: json['status'] ?? 'pending',
      paymentStatus: json['payment_status'] ?? 'unpaid',
      paymentMethod: json['payment_method'],
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
      seats: (json['seats'] as List<dynamic>? ?? []).map((seat) {
        return {
          'seat_number': seat['seat_number']?.toString(),
          'passenger_name': seat['passenger_name']?.toString(),
          'passenger_age': seat['passenger_age']?.toString(),
          'passenger_gender': seat['passenger_gender']?.toString(),
        };
      }).toList(),
      route: Route.fromJson({
        'id': json['route_id'].toString(),
        'transport_id': json['transport_id'].toString(),
        'origin': json['origin'],
        'destination': json['destination'],
        'base_price': json['base_price'],
        'duration_minutes': json['duration_minutes'],
        'stops': json['stops'],
        'transport_type': json['transport_type'],
        'transport_name': json['transport_name'],
        'pickup_station_name': json['pickup_station_name'],
        'dropoff_station_name': json['dropoff_station_name'],
        'pickup_time': json['pickup_time'],
        'dropoff_time': json['dropoff_time'],
      }),
      date: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  // factory Booking.fromJson(Map<String, dynamic> json) {
  //   return Booking(
  //     id: json['id'].toString(),
  //     bookingReference: json['booking_reference'] ?? '',
  //     routeId: json['route_id'].toString(),
  //     transportId: json['transport_id'].toString(),
  //     pickupStopId: json['pickup_stop_id'].toString(),
  //     dropoffStopId: json['dropoff_stop_id'].toString(),
  //     totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
  //     status: json['status'] ?? 'pending',
  //     paymentStatus: json['payment_status'] ?? 'unpaid',
  //     paymentMethod: json['payment_method'],
  //     notes: json['notes'],
  //     createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
  //     updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
  //     seats: (json['seats'] as List<dynamic>? ?? []).map((seat) {
  //       return {
  //         'seat_number': seat['seat_number']?.toString(),
  //         'passenger_name': seat['passenger_name']?.toString(),
  //         'passenger_age': seat['passenger_age']?.toString(),
  //         'passenger_gender': seat['passenger_gender']?.toString(),
  //       };
  //     }).toList(),
  //     route: Route.fromJson({
  //       'id': json['route_id'].toString(),
  //       'transport_id': json['transport_id'].toString(),
  //       'origin': json['origin'],
  //       'destination': json['destination'],
  //       'base_price': json['base_price'],
  //       'duration_minutes': json['duration_minutes'],
  //       'stops': json['stops'],
  //       'transport_type': json['transport_type'],
  //       'transport_name': json['transport_name'],
  //       'pickup_station_name': json['pickup_station_name'],
  //       'dropoff_station_name': json['dropoff_station_name'],
  //       'pickup_time': json['pickup_time'],
  //       'dropoff_time': json['dropoff_time'],
  //     }),
  //     date: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
  //   );
  // }
  // factory Booking.fromJson(Map<String, dynamic> json) {
  //   return Booking(
  //     id: json['id'].toString(),
  //     bookingReference: json['booking_reference'],
  //     routeId: json['route_id'].toString(),
  //     transportId: json['transport_id'].toString(),
  //     pickupStopId: json['pickup_stop_id'].toString(),
  //     dropoffStopId: json['dropoff_stop_id'].toString(),
  //     totalPrice: double.parse(json['total_price'].toString()),
  //     status: json['status'] ?? 'pending',
  //     paymentStatus: json['payment_status'] ?? 'unpaid',
  //     paymentMethod: json['payment_method'],
  //     notes: json['notes'],
  //     createdAt: DateTime.parse(json['created_at']),
  //     updatedAt: DateTime.parse(json['updated_at']),
  //     seats: (json['seats'] as List<dynamic>? ?? [])
  //         .map((seat) => {
  //       'seat_number': seat['seat_number']?.toString(),
  //       'passenger_name': seat['passenger_name']?.toString(),
  //       'passenger_age': seat['passenger_age']?.toString(),
  //       'passenger_gender': seat['passenger_gender']?.toString(),
  //     })
  //         .toList(),
  //     route: Route.fromJson({
  //       'id': json['route_id'].toString(),
  //       'transport_id': json['transport_id'].toString(),
  //       'origin': json['origin'],
  //       'destination': json['destination'],
  //       'base_price': json['base_price'],
  //       'duration_minutes': json['duration_minutes'] ?? 0,
  //       'stops': json['stops'] ?? [],
  //       'transport_type': json['transport_type'],
  //       'transport_name': json['transport_name'],
  //       'pickup_station_name': json['pickup_station_name'],
  //       'dropoff_station_name': json['dropoff_station_name'],
  //       'pickup_time': json['pickup_time'],
  //       'dropoff_time': json['dropoff_time'],
  //     }),
  //     date: DateTime.parse(json['created_at']),
  //   );
  // }

  @override
  List<Object?> get props => [
    id,
    bookingReference,
    routeId,
    transportId,
    pickupStopId,
    dropoffStopId,
    totalPrice,
    status,
    paymentStatus,
    paymentMethod,
    notes,
    createdAt,
    updatedAt,
    seats,
    route,
    date,
  ];
}




// import 'package:equatable/equatable.dart';
// import 'package:transport_booking/models/route.dart';
//
// class Booking extends Equatable {
//   final String id;
//   final String bookingReference;
//   final String routeId;
//   final String transportId;
//   final String pickupStopId;
//   final String dropoffStopId;
//   final double totalPrice;
//   final String status;
//   final String paymentStatus;
//   final DateTime createdAt;
//   final List<Map<String, dynamic>> seats;
//   final Route route; // Add this field
//   final DateTime date; // Add this field
//
//   const Booking({
//     required this.id,
//     required this.bookingReference,
//     required this.routeId,
//     required this.transportId,
//     required this.pickupStopId,
//     required this.dropoffStopId,
//     required this.totalPrice,
//     required this.status,
//     required this.paymentStatus,
//     required this.createdAt,
//     required this.seats,
//     required this.route,
//     required this.date,
//   });
//
//   factory Booking.fromJson(Map<String, dynamic> json) {
//     return Booking(
//       id: json['id'].toString(),
//       bookingReference: json['booking_reference'],
//       routeId: json['route_id'].toString(),
//       transportId: json['transport_id'].toString(),
//       pickupStopId: json['pickup_stop_id'].toString(),
//       dropoffStopId: json['dropoff_stop_id'].toString(),
//       totalPrice: double.parse(json['total_price'].toString()),
//       status: json['status'] ?? 'confirmed',
//       paymentStatus: json['payment_status'] ?? 'pending',
//       createdAt: DateTime.parse(json['created_at']),
//       seats: List<Map<String, dynamic>>.from(json['seats'] ?? []),
//       route: json['route'] != null ? Route.fromJson(json['route']) : Route.empty(), // use fallback if needed
//       date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(), // fallback to now
//     );
//   }
//
//   // factory Booking.fromJson(Map<String, dynamic> json) {
//   //   return Booking(
//   //     id: json['id'].toString(),
//   //     bookingReference: json['booking_reference'],
//   //     routeId: json['route_id'].toString(),
//   //     transportId: json['transport_id'].toString(),
//   //     pickupStopId: json['pickup_stop_id'].toString(),
//   //     dropoffStopId: json['dropoff_stop_id'].toString(),
//   //     totalPrice: double.parse(json['total_price'].toString()),
//   //     status: json['status'],
//   //     paymentStatus: json['payment_status'],
//   //     createdAt: DateTime.parse(json['created_at']),
//   //     seats: List<Map<String, dynamic>>.from(json['seats'] ?? []),
//   //     route: json['route'],
//   //     date: json['date'],
//   //   );
//   // }
//
//   @override
//   List<Object> get props => [
//     id,
//     bookingReference,
//     routeId,
//     transportId,
//     pickupStopId,
//     dropoffStopId,
//     totalPrice,
//     status,
//     paymentStatus,
//     createdAt,
//     seats,
//     route,
//     date,
//   ];
// }