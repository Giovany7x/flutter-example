import 'package:easy_travel/flota365/data/fleet_repository.dart';
import 'package:easy_travel/flota365/presentation/widgets/dashboard_action_card.dart';
import 'package:easy_travel/flota365/presentation/widgets/route_progress_card.dart';
import 'package:flutter/material.dart';

/// Dashboard principal para los conductores de Flota365.
///
/// Resume la información relevante: bienvenida, ruta activa y accesos rápidos
/// a los diferentes flujos (check-in, check-out, evidencias e historial).
class DriverDashboardPage extends StatelessWidget {
  final FleetRepository repository;
  final VoidCallback onOpenRoutes;
  final VoidCallback onOpenCheckIn;
  final VoidCallback onOpenCheckOut;
  final VoidCallback onOpenEvidence;
  final VoidCallback onOpenHistory;

  const DriverDashboardPage({
    super.key,
    required this.repository,
    required this.onOpenRoutes,
    required this.onOpenCheckIn,
    required this.onOpenCheckOut,
    required this.onOpenEvidence,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    final driver = repository.demoDriver;
    final routes = repository.getRoutesForDriver(driver.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Icon(Icons.person)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            '¡Bienvenido, ${driver.fullName}!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text('Conductor activo • Licencia ${driver.licenseNumber}'),
          const SizedBox(height: 24),
          Text(
            'Ruta en curso',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (routes.isNotEmpty)
            RouteProgressCard(
              route: routes.first,
              onTap: onOpenRoutes,
            )
          else
            const Text('No hay rutas asignadas por el momento.'),
          const SizedBox(height: 24),
          Text(
            'Acciones rápidas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          DashboardActionCard(
            title: 'Check-In',
            description: 'Registra tu llegada y completa la lista de verificación.',
            icon: Icons.login,
            onTap: onOpenCheckIn,
          ),
          const SizedBox(height: 12),
          DashboardActionCard(
            title: 'Check-Out',
            description: 'Finaliza tu turno y reporta el estado del vehículo.',
            icon: Icons.logout,
            onTap: onOpenCheckOut,
          ),
          const SizedBox(height: 12),
          DashboardActionCard(
            title: 'Mis rutas',
            description: 'Consulta los detalles y el progreso de tus rutas.',
            icon: Icons.alt_route,
            onTap: onOpenRoutes,
          ),
          const SizedBox(height: 12),
          DashboardActionCard(
            title: 'Subir evidencias',
            description: 'Adjunta fotos y documentos requeridos por la operación.',
            icon: Icons.cloud_upload_outlined,
            onTap: onOpenEvidence,
          ),
          const SizedBox(height: 12),
          DashboardActionCard(
            title: 'Historial',
            description: 'Revisa tus viajes completados y calificaciones.',
            icon: Icons.history,
            onTap: onOpenHistory,
          ),
        ],
      ),
    );
  }
}
