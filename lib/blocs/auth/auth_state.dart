part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final bool verificationRequired;
  final String? userId;

  const AuthError({
    required this.message,
    this.verificationRequired = false,
    this.userId,
  });

  @override
  List<Object> get props => [message, verificationRequired, userId ?? ''];
}