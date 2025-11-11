import 'package:easy_travel/features/flota365/domain/models/fleet_route.dart';
import 'package:flutter/material.dart';

/// Pantalla que muestra los detalles completos de una ruta.
class RouteDetailPage extends StatelessWidget {
  final FleetRoute route;

  const RouteDetailPage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(route.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Center(
                child: Text('Mapa detallado de la ruta'),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Horario programado',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(route.schedule),
            const SizedBox(height: 16),
            Text(
              'Paradas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...route.stops.map(
              (stop) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on_outlined),
                title: Text(stop),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Notas operativas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(route.notes),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ruta ${route.name} marcada como completada.')),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Marcar como completada'),
            ),
          ],
        ),
      ),
    );
  }
}
