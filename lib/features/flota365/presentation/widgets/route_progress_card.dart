import 'package:easy_travel/features/flota365/domain/models/fleet_route.dart';
import 'package:flutter/material.dart';

/// Tarjeta que muestra el progreso y los detalles principales de una ruta.
class RouteProgressCard extends StatelessWidget {
  final FleetRoute route;
  final VoidCallback? onTap;

  const RouteProgressCard({super.key, required this.route, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    route.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Chip(
                    label: Text(route.status),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Origen: ${route.origin}'),
              Text('Destino: ${route.destination}'),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: route.completion),
              const SizedBox(height: 8),
              Text('Progreso ${(route.completion * 100).round()}%'),
              const SizedBox(height: 8),
              Text(route.notes),
            ],
          ),
        ),
      ),
    );
  }
}
