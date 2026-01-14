import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client) {
    final initialUser = _client.auth.currentUser;
    _current = initialUser == null
        ? const AuthStateSnapshot(status: AuthStatus.unauthenticated)
        : AuthStateSnapshot(
            status: AuthStatus.authenticated,
            user: AuthUser(id: initialUser.id, email: initialUser.email, phone: initialUser.phone),
          );

    _sub = _client.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user ?? _client.auth.currentUser;
      if (user == null) {
        _current = const AuthStateSnapshot(status: AuthStatus.unauthenticated);
      } else {
        _current = AuthStateSnapshot(
          status: AuthStatus.authenticated,
          user: AuthUser(id: user.id, email: user.email, phone: user.phone),
        );
      }
      _controller.add(_current);
    });
  }

  final SupabaseClient _client;
  final _controller = StreamController<AuthStateSnapshot>.broadcast();
  late final StreamSubscription<AuthState> _sub;
  late AuthStateSnapshot _current;

  @override
  Stream<AuthStateSnapshot> get authState async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  AuthStateSnapshot get current => _current;

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await _client.auth.signUp(email: email, password: password);
  }

  @override
  Future<void> signInWithOAuth(String provider) async {
    final p = provider.toLowerCase();
    final oauthProvider = switch (p) {
      'google' => OAuthProvider.google,
      'apple' => OAuthProvider.apple,
      'facebook' => OAuthProvider.facebook,
      _ => throw UnsupportedError('OAuth provider not supported: $provider'),
    };

    await _client.auth.signInWithOAuth(oauthProvider);
  }

  @override
  Future<void> signInWithPhoneOtp(String phone) async {
    await _client.auth.signInWithOtp(phone: phone);
  }
}

