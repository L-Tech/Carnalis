import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/bloc/authentication_bloc.dart';
import '../../auth/view/auth_gate.dart';
import '../../auth/data/auth_repository.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _picker = ImagePicker();

  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  final List<Uint8List?> _photos = List<Uint8List?>.filled(9, null);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(int index, ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() => _photos[index] = bytes);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao selecionar foto: $e')),
      );
    }
  }

  void _showPickSheet(int index) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Galeria'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickPhoto(index, ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Câmera'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickPhoto(index, ImageSource.camera);
                  },
                ),
                if (_photos[index] != null)
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text('Remover foto'),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => _photos[index] = null);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;

    if (!authState.isAuthenticated) {
      return Scaffold(
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
            subtitle: 'Toque em um slot para adicionar',
          ),
          const SizedBox(height: 12),
          _PhotoGrid(
            photos: _photos,
            onTapSlot: _showPickSheet,
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Biografia', subtitle: 'Conte sobre você'),
          const SizedBox(height: 12),
          TextField(
            controller: _bioCtrl,
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
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
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
            onPressed: () {
              final filled = _photos.whereType<Uint8List>().length;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Salvar (placeholder): ${_nameCtrl.text.trim().isEmpty ? "Sem nome" : _nameCtrl.text.trim()} '
                    '• ${filled}/9 fotos selecionadas',
                  ),
                ),
              );
            },
            child: const Text('Salvar perfil'),
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

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({
    required this.photos,
    required this.onTapSlot,
  });

  final List<Uint8List?> photos;
  final void Function(int index) onTapSlot;

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
        final bytes = photos[index];
        return InkWell(
          onTap: () => onTapSlot(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.35),
              ),
            ),
            child: bytes == null
                ? const Center(child: Icon(Icons.add_a_photo_outlined))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(bytes, fit: BoxFit.cover),
                  ),
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

