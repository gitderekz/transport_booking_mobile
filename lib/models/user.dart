import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String uuid;
  final String? email;
  final String? phone;
  final String firstName;
  final String lastName;
  final bool isVerified;
  final String languagePref;
  final String themePref;
  final String? profilePicture;

  const User({
    required this.id,
    required this.uuid,
    this.email,
    this.phone,
    required this.firstName,
    required this.lastName,
    required this.isVerified,
    required this.languagePref,
    required this.themePref,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      uuid: json['uuid'],
      email: json['email'],
      phone: json['phone'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      isVerified: json['is_verified'] ?? false,
      languagePref: json['language_pref'] ?? 'en',
      themePref: json['theme_pref'] ?? 'system',
      profilePicture: json['profile_picture'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    uuid,
    email,
    phone,
    firstName,
    lastName,
    isVerified,
    languagePref,
    themePref,
    profilePicture,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'email': email,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'is_verified': isVerified,
      'language_pref': languagePref,
      'theme_pref': themePref,
      'profile_picture': profilePicture,
    };
  }
}