import 'package:flutter/material.dart';

/// Pantalla de bienvenida que introduce el flujo de conductores.
class WelcomePage extends StatelessWidget {
  final VoidCallback onContinue;

  const WelcomePage({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0E86FE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: onContinue,
                  icon: const Icon(Icons.bolt_rounded),
                  label: const Text('Ir al demo'),
                ),
              ),
              const Spacer(),
              Text(
                'Flota365 Conductores',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Centraliza tu operación diaria, completa checklists y comparte evidencias en minutos.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onContinue,
                icon: const Icon(Icons.login_rounded),
                label: const Text('Comenzar recorrido'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0E86FE),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _TagChip(text: 'Checklists inteligentes'),
                  _TagChip(text: 'Control de rutas'),
                  _TagChip(text: 'Evidencias en tiempo real'),
                ],
              ),
              const Spacer(),
              Text(
                'Demo optimizada para móviles - Inspirado en el mock-up proporcionado.',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;

  const _TagChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
