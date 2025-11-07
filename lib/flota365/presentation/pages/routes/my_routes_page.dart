import 'package:easy_travel/flota365/data/fleet_repository.dart';
import 'package:easy_travel/flota365/domain/models/fleet_route.dart';
import 'package:easy_travel/flota365/presentation/widgets/route_progress_card.dart';
import 'package:flutter/material.dart';

/// Lista de rutas asignadas al conductor.
class MyRoutesPage extends StatelessWidget {
  final FleetRepository repository;
  final ValueChanged<FleetRoute> onRouteSelected;

  const MyRoutesPage({
    super.key,
    required this.repository,
    required this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    final routes = repository.getRoutesForDriver(repository.demoDriver.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis rutas')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemBuilder: (context, index) => RouteProgressCard(
          route: routes[index],
          onTap: () => onRouteSelected(routes[index]),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: routes.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sincronizando rutas con el backend...')),
          );
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Actualizar'),
      ),
    );
  }
}
