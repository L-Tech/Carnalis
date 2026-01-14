import 'dart:async';

import 'package:equatable/equatable.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthAppUser extends Equatable {
  const AuthAppUser({
    required this.id,
    this.email,
    this.phone,
  });

  final String id;
  final String? email;
  final String? phone;

  @override
  List<Object?> get props => [id, email, phone];
}

class AuthStateSnapshot extends Equatable {
  const AuthStateSnapshot({
    required this.status,
    this.user,
  });

  final AuthStatus status;
  final AuthAppUser? user;

  @override
  List<Object?> get props => [status, user];
}

abstract class AuthRepository {
  Stream<AuthStateSnapshot> get authState;

  AuthStateSnapshot get current;

  Future<void> signOut();

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> signInWithOAuth(String provider);

  Future<void> signInWithPhoneOtp(String phone);
}

