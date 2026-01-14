import 'dart:typed_data';

import 'profile_repository.dart';
import 'user_profile.dart';

class InMemoryProfileRepository implements ProfileRepository {
  final Map<String, UserProfile> _store = {};

  @override
  Future<UserProfile?> getMyProfile({required String userId}) async {
    return _store[userId];
  }

  @override
  Future<UserProfile> upsertMyProfile({
    required String userId,
    required String name,
    required String bio,
    required List<Uint8List> photos,
  }) async {
    // No modo mock, não há upload: geramos URLs fictícias.
    final photoUrls = List.generate(
      photos.length,
      (i) => 'mock://photo/$userId/$i',
    );
    final profile = UserProfile(
      userId: userId,
      name: name,
      bio: bio,
      photoUrls: photoUrls,
    );
    _store[userId] = profile;
    return profile;
  }
}

