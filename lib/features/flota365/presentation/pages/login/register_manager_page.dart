import 'package:flutter/material.dart';

/// Formulario de creación de cuenta para gestores de flota.
///
/// Se diferencia del formulario del conductor porque incluye campos
/// adicionales como el nombre de la empresa y el rol dentro de la operación.
class RegisterManagerPage extends StatefulWidget {
  final VoidCallback onRegister;

  const RegisterManagerPage({super.key, required this.onRegister});

  @override
  State<RegisterManagerPage> createState() => _RegisterManagerPageState();
}

class _RegisterManagerPageState extends State<RegisterManagerPage> {
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onRegister();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta - Gestor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Completa tu información para administrar la flota',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const _LabeledField(label: 'Nombre completo'),
              const SizedBox(height: 12),
              const _LabeledField(label: 'Correo corporativo'),
              const SizedBox(height: 12),
              const _LabeledField(label: 'Nombre de la empresa'),
              const SizedBox(height: 12),
              const _LabeledField(label: 'Rol dentro de la empresa'),
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
