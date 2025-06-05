import 'package:equatable/equatable.dart';
import 'package:transport_booking/models/route.dart';

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
  final DateTime createdAt;
  final List<Map<String, dynamic>> seats;
  final Route route; // Add this field
  final DateTime date; // Add this field

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
    required this.createdAt,
    required this.seats,
    required this.route,
    required this.date,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'].toString(),
      bookingReference: json['booking_reference'],
      routeId: json['route_id'].toString(),
      transportId: json['transport_id'].toString(),
      pickupStopId: json['pickup_stop_id'].toString(),
      dropoffStopId: json['dropoff_stop_id'].toString(),
      totalPrice: double.parse(json['total_price'].toString()),
      status: json['status'] ?? 'confirmed',
      paymentStatus: json['payment_status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
      seats: List<Map<String, dynamic>>.from(json['seats'] ?? []),
      route: json['route'] != null ? Route.fromJson(json['route']) : Route.empty(), // use fallback if needed
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(), // fallback to now
    );
  }

  // factory Booking.fromJson(Map<String, dynamic> json) {
  //   return Booking(
  //     id: json['id'].toString(),
  //     bookingReference: json['booking_reference'],
  //     routeId: json['route_id'].toString(),
  //     transportId: json['transport_id'].toString(),
  //     pickupStopId: json['pickup_stop_id'].toString(),
  //     dropoffStopId: json['dropoff_stop_id'].toString(),
  //     totalPrice: double.parse(json['total_price'].toString()),
  //     status: json['status'],
  //     paymentStatus: json['payment_status'],
  //     createdAt: DateTime.parse(json['created_at']),
  //     seats: List<Map<String, dynamic>>.from(json['seats'] ?? []),
  //     route: json['route'],
  //     date: json['date'],
  //   );
  // }

  @override
  List<Object> get props => [
    id,
    bookingReference,
    routeId,
    transportId,
    pickupStopId,
    dropoffStopId,
    totalPrice,
    status,
    paymentStatus,
    createdAt,
    seats,
    route,
    date,
  ];
}