// lib/blocs/auth/auth_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/user.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthAutoLogin>(_onAutoLogin);
  }

  FutureOr<void> _onLoginRequested(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.login(
        email: event.email,
        phone: event.phone,
        password: event.password,
      );

      result.fold(
            (failure) => emit(AuthError(message: failure.message)),
            (user) => emit(AuthAuthenticated(user: user)),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  FutureOr<void> _onRegisterRequested(
      AuthRegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.register(
        email: event.email,
        phone: event.phone,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
      );

      result.fold(
            (failure) => emit(AuthError(message: failure.message)),
            (user) => emit(AuthAuthenticated(user: user)),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  FutureOr<void> _onLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.logout();
      result.fold(
            (failure) => emit(AuthError(message: failure.message)),
            (_) => emit(AuthUnauthenticated()),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  FutureOr<void> _onCheckStatus(
      AuthCheckStatus event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.getCurrentUser();
      result.fold(
            (failure) => emit(AuthError(message: failure.message)),
            (user) => user != null
            ? emit(AuthAuthenticated(user: user))
            : emit(AuthUnauthenticated()),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  FutureOr<void> _onAutoLogin(
      AuthAutoLogin event,
      Emitter<AuthState> emit,
      ) async {
    await _onCheckStatus(AuthCheckStatus(), emit);
  }
}



// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
//
// import '../../models/user.dart';
// import '../../repositories/auth_repository.dart';
//
// part 'auth_event.dart';
// part 'auth_state.dart';
//
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository authRepository;
//
//   AuthBloc({required this.authRepository}) : super(AuthInitial()) {
//     on<AuthInitial>(_onInitial);
//     on<AuthAutoLogin>(_onAutoLogin);
//     on<AuthLoginRequested>(_onLoginRequested);
//     on<AuthRegisterRequested>(_onRegisterRequested);
//     on<AuthLogoutRequested>(_onLogoutRequested);
//     on<AuthCheckStatus>(_onCheckStatus);
//   }
//
//   FutureOr<void> _onInitial(AuthInitial event, Emitter<AuthState> emit) {
//     emit(AuthUnauthenticated());
//   }
//
//   FutureOr<void> _onAutoLogin(AuthAutoLogin event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());
//     try {
//       final user = await authRepository.getCurrentUser();
//       if (user != null) {
//         emit(AuthAuthenticated(user: user));
//       } else {
//         emit(AuthUnauthenticated());
//       }
//     } catch (e) {
//       emit(AuthError(message: e.toString()));
//     }
//   }
//
//   FutureOr<void> _onLoginRequested(
//       AuthLoginRequested event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//     try {
//       final user = await authRepository.login(
//         email: event.email,
//         phone: event.phone,
//         password: event.password,
//       );
//       // emit(AuthAuthenticated(user: user));
//       user.fold(
//             (failure) {
//           emit(AuthError(message: failure.message));
//           emit(AuthUnauthenticated());
//         },
//             (user) => emit(AuthAuthenticated(user: user)),
//       );
//     } catch (e) {
//       emit(AuthError(message: e.toString()));
//       emit(AuthUnauthenticated());
//     }
//   }
//
//   FutureOr<void> _onRegisterRequested(
//       AuthRegisterRequested event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//     try {
//       final user = await authRepository.register(
//         email: event.email,
//         phone: event.phone,
//         password: event.password,
//         firstName: event.firstName,
//         lastName: event.lastName,
//       );
//       // emit(AuthAuthenticated(user: user));
//       user.fold(
//             (failure) {
//           emit(AuthError(message: failure.message));
//           emit(AuthUnauthenticated());
//         },
//             (user) => emit(AuthAuthenticated(user: user)),
//       );
//     } catch (e) {
//       emit(AuthError(message: e.toString()));
//       emit(AuthUnauthenticated());
//     }
//   }
//
//   FutureOr<void> _onLogoutRequested(
//       AuthLogoutRequested event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//     try {
//       await authRepository.logout();
//       emit(AuthUnauthenticated());
//     } catch (e) {
//       emit(AuthError(message: e.toString()));
//       emit(AuthUnauthenticated());
//     }
//   }
//
//   FutureOr<void> _onCheckStatus(
//       AuthCheckStatus event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//     try {
//       final result = await authRepository.getCurrentUser();
//       // if (user != null) {
//       //   emit(AuthAuthenticated(user: user));
//       // } else {
//       //   emit(AuthUnauthenticated());
//       // }
//       result.fold(
//             (failure) {
//           emit(AuthError(message: failure.message));
//           emit(AuthUnauthenticated());
//         },
//             (user) {
//           if (user != null) {
//             emit(AuthAuthenticated(user: user));
//           } else {
//             emit(AuthUnauthenticated());
//           }
//         },
//       );
//     } catch (e) {
//       emit(AuthError(message: e.toString()));
//       emit(AuthUnauthenticated());
//     }
//   }
// }