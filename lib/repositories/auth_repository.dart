// lib/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';

import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../services/local_storage.dart';
import '../../utils/failure.dart';

class AuthRepository {
  final ApiService apiService;
  final LocalStorage localStorage;

  AuthRepository({required this.apiService, required this.localStorage});

  Future<Either<Failure, User>> login({
    String? email,
    String? phone,
    required String password,
  }) async {
    try {
      final response = await apiService.post('/auth/login', {
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        'password': password,
      });

      final user = User.fromJson(response['user']);
      final token = response['token'];

      await localStorage.setToken(token);
      await localStorage.setUser(user);

      return Right(user);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, User>> register({
    String? email,
    String? phone,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await apiService.post('/auth/register', {
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      });

      final user = User.fromJson(response['user']);
      final token = response['token'];

      await localStorage.setToken(token);
      await localStorage.setUser(user);

      return Right(user);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      await localStorage.clear();
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localStorage.getUser();
      return Right(user);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}



// import 'package:dartz/dartz.dart';
//
// import '../../models/user.dart';
// import '../../services/api_service.dart';
// import '../../services/local_storage.dart';
// import '../../utils/failure.dart';
//
// class AuthRepository {
//   final ApiService apiService;
//   final LocalStorage localStorage;
//
//   AuthRepository({required this.apiService, required this.localStorage});
//
//   Future<Either<Failure, User>> login({
//     String? email,
//     String? phone,
//     required String password,
//   }) async {
//     try {
//       final response = await apiService.post('/auth/login', {
//         if (email != null) 'email': email,
//         if (phone != null) 'phone': phone,
//         'password': password,
//       });
//
//       final user = User.fromJson(response['user']);
//       final token = response['token'];
//
//       await localStorage.setToken(token);
//       await localStorage.setUser(user);
//
//       return Right(user);
//     } catch (e) {
//       print('ERROR: ${e.toString()}');
//       return Left(Failure(message: e.toString()));
//     }
//   }
//
//   Future<Either<Failure, User>> register({
//     String? email,
//     String? phone,
//     required String password,
//     required String firstName,
//     required String lastName,
//   }) async {
//     try {
//       final response = await apiService.post('/auth/register', {
//         if (email != null) 'email': email,
//         if (phone != null) 'phone': phone,
//         'password': password,
//         'first_name': firstName,
//         'last_name': lastName,
//       });
//
//       final user = User.fromJson(response['user']);
//       final token = response['token'];
//
//       await localStorage.setToken(token);
//       await localStorage.setUser(user);
//
//       return Right(user);
//     } catch (e) {
//       return Left(Failure(message: e.toString()));
//     }
//   }
//
//   Future<Either<Failure, void>> logout() async {
//     try {
//       await localStorage.clear();
//       return const Right(null);
//     } catch (e) {
//       return Left(Failure(message: e.toString()));
//     }
//   }
//
//   Future<Either<Failure, User?>> getCurrentUser() async {
//     try {
//       final user = await localStorage.getUser();
//       return Right(user);
//     } catch (e) {
//       return Left(Failure(message: e.toString()));
//     }
//   }
// }