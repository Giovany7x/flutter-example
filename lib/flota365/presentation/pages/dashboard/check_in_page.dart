import 'package:flutter/material.dart';

/// Formulario de Check-In inspirado en la maqueta.
///
/// Permite registrar la hora de inicio, nivel de combustible y comentarios.
class CheckInPage extends StatefulWidget {
  final VoidCallback onCompleted;

  const CheckInPage({super.key, required this.onCompleted});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final _formKey = GlobalKey<FormState>();
  double _fuelLevel = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-In')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Registra tu inicio de turno',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Hora de llegada',
                  hintText: 'Ej. 05:15 am',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa la hora' : null,
              ),
              const SizedBox(height: 16),
              Text(
                'Nivel de combustible',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: _fuelLevel,
                onChanged: (value) => setState(() => _fuelLevel = value),
                divisions: 10,
                label: '${(_fuelLevel * 100).round()}%',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Kilometraje actual',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa el kilometraje' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Observaciones',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Check-In guardado con combustible ${(_fuelLevel * 100).round()}%',
                        ),
                      ),
                    );
                    widget.onCompleted();
                  }
                },
                child: const Text('Guardar Check-In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
