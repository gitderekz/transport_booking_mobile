import 'package:dartz/dartz.dart';

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
      final response = await apiService.get('/routes', params: {
        'from': from,
        'to': to,
        if (date != null) 'date': date,
      });
      final List<dynamic> data = response['data'] ?? [];
      final routes = data.map((json) => Route.fromJson(json)).toList();
      return Right(routes);
    } catch (e) {
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
}