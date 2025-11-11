import 'package:flutter/material.dart';

/// Formulario para gestores o supervisores.
///
/// Incluye validación básica y un callback [onLoginSuccess] que permite navegar
/// hacia el panel de administración del módulo.
class ManagerLoginPage extends StatefulWidget {
  final VoidCallback onBackToSelection;
  final Future<void> Function() onLoginSuccess;

  const ManagerLoginPage({
    super.key,
    required this.onBackToSelection,
    required this.onLoginSuccess,
  });

  @override
  State<ManagerLoginPage> createState() => _ManagerLoginPageState();
}

class _ManagerLoginPageState extends State<ManagerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    await widget.onLoginSuccess();
    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de sesión gestor')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Accede como gestor',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo corporativo'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa tu correo' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa tu contraseña' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Ingresar'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: widget.onBackToSelection,
                child: const Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
