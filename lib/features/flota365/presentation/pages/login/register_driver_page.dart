import 'package:flutter/material.dart';

/// Formulario de registro pensado para conductores.
///
/// Incluye los campos vistos en el mock: nombre, correo, teléfono y número de
/// licencia. Al completar el formulario se dispara [onRegister].
class RegisterDriverPage extends StatefulWidget {
  final Future<void> Function() onRegister;

  const RegisterDriverPage({super.key, required this.onRegister});

  @override
  State<RegisterDriverPage> createState() => _RegisterDriverPageState();
}

class _RegisterDriverPageState extends State<RegisterDriverPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      await widget.onRegister();
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta - Conductor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Registra tus datos para comenzar a conducir',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const _LabeledField(label: 'Nombre completo'),
              const SizedBox(height: 12),
              const _LabeledField(label: 'Correo corporativo'),
              const SizedBox(height: 12),
              const _LabeledField(label: 'Número telefónico'),
              const SizedBox(height: 12),
              const _LabeledField(label: 'Número de licencia'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Campo de texto reutilizable para mantener estilos consistentes.
class _LabeledField extends StatelessWidget {
  final String label;

  const _LabeledField({required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
    );
  }
}
