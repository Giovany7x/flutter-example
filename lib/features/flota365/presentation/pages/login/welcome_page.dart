import 'package:flutter/material.dart';

/// Pantalla de bienvenida que simula el "Homepage" del flujo de login.
///
/// Contiene un encabezado, una descripción breve y un botón principal que
/// permite continuar con el proceso de registro o inicio de sesión.
class WelcomePage extends StatelessWidget {
  /// Callback que se invoca cuando el usuario presiona el botón principal.
  final VoidCallback onStart;

  const WelcomePage({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Flota365',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'El equipo más ágil de la región',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Imagen de demostración: se usa un ícono para evitar dependencias.
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 140,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Gestiona tus rutas, evidencias y viajes desde un mismo lugar.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onStart,
                  child: const Text('Comenzar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
