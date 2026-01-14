import 'dart:math';

import 'package:flutter/material.dart';

import '../../../shared/models/mock_profile.dart';
import 'profile_detail_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final List<MockProfile> _queue = List.of(MockProfiles.seed);

  void _nope() {
    if (_queue.isEmpty) return;
    setState(() => _queue.removeAt(0));
  }

  void _like() {
    if (_queue.isEmpty) return;
    setState(() => _queue.removeAt(0));
  }

  void _superLike() {
    if (_queue.isEmpty) return;
    setState(() => _queue.removeAt(0));
  }

  void _directMessage() {
    if (_queue.isEmpty) return;
    final p = _queue.first;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('DM para ${p.name} (placeholder)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = _queue.isNotEmpty ? _queue.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Descoberta'),
        actions: [
          IconButton(
            tooltip: 'Recarregar mock',
            onPressed: () => setState(() {
              _queue
                ..clear()
                ..addAll(MockProfiles.seed);
            }),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: top == null
                      ? const _EmptyState()
                      : _SwipeCard(
                          key: ValueKey(top.id),
                          profile: top,
                          onNope: _nope,
                          onLike: _like,
                          onSuperLike: _superLike,
                          onOpenProfile: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    ProfileDetailScreen(profile: top),
                                transitionsBuilder: (context, anim, sec, child) {
                                  final tween = Tween(
                                    begin: const Offset(0.0, 0.06),
                                    end: Offset.zero,
                                  ).chain(CurveTween(curve: Curves.easeOut));
                                  return FadeTransition(
                                    opacity: anim,
                                    child: SlideTransition(position: anim.drive(tween), child: child),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 12),
              _ActionRow(
                enabled: top != null,
                onNope: _nope,
                onLike: _like,
                onSuperLike: _superLike,
                onDirectMessage: _directMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('empty'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.35)),
      ),
      child: Center(
        child: Text(
          'Sem perfis no momento.\nToque em recarregar para ver o mock novamente.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _SwipeCard extends StatelessWidget {
  const _SwipeCard({
    super.key,
    required this.profile,
    required this.onNope,
    required this.onLike,
    required this.onSuperLike,
    required this.onOpenProfile,
  });

  final MockProfile profile;
  final VoidCallback onNope;
  final VoidCallback onLike;
  final VoidCallback onSuperLike;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final image = profile.photoUrls.isNotEmpty ? profile.photoUrls.first : null;

    return Dismissible(
      key: ValueKey('dismiss-${profile.id}'),
      direction: DismissDirection.horizontal,
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          onLike();
          return true;
        }
        if (dir == DismissDirection.endToStart) {
          onNope();
          return true;
        }
        return false;
      },
      child: GestureDetector(
        onTap: onOpenProfile,
        child: Container(
          key: const ValueKey('card'),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.35),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image != null)
                Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _ImageFallback(),
                )
              else
                const _ImageFallback(),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.10),
                      Colors.black.withOpacity(0.70),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: _CardBottomInfo(profile: profile),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: _PhotoPreviewDots(count: min(3, profile.photoUrls.length)),
              ),
            ],
          ),
        ),
      ),
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

class _CardBottomInfo extends StatelessWidget {
  const _CardBottomInfo({required this.profile});

  final MockProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${profile.name}, ${profile.age}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text('${profile.distanceKm} km'),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          profile.headline,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: profile.tags.take(5).map((t) => _TagPill(text: t)).toList(),
        ),
      ],
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _PhotoPreviewDots extends StatelessWidget {
  const _PhotoPreviewDots({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();
    return Row(
      children: List.generate(
        count,
        (i) => Container(
          width: 22,
          height: 4,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(i == 0 ? 0.95 : 0.40),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.enabled,
    required this.onNope,
    required this.onLike,
    required this.onSuperLike,
    required this.onDirectMessage,
  });

  final bool enabled;
  final VoidCallback onNope;
  final VoidCallback onLike;
  final VoidCallback onSuperLike;
  final VoidCallback onDirectMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircleAction(
          enabled: enabled,
          icon: Icons.close,
          label: 'Nope',
          onPressed: onNope,
        ),
        _CircleAction(
          enabled: enabled,
          icon: Icons.star,
          label: 'Super',
          onPressed: onSuperLike,
        ),
        _CircleAction(
          enabled: enabled,
          icon: Icons.favorite,
          label: 'Like',
          onPressed: onLike,
        ),
        _CircleAction(
          enabled: enabled,
          icon: Icons.message,
          label: 'DM',
          onPressed: onDirectMessage,
        ),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.enabled,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final bool enabled;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          onPressed: enabled ? onPressed : null,
          icon: Icon(icon, color: color),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

