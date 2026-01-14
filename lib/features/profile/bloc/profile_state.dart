part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, ready, saving, error }

class ProfileState extends Equatable {
  const ProfileState({
    required this.status,
    required this.profile,
    required this.errorMessage,
  });

  const ProfileState.initial()
      : status = ProfileStatus.initial,
        profile = null,
        errorMessage = null;

  final ProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}

