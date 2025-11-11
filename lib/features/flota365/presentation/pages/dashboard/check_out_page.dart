import 'package:flutter/material.dart';

/// Pantalla de Check-Out para finalizar el turno del conductor.
///
/// Incluye campos para reportar kilometraje final, daños y comentarios.
class CheckOutPage extends StatefulWidget {
  final VoidCallback onCompleted;

  const CheckOutPage({super.key, required this.onCompleted});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final _formKey = GlobalKey<FormState>();
  bool _vehicleIssues = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-Out')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Cierre tu jornada',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Kilometraje final'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa el kilometraje final' : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('¿Detectaste algún daño o anomalía?'),
                value: _vehicleIssues,
                onChanged: (value) => setState(() => _vehicleIssues = value),
              ),
              if (_vehicleIssues)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Describe los daños',
                  ),
                  maxLines: 4,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Describe el estado del vehículo'
                      : null,
                ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Comentarios finales'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Check-Out registrado con éxito.')),
                    );
                    widget.onCompleted();
                  }
                },
                child: const Text('Finalizar jornada'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
