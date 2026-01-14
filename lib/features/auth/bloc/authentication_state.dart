part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    required this.status,
    this.user,
  });

  const AuthenticationState.unknown() : this._(status: AuthStatus.unknown);

  const AuthenticationState.unauthenticated() : this._(status: AuthStatus.unauthenticated);

  const AuthenticationState.authenticated(AuthUser user)
      : this._(status: AuthStatus.authenticated, user: user);

  final AuthStatus status;
  final AuthUser? user;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  @override
  List<Object?> get props => [status, user];
}

