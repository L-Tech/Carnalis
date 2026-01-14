import '../config/app_config.dart';
import '../../features/auth/data/auth_repository.dart';

class AppBootstrap {
  const AppBootstrap({
    required this.config,
    required this.authRepository,
  });

  final AppConfig config;
  final AuthRepository authRepository;
}

