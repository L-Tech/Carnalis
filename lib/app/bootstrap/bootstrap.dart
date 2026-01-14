import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import 'app_bootstrap.dart';
import '../../features/auth/data/in_memory_auth_repository.dart';
import '../../features/auth/data/supabase_auth_repository.dart';

Future<AppBootstrap> bootstrap() async {
  final config = AppConfig.fromEnvironment();

  if (config.isSupabaseConfigured) {
    await Supabase.initialize(
      url: config.supabaseUrl,
      anonKey: config.supabaseAnonKey,
    );
    return AppBootstrap(
      config: config,
      authRepository: SupabaseAuthRepository(Supabase.instance.client),
    );
  }

  return AppBootstrap(
    config: config,
    authRepository: InMemoryAuthRepository(),
  );
}

