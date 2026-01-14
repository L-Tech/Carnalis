import 'dart:async';

import 'auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository() {
    _controller.add(_current);
  }

  final _controller = StreamController<AuthStateSnapshot>.broadcast();
  AuthStateSnapshot _current = const AuthStateSnapshot(status: AuthStatus.unauthenticated);

  @override
  Stream<AuthStateSnapshot> get authState => _controller.stream;

  @override
  AuthStateSnapshot get current => _current;

  void _emit(AuthStateSnapshot next) {
    _current = next;
    _controller.add(next);
  }

  @override
  Future<void> signOut() async {
    _emit(const AuthStateSnapshot(status: AuthStatus.unauthenticated));
  }

  @override
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _emit(
      AuthStateSnapshot(
        status: AuthStatus.authenticated,
        user: AuthAppUser(id: 'mock-user', email: email),
      ),
    );
  }

  @override
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await signInWithEmailPassword(email: email, password: password);
  }

  @override
  Future<void> signInWithOAuth(String provider) async {
    _emit(
      AuthStateSnapshot(
        status: AuthStatus.authenticated,
        user: AuthAppUser(id: 'mock-oauth-$provider'),
      ),
    );
  }

  @override
  Future<void> signInWithPhoneOtp(String phone) async {
    _emit(
      AuthStateSnapshot(
        status: AuthStatus.authenticated,
        user: AuthAppUser(id: 'mock-phone', phone: phone),
      ),
    );
  }
}

