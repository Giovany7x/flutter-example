import 'package:easy_travel/features/flota365/presentation/bloc/driver_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Formulario simple que representa el inicio de sesión para conductores.
///
/// Al presionar el botón "Ingresar" se ejecuta [onLoginSuccess], lo que permite
/// navegar al panel principal.
class DriverLoginPage extends StatefulWidget {
  final Future<void> Function() onLoginSuccess;

  const DriverLoginPage({super.key, required this.onLoginSuccess});

  @override
  State<DriverLoginPage> createState() => _DriverLoginPageState();
}

class _DriverLoginPageState extends State<DriverLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Liberamos los controladores cuando la pantalla se destruye.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí iría tu llamada real al backend.
      await widget.onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<DriverSessionCubit>().state.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de sesión conductor')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bienvenido a Flota365',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo corporativo',
                ),
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
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Ingresar'),
              ),
              TextButton(
                onPressed: () {
                  // En una implementación completa se abriría la pantalla de registro.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad de recuperar acceso.')),
                  );
                },
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
