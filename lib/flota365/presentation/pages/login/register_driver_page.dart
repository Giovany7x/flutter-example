import 'package:flutter/material.dart';

/// Formulario de registro pensado para conductores.
///
/// Incluye los campos vistos en el mock: nombre, correo, teléfono y número de
/// licencia. Al completar el formulario se dispara [onRegister].
class RegisterDriverPage extends StatefulWidget {
  final VoidCallback onRegister;

  const RegisterDriverPage({super.key, required this.onRegister});

  @override
  State<RegisterDriverPage> createState() => _RegisterDriverPageState();
}

class _RegisterDriverPageState extends State<RegisterDriverPage> {
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onRegister();
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
              FilledButton(
                onPressed: _submit,
                child: const Text('Crear cuenta'),
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
