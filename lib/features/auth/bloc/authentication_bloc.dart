import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onStatusChanged);

    _sub = _authRepository.authState.listen((snapshot) {
      add(AuthenticationStatusChanged(snapshot));
    });
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<AuthStateSnapshot> _sub;

  Future<void> _onStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    final s = event.snapshot;
    switch (s.status) {
      case AuthStatus.unknown:
        emit(const AuthenticationState.unknown());
      case AuthStatus.unauthenticated:
        emit(const AuthenticationState.unauthenticated());
      case AuthStatus.authenticated:
        emit(AuthenticationState.authenticated(s.user!));
    }
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}

