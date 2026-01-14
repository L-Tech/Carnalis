import 'package:flutter/material.dart';

class DiscoverySettingsScreen extends StatefulWidget {
  const DiscoverySettingsScreen({super.key});

  @override
  State<DiscoverySettingsScreen> createState() => _DiscoverySettingsScreenState();
}

class _DiscoverySettingsScreenState extends State<DiscoverySettingsScreen> {
  RangeValues _age = const RangeValues(21, 40);
  double _distance = 25;
  bool _showMe = true;
  final Set<String> _genders = {'Mulheres', 'Homens'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações de busca')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Preferências', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Idade: ${_age.start.round()}–${_age.end.round()}'),
                RangeSlider(
                  values: _age,
                  min: 18,
                  max: 70,
                  divisions: 52,
                  onChanged: (v) => setState(() => _age = v),
                ),
                const SizedBox(height: 12),
                Text('Distância máxima: ${_distance.round()} km'),
                Slider(
                  value: _distance,
                  min: 1,
                  max: 200,
                  divisions: 199,
                  onChanged: (v) => setState(() => _distance = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Sexualidade / Interesses', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _Card(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _SelectChip(
                  label: 'Mulheres',
                  selected: _genders.contains('Mulheres'),
                  onSelected: (s) => setState(() {
                    s ? _genders.add('Mulheres') : _genders.remove('Mulheres');
                  }),
                ),
                _SelectChip(
                  label: 'Homens',
                  selected: _genders.contains('Homens'),
                  onSelected: (s) => setState(() {
                    s ? _genders.add('Homens') : _genders.remove('Homens');
                  }),
                ),
                _SelectChip(
                  label: 'Não-binário',
                  selected: _genders.contains('Não-binário'),
                  onSelected: (s) => setState(() {
                    s ? _genders.add('Não-binário') : _genders.remove('Não-binário');
                  }),
                ),
                _SelectChip(
                  label: 'Todos',
                  selected: _genders.contains('Todos'),
                  onSelected: (s) => setState(() {
                    if (s) {
                      _genders
                        ..clear()
                        ..add('Todos');
                    } else {
                      _genders.remove('Todos');
                    }
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Status na plataforma', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _Card(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _showMe,
              onChanged: (v) => setState(() => _showMe = v),
              title: const Text('Mostrar-me no Carnalis'),
              subtitle: const Text('Ative/desative seu perfil na busca'),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configurações salvas (placeholder)')),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.35)),
      ),
      child: child,
    );
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      checkmarkColor: Theme.of(context).colorScheme.primary,
      selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.25),
      side: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.35)),
    );
  }
}

