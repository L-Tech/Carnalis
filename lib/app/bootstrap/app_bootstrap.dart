import '../config/app_config.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/profile/data/profile_repository.dart';

class AppBootstrap {
  const AppBootstrap({
    required this.config,
    required this.authRepository,
    required this.profileRepository,
  });

  final AppConfig config;
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
}

