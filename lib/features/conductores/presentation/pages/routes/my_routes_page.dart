import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_route.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/route_compact_card.dart';
import 'package:flutter/material.dart';

class MyRoutesPage extends StatefulWidget {
  final DriverRepository repository;
  final ValueChanged<DriverRoute> onRouteSelected;
  final String? driverId;

  const MyRoutesPage({
    super.key,
    required this.repository,
    required this.onRouteSelected,
    required this.driverId,
  });

  @override
  State<MyRoutesPage> createState() => _MyRoutesPageState();
}

class _MyRoutesPageState extends State<MyRoutesPage> {
  late Future<List<DriverRoute>> _routesFuture;

  @override
  void initState() {
    super.initState();
    _routesFuture = _loadRoutes();
  }

  Future<List<DriverRoute>> _loadRoutes({bool forceRefresh = false}) {
    if (widget.driverId == null) {
      return Future.error(
        const ApiException('No hay conductor autenticado.'),
      );
    }
    return widget.repository.getRoutesForDriver(
      driverId: widget.driverId,
      forceRefresh: forceRefresh,
    );
  }

  void _retry() {
    setState(() {
      _routesFuture = _loadRoutes(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DriverRoute>>(
      future: _routesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          final message = snapshot.error is ApiException
              ? (snapshot.error as ApiException).message
              : 'No pudimos obtener tus rutas asignadas.';
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mis rutas asignadas'),
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _retry,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final routes = snapshot.data ?? const <DriverRoute>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mis rutas asignadas'),
            centerTitle: false,
          ),
          body: routes.isEmpty
              ? const Center(
                  child: Text('No tienes rutas asignadas por el momento.'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                  itemCount: routes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final route = routes[index];
                    return RouteCompactCard(
                      route: route,
                      onTap: () => widget.onRouteSelected(route),
                    );
                  },
                ),
          floatingActionButton: routes.isEmpty
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _showAssignmentsSheet(context, routes),
                  icon: const Icon(Icons.calendar_today_rounded),
                  label: const Text('Ver planificación'),
                ),
        );
      },
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
