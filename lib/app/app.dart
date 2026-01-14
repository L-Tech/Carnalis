import 'package:flutter/material.dart';

class CarnalisApp extends StatelessWidget {
  const CarnalisApp({super.key});

  static const Color _primary = Color(0xFFFF0000);
  static const Color _secondary = Color(0xFF722F37);
  static const Color _background = Color(0xFF000000);
  static const Color _text = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final colorScheme = const ColorScheme.dark().copyWith(
      primary: _primary,
      secondary: _secondary,
      surface: const Color(0xFF0E0E0E),
      onPrimary: _text,
      onSecondary: _text,
      onSurface: _text,
    );

    return MaterialApp(
      title: 'Carnalis',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: _background,
        appBarTheme: const AppBarTheme(
          backgroundColor: _background,
          foregroundColor: _text,
          centerTitle: true,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: _text,
              displayColor: _text,
            ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF111111),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _secondary.withValues(alpha: 0.35)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _secondary.withValues(alpha: 0.35)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primary, width: 2),
          ),
        ),
      ),
      home: const _PlaceholderHome(),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Carnalis — base inicial (UI/BLoC em construção)'),
        ),
      ),
    );
  }
}

