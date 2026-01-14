import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _busy = false;
  String? _error;

  Future<void> _run(Future<void> Function(AuthRepository repo) fn) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = context.read<AuthRepository>();
      await fn(repo);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Entrar', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Use e-mail/senha, telefone (OTP) ou SSO.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        if (_error != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.35)),
            ),
            child: Text(_error!),
          ),
          const SizedBox(height: 12),
        ],
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'E-mail'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passCtrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Senha'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: _busy
                    ? null
                    : () => _run(
                          (repo) => repo.signInWithEmailPassword(
                            email: _emailCtrl.text.trim(),
                            password: _passCtrl.text,
                          ),
                        ),
                child: _busy ? const _SmallSpinner() : const Text('Entrar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: _busy
                    ? null
                    : () => _run(
                          (repo) => repo.signUpWithEmailPassword(
                            email: _emailCtrl.text.trim(),
                            password: _passCtrl.text,
                          ),
                        ),
                child: const Text('Criar conta'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Telefone',
            hintText: '+55...',
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _busy
              ? null
              : () => _run((repo) => repo.signInWithPhoneOtp(_phoneCtrl.text.trim())),
          icon: const Icon(Icons.sms_outlined),
          label: const Text('Enviar OTP'),
        ),
        const SizedBox(height: 20),
        Text('SSO', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: _busy ? null : () => _run((repo) => repo.signInWithOAuth('google')),
              icon: const Icon(Icons.g_mobiledata),
              label: const Text('Google'),
            ),
            OutlinedButton.icon(
              onPressed: _busy ? null : () => _run((repo) => repo.signInWithOAuth('apple')),
              icon: const Icon(Icons.apple),
              label: const Text('Apple'),
            ),
            OutlinedButton.icon(
              onPressed: _busy ? null : () => _run((repo) => repo.signInWithOAuth('facebook')),
              icon: const Icon(Icons.facebook),
              label: const Text('Facebook'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Dica: se você não passar `SUPABASE_URL`/`SUPABASE_ANON_KEY`, o app entra em modo mock (login sempre funciona).',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SmallSpinner extends StatelessWidget {
  const _SmallSpinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

