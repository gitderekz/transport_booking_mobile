part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String? email;
  final String? phone;
  final String password;

  const AuthLoginRequested({
    this.email,
    this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [password, email ?? '', phone ?? ''];
}

class AuthRegisterRequested extends AuthEvent {
  final String? email;
  final String? phone;
  final String password;
  final String firstName;
  final String lastName;

  const AuthRegisterRequested({
    this.email,
    this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [
    password,
    firstName,
    lastName,
    email ?? '',
    phone ?? '',
  ];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}