# Carnalis

Base do app **Carnalis** (Flutter) com tema dark, navegação por abas, telas principais e autenticação (mock ou Supabase).

## Getting Started

### Rodar em modo mock (sem Supabase)

- Basta executar normalmente (`flutter run`).
- O login sempre funciona (repositório in-memory).

### Rodar com Supabase

Passe as variáveis via `--dart-define`:

```bash
flutter run \
  --dart-define=SUPABASE_URL="https://SUA-URL.supabase.co" \
  --dart-define=SUPABASE_ANON_KEY="SUA_ANON_KEY"
```

### Notas

- **Auth**: e-mail/senha, telefone (OTP) e OAuth (Google/Apple/Facebook) via Supabase.
- **Fotos (até 9)**: seleção via `image_picker` (upload para Storage será conectado em seguida).

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
