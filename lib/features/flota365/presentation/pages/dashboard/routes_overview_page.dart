import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/domain/models/fleet_route.dart';
import 'package:easy_travel/features/flota365/presentation/pages/routes/my_routes_page.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/route_progress_card.dart';
import 'package:flutter/material.dart';

/// Vista con mapa y tarjetas que resume las rutas activas.
class RoutesOverviewPage extends StatelessWidget {
  final FleetRepository repository;
  final ValueChanged<FleetRoute> onRouteSelected;

  const RoutesOverviewPage({
    super.key,
    required this.repository,
    required this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    final routes = repository.getRoutesForDriver(repository.demoDriver.id);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis rutas'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mapa'),
              Tab(text: 'Listado'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0C7EE8), Color(0xFF53B0FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Mapa de rutas (placeholder)',
                    style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            ListView.separated(
              padding: const EdgeInsets.all(24.0),
              itemBuilder: (context, index) => RouteProgressCard(
                route: routes[index],
                onTap: () => onRouteSelected(routes[index]),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: routes.length,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MyRoutesPage(
                  repository: repository,
                  onRouteSelected: onRouteSelected,
                ),
              ),
            );
          },
          icon: const Icon(Icons.view_list),
          label: const Text('Ver en pantalla completa'),
        ),
      ),
    );
  }
}
