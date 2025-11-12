import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_route.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/route_compact_card.dart';
import 'package:flutter/material.dart';

class MyRoutesPage extends StatelessWidget {
  final DriverRepository repository;
  final ValueChanged<DriverRoute> onRouteSelected;

  const MyRoutesPage({super.key, required this.repository, required this.onRouteSelected});

  @override
  Widget build(BuildContext context) {
    final driver = repository.demoDriver;
    final routes = repository.getRoutesForDriver(driver.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis rutas asignadas'),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        itemCount: routes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final route = routes[index];
          return RouteCompactCard(
            route: route,
            onTap: () => onRouteSelected(route),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAssignmentsSheet(context, routes),
        icon: const Icon(Icons.calendar_today_rounded),
        label: const Text('Ver planificación'),
      ),
    );
  }

  void _showAssignmentsSheet(BuildContext context, List<DriverRoute> routes) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Próximas asignaciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...routes.map(
                (route) => ListTile(
                  leading: const Icon(Icons.route_outlined),
                  title: Text(route.name),
                  subtitle: Text('${route.origin} → ${route.destination} • ${route.schedule}'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
