import 'package:dartz/dartz.dart';

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
      final response = await apiService.get('/transports/routes/search', params: {
        'from': from,
        'to': to,
        if (date != null) 'date': date.toIso8601String(),
      });

      final routes = (response['data'] as List)
          .map((json) => Route.fromJson(json))
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
  }) async {
    try {
      final response = await apiService.post('/bookings', {
        'route_id': routeId,
        'transport_id': transportId,
        'pickup_stop_id': pickupStopId,
        'dropoff_stop_id': dropoffStopId,
        'seats': seats,
      });

      final booking = Booking.fromJson(response['data']);
      return Right(booking);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<Booking>>> getUserBookings() async {
    try {
      final response = await apiService.get('/bookings/user');
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
}