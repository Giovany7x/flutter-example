import 'package:easy_travel/flota365/presentation/routes.dart';
import 'package:flutter/material.dart';

/// Pantalla intermedia que pregunta al usuario "¿Quién eres?".
///
/// Muestra dos tarjetas para que el conductor o el gestor seleccione su flujo.
class LoginSelectionPage extends StatelessWidget {
  /// Callback genérico para navegar a la ruta seleccionada.
  final ValueChanged<String> onNavigate;

  const LoginSelectionPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Quién eres?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _SelectionCard(
              title: 'Conductor de vehículo',
              subtitle: 'Registra tus rutas, evidencias y turnos.',
              icon: Icons.directions_bus,
              onTap: () => onNavigate(Flota365Routes.loginDriver),
            ),
            const SizedBox(height: 16),
            _SelectionCard(
              title: 'Gestor de flota',
              subtitle: 'Administra conductores y valida evidencias.',
              icon: Icons.supervisor_account_outlined,
              onTap: () => onNavigate(Flota365Routes.loginManager),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta reutilizable que representa cada opción de acceso.
class _SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          children: [
            Icon(icon, size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(subtitle),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
