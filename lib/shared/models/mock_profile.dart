import '../data/tags.dart';

class MockProfile {
  const MockProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.distanceKm,
    required this.headline,
    required this.bio,
    required this.tags,
    required this.photoUrls,
  });

  final String id;
  final String name;
  final int age;
  final int distanceKm;
  final String headline;
  final String bio;
  final List<String> tags;
  final List<String> photoUrls;
}

class MockProfiles {
  static const seed = <MockProfile>[
    MockProfile(
      id: 'p1',
      name: 'Alex',
      age: 27,
      distanceKm: 3,
      headline: 'Conexões sem julgamentos. Conversa direta.',
      bio:
          'Curto combinar expectativas com clareza. Prefiro respeito, consentimento e boa comunicação.',
      tags: ['Bondage', 'Dominance', 'Leather', 'goth', 'Impact Play'],
      photoUrls: [
        'https://picsum.photos/seed/carnalis-1/900/1200',
        'https://picsum.photos/seed/carnalis-2/900/1200',
        'https://picsum.photos/seed/carnalis-3/900/1200',
      ],
    ),
    MockProfile(
      id: 'p2',
      name: 'Bruna',
      age: 31,
      distanceKm: 8,
      headline: 'Explorando com leveza e limites bem definidos.',
      bio:
          'Gosto de conhecer pessoas interessantes e alinhar intenções antes de qualquer coisa. Transparência é essencial.',
      tags: ['Submission', 'Shibari/Kinbaku', 'Latex/Rubber', 'lolita'],
      photoUrls: [
        'https://picsum.photos/seed/carnalis-4/900/1200',
        'https://picsum.photos/seed/carnalis-5/900/1200',
        'https://picsum.photos/seed/carnalis-6/900/1200',
      ],
    ),
    MockProfile(
      id: 'p3',
      name: 'Cris & Dani',
      age: 29,
      distanceKm: 12,
      headline: 'Casal: sintonia, respeito e boa conversa.',
      bio:
          'Somos um casal que valoriza discrição, consentimento e planejamento. Preferimos conhecer devagar e com calma.',
      tags: ['Worship', 'Uniform Fetish', 'country', 'Sensation Play'],
      photoUrls: [
        'https://picsum.photos/seed/carnalis-7/900/1200',
        'https://picsum.photos/seed/carnalis-8/900/1200',
        'https://picsum.photos/seed/carnalis-9/900/1200',
      ],
    ),
    MockProfile(
      id: 'p4',
      name: 'Duda',
      age: 24,
      distanceKm: 1,
      headline: 'Sem tabus, com responsabilidade.',
      bio:
          'Curto trocar ideia, conhecer, e ver se bate. Limites claros e respeito sempre.',
      tags: ['Foot Fetish', 'Mistress', 'rocker', 'Medical Play'],
      photoUrls: [
        'https://picsum.photos/seed/carnalis-10/900/1200',
        'https://picsum.photos/seed/carnalis-11/900/1200',
      ],
    ),
  ];

  static List<String> randomTags(int count) {
    final all = CarnalisTags.all;
    if (count <= 0) return const [];
    if (count >= all.length) return List.of(all);
    return all.take(count).toList();
  }
}

