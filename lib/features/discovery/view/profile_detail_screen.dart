import 'package:flutter/material.dart';

import '../../../shared/models/mock_profile.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key, required this.profile});

  final MockProfile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(profile.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: PageView(
                children: profile.photoUrls.isEmpty
                    ? const [_ImageFallback()]
                    : profile.photoUrls
                        .map(
                          (url) => Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const _ImageFallback(),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${profile.name}, ${profile.age} • ${profile.distanceKm} km',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(profile.headline, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Text('Bio', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(profile.bio),
          const SizedBox(height: 16),
          Text('Tags', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.tags.map((t) => _TagChip(text: t)).toList(),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Denúncia (placeholder)')),
              );
            },
            icon: const Icon(Icons.flag_outlined),
            label: const Text('Denunciar'),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      side: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.35)),
      backgroundColor: const Color(0xFF111111),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF222222),
      child: Center(child: Icon(Icons.image_not_supported_outlined)),
    );
  }
}

