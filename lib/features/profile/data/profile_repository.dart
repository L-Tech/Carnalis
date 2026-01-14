import 'dart:typed_data';

import 'user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getMyProfile({required String userId});

  /// Salva dados básicos e fotos.
  ///
  /// - `photos` são bytes (JPEG/PNG) selecionados no device.
  /// - Retorna o perfil já com `photoUrls` persistidas.
  Future<UserProfile> upsertMyProfile({
    required String userId,
    required String name,
    required String bio,
    required List<Uint8List> photos,
  });
}

