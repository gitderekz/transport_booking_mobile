// lib/repositories/user_repository.dart

import '../models/user.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository({required this.apiService});

  Future<User> fetchProfile() async {
    final response = await apiService.get('/users/profile');
    return User.fromJson(response);
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    await apiService.put('/users/profile', {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    });
  }

  Future<void> updatePreferences({
    required String languagePref,
    required String themePref,
  }) async {
    await apiService.put('/users/preferences', {
      'languagePref': languagePref,
      'themePref': themePref,
    });
  }
}
