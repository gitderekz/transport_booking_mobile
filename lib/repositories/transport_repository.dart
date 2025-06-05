import 'package:dartz/dartz.dart';
import 'package:transport_booking/models/stop.dart';

import '../models/route.dart';
import '../models/transport.dart';
import '../services/api_service.dart';
import '../utils/failure.dart';

class TransportRepository {
  final ApiService apiService;

  TransportRepository({required this.apiService});

  Future<Either<Failure, List<Transport>>> getTransports({String? type}) async {
    try {
      final response = await apiService.get('/transports', params: {
        if (type != null) 'type': type,
      });
      final List<dynamic> data = response['data'] ?? [];
      final transports = data.map((json) => Transport.fromJson(json)).toList();
      return Right(transports);
    } catch (e) {
      print('TRANS: ${e.toString()}');
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, Transport>> getTransportById(String id) async {
    try {
      final response = await apiService.get('/transports/$id');
      return Right(Transport.fromJson(response['data']));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<Route>>> searchRoutes({
    required String from,
    required String to,
    String? date,
  }) async {
    try {
      final response = await apiService.get('/routes/search', params: {
        'from': from,
        'to': to,
        if (date != null) 'date': date,
      });
      print('ROUTES: ${response}' );
      final List<dynamic> data = response['data'] ?? [];
      print('ROUTES: ${data}' );
      final routes = data.map((json) => Route.fromJson(json)).toList();
      return Right(routes);
    } catch (e) {
      print('STOPS: ${e.toString()}' );
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<Stop>>> getAllStops() async {
    try {
      final response = await apiService.get('/stops');
      final List<dynamic> data = response['data'] ?? [];
      final stops = data.map((json) => Stop.fromJson(json)).toList();
      print('STOPSS: ${stops}' );
      return Right(stops);
    } catch (e) {
      print('STOPS: ${e.toString()}' );
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<String>>> getAvailableSeats({
    required String routeId,
    required String transportId,
  }) async {
    try {
      final response = await apiService.get(
        '/transports/$transportId/routes/$routeId/seats/available',
      );
      final List<dynamic> data = response['data'] ?? [];
      return Right(data.map((e) => e.toString()).toList());
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }


  Future<Either<Failure, List<Stop>>> getStopsByRoute(String routeId) async {
    try {
      final response = await apiService.get('/stops/route/$routeId');
      final List<dynamic> data = response['data'] ?? [];
      final stops = data.map((json) => Stop.fromJson(json)).toList();
      return Right(stops);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<Stop>>> searchStops(String query) async {
    try {
      final response = await apiService.get('/stops/search', params: {'q': query});
      final List<dynamic> data = response['data'] ?? [];
      final stops = data.map((json) => Stop.fromJson(json)).toList();
      return Right(stops);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}