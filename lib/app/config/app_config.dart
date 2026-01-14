class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  /// Configure em runtime usando:
  /// `--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      supabaseUrl: String.fromEnvironment('SUPABASE_URL', defaultValue: ''),
      supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: ''),
    );
  }

  final String supabaseUrl;
  final String supabaseAnonKey;

  bool get isSupabaseConfigured => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}

