import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/authentication_bloc.dart';
import '../../auth/view/auth_gate.dart';
import '../../auth/data/auth_repository.dart';

class ProfileCreationScreen extends StatelessWidget {
  const ProfileCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;

    if (!authState.isAuthenticated) {
      return const Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: AuthGate(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criação de perfil'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () => context.read<AuthRepository>().signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle(
            title: 'Fotos (até 9)',
            subtitle: 'Toque em um slot para adicionar (placeholder)',
          ),
          const SizedBox(height: 12),
          const _PhotoGridPlaceholder(),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Biografia', subtitle: 'Conte sobre você'),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Escreva sua bio…',
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: 'Integrações de interesses',
            subtitle: 'Compartilhe favoritos (placeholder)',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _ChipButton(label: 'Spotify', icon: Icons.music_note),
              _ChipButton(label: 'IMDb', icon: Icons.movie),
              _ChipButton(label: 'MyAnimeList', icon: Icons.tv),
              _ChipButton(label: 'Steam', icon: Icons.sports_esports),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle(
            title: 'Prompts (opcional)',
            subtitle: 'Perguntas/frases para completar',
          ),
          const SizedBox(height: 12),
          const _PromptRow(
            prompt: 'Um fato aleatório sobre mim…',
            hint: 'Digite aqui…',
          ),
          const SizedBox(height: 12),
          const _PromptRow(
            prompt: 'Eu me amarro quando…',
            hint: 'Digite aqui…',
          ),
          const SizedBox(height: 12),
          const _PromptRow(
            prompt: 'Meu date ideal seria…',
            hint: 'Digite aqui…',
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Informações básicas', subtitle: ''),
          const SizedBox(height: 12),
          TextField(decoration: const InputDecoration(labelText: 'Nome')),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Data de nascimento',
              hintText: 'dd/mm/aaaa',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
              final now = DateTime.now();
              await showDatePicker(
                context: context,
                firstDate: DateTime(now.year - 100),
                lastDate: DateTime(now.year - 18),
                initialDate: DateTime(now.year - 21),
              );
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Gênero'),
            items: const [
              DropdownMenuItem(value: 'homem', child: Text('Homem')),
              DropdownMenuItem(value: 'mulher', child: Text('Mulher')),
              DropdownMenuItem(value: 'nao_binario', child: Text('Não-binário')),
              DropdownMenuItem(value: 'outro', child: Text('Outro')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Orientação sexual'),
            items: const [
              DropdownMenuItem(value: 'hetero', child: Text('Hétero')),
              DropdownMenuItem(value: 'bi', child: Text('Bissexual')),
              DropdownMenuItem(value: 'homo', child: Text('Homossexual')),
              DropdownMenuItem(value: 'pan', child: Text('Pansexual')),
              DropdownMenuItem(value: 'assexual', child: Text('Assexual')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          const _DistanceSlider(),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {},
            child: const Text('Salvar perfil (placeholder)'),
          ),
          const SizedBox(height: 12),
          Text(
            'Tela em construção: próximos passos incluem persistência no Supabase e upload real das fotos.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {},
    );
  }
}

class _PhotoGridPlaceholder extends StatelessWidget {
  const _PhotoGridPlaceholder();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.35),
              ),
            ),
            child: const Center(child: Icon(Icons.add_a_photo_outlined)),
          ),
        );
      },
    );
  }
}

class _PromptRow extends StatelessWidget {
  const _PromptRow({required this.prompt, required this.hint});

  final String prompt;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.35),
              ),
            ),
            child: Text(prompt),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: TextField(decoration: InputDecoration(hintText: hint)),
        ),
      ],
    );
  }
}

class _DistanceSlider extends StatefulWidget {
  const _DistanceSlider();

  @override
  State<_DistanceSlider> createState() => _DistanceSliderState();
}

class _DistanceSliderState extends State<_DistanceSlider> {
  double _km = 25;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Distância máxima: ${_km.round()} km'),
        Slider(
          value: _km,
          min: 1,
          max: 200,
          divisions: 199,
          onChanged: (v) => setState(() => _km = v),
        ),
      ],
    );
  }
}

