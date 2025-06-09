import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart' as printer;

import '../../models/booking.dart';
import '../../models/route.dart';
import '../../services/api_service.dart';
import '../../utils/failure.dart';

class BookingRepository {
  final ApiService apiService;

  BookingRepository({required this.apiService});

  Future<Either<Failure, List<Route>>> searchRoutes({
    required String from,
    required String to,
    DateTime? date,
  }) async {
    try {
      print('SEARCH-ROUTES' );
      final response = await apiService.get('/transports/routes/search', params: {
        'from': from,
        'to': to,
        if (date != null) 'date': date.toIso8601String(),
      });

      print('ROUTES2: ' );
      final routes = (response['data'] as List)
          // .map((json) => Route.fromJson(json))
          // .toList();
          .map((json) => Route.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(routes);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, Booking>> createBooking({
    required String routeId,
    required String transportId,
    required String pickupStopId,
    required String dropoffStopId,
    required List<Map<String, dynamic>> seats,
    required String? payment_method,
    required Map<String, dynamic>? paymentDetails,
    required String? notes,
  }) async {
    try {
      final response = await apiService.post('/bookings', {
        'routeId': routeId,
        'transportId': transportId,
        'pickupStopId': pickupStopId,
        'dropoffStopId': dropoffStopId,
        'seats': seats,
        'payment_method': payment_method,
        'paymentDetails': paymentDetails,
        'notes': notes,
      });
      // print('booking=> ${response['booking']}');
      printer.debugPrint('booking=> ${response['booking']}', wrapWidth: 1024);
      // Ensure the response contains all required fields
      if (response['booking'] == null) {
        return Left(Failure(message: 'Invalid booking response from server'));
      }

      final booking = Booking.fromJson(response['booking']);
      // final booking = Booking.fromJson(response['booking'] as Map<String, dynamic>);
      print('BOOK: ${booking.toString()}');
      return Right(booking);
    } catch (e) {
      print('ERROR: ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<Booking>>> getUserBookings() async {
    try {
      // final response = await apiService.get('/bookings/user');
      final response = await apiService.get('/bookings');
      final bookings = (response['data'] as List)
          .map((json) => Booking.fromJson(json))
          .toList();
      return Right(bookings);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    try {
      await apiService.delete('/bookings/$bookingId');
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  // Add these methods to booking_repository.dart
  Future<Either<Failure, List<Route>>> getPopularRoutes() async {
    try {
      final response = await apiService.get('/routes/popular');
      printer.debugPrint('ROUTES=> ${response}', wrapWidth: 1024);
      final routes = (response['data'] as List)
          .map((json) => Route.fromJson(json))
          .toList();
      return Right(routes);
    } catch (e) {
      print('Error: ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<Route>>> getRoutesByTransportType(String type) async {
    try {
      final response = await apiService.get('/routes', params: {
        'transport_type': type,
      });
      final routes = (response['data'] as List)
          .map((json) => Route.fromJson(json))
          .toList();
      return Right(routes);
    } catch (e) {
      print('Error: ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<Route>>> getAllRoutes() async {
    try {
      final response = await apiService.get('/routes');
      print('[Repo] Response: $response');
      final routes = (response['data'] as List)
          .map((json) => Route.fromJson(json))
          .toList();
      return Right(routes);
    } catch (e) {
      print('Error: ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }
}