import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/data/auth_repository.dart';
import '../data/profile_repository.dart';
import '../data/user_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ProfileRepository profileRepository,
    required AuthRepository authRepository,
  })  : _profileRepository = profileRepository,
        _authRepository = authRepository,
        super(const ProfileState.initial());

  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;

  String? get _userId => _authRepository.current.user?.id;

  Future<void> load() async {
    final userId = _userId;
    if (userId == null) return;

    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final p = await _profileRepository.getMyProfile(userId: userId);
      emit(state.copyWith(status: ProfileStatus.ready, profile: p));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()));
    }
  }

  Future<UserProfile?> save({
    required String name,
    required String bio,
    required List<Uint8List> photos,
  }) async {
    final userId = _userId;
    if (userId == null) return null;

    emit(state.copyWith(status: ProfileStatus.saving, errorMessage: null));
    try {
      final p = await _profileRepository.upsertMyProfile(
        userId: userId,
        name: name,
        bio: bio,
        photos: photos,
      );
      emit(state.copyWith(status: ProfileStatus.ready, profile: p));
      return p;
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()));
      return null;
    }
  }
}

