import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.userId,
    required this.name,
    required this.bio,
    required this.photoUrls,
  });

  final String userId;
  final String name;
  final String bio;
  final List<String> photoUrls;

  @override
  List<Object?> get props => [userId, name, bio, photoUrls];
}

