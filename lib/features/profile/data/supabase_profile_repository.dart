import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_repository.dart';
import 'user_profile.dart';

class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository(
    this._client, {
    this.photoBucket = 'profile-photos',
  });

  final SupabaseClient _client;
  final String photoBucket;

  @override
  Future<UserProfile?> getMyProfile({required String userId}) async {
    final row = await _client
        .from('profiles')
        .select('id, name, bio, photo_urls')
        .eq('id', userId)
        .maybeSingle();

    if (row == null) return null;

    final urls = (row['photo_urls'] as List?)?.cast<String>() ?? const <String>[];
    return UserProfile(
      userId: row['id'] as String,
      name: (row['name'] as String?) ?? '',
      bio: (row['bio'] as String?) ?? '',
      photoUrls: urls,
    );
  }

  @override
  Future<UserProfile> upsertMyProfile({
    required String userId,
    required String name,
    required String bio,
    required List<Uint8List> photos,
  }) async {
    final photoUrls = <String>[];

    // Upload em paralelo seria possível, mas sequencial evita stress no client mobile.
    for (var i = 0; i < photos.length; i++) {
      final bytes = photos[i];
      final path = 'users/$userId/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

      await _client.storage.from(photoBucket).uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final publicUrl = _client.storage.from(photoBucket).getPublicUrl(path);
      photoUrls.add(publicUrl);
    }

    final payload = <String, dynamic>{
      'id': userId,
      'name': name,
      'bio': bio,
      'photo_urls': photoUrls,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _client.from('profiles').upsert(payload);

    return UserProfile(
      userId: userId,
      name: name,
      bio: bio,
      photoUrls: photoUrls,
    );
  }
}

