import 'package:flutter/material.dart';

/// Formulario para gestores o supervisores.
///
/// A diferencia del flujo de conductor, este formulario incluye un botón para
/// crear una cuenta nueva de gestor.
class ManagerLoginPage extends StatelessWidget {
  final VoidCallback onBackToSelection;

  const ManagerLoginPage({super.key, required this.onBackToSelection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de sesión gestor')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Accede como gestor',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Integrar con backend de gestores.')),
                );
              },
              child: const Text('Ingresar'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onBackToSelection,
              child: const Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
