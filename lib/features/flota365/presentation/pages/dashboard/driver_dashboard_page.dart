import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/presentation/bloc/driver_session_cubit.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/dashboard_action_card.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/driver_flow_showcase.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/route_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final VoidCallback onSignOut;

  const DriverDashboardPage({
    super.key,
    required this.repository,
    required this.onOpenRoutes,
    required this.onOpenCheckIn,
    required this.onOpenCheckOut,
    required this.onOpenEvidence,
    required this.onOpenHistory,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<DriverSessionCubit>().state;
    final driver = sessionState.driver ?? repository.demoDriver;
    final routes = repository.getRoutesForDriver(driver.id);
    final flowSteps = [
      const DriverFlowStep(
        title: 'Dashboard',
        description: 'Resumen del día, ruta activa y accesos rápidos.',
        icon: Icons.dashboard_outlined,
        accentColor: Color(0xFF0C7EE8),
      ),
      const DriverFlowStep(
        title: 'Check-In',
        description: 'Completa la lista de verificación al iniciar tu turno.',
        icon: Icons.login,
        accentColor: Color(0xFF27AE60),
      ),
      const DriverFlowStep(
        title: 'Check-Out',
        description: 'Registra el cierre y estado del vehículo al terminar.',
        icon: Icons.logout,
        accentColor: Color(0xFFEB5757),
      ),
      const DriverFlowStep(
        title: 'Mis rutas',
        description: 'Consulta tus rutas asignadas y monitoréalas.',
        icon: Icons.alt_route,
        accentColor: Color(0xFF9B51E0),
      ),
      const DriverFlowStep(
        title: 'Detalle de ruta',
        description: 'Visualiza paradas, horarios y puntos críticos.',
        icon: Icons.map_outlined,
        accentColor: Color(0xFF2D9CDB),
      ),
      const DriverFlowStep(
        title: 'Subir evidencias',
        description: 'Envía fotografías y documentos requeridos.',
        icon: Icons.cloud_upload_outlined,
        accentColor: Color(0xFFF2994A),
      ),
      const DriverFlowStep(
        title: 'Historial',
        description: 'Revisa viajes completados y calificaciones.',
        icon: Icons.history,
        accentColor: Color(0xFF4F4F4F),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: onSignOut,
            icon: const Icon(Icons.logout),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Icon(Icons.person)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            sessionState.isLoggedIn
                ? '¡Bienvenido, ${driver.fullName}!'
                : '¡Bienvenido a Flota365! (Demo)',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            sessionState.isLoggedIn
                ? 'Conductor activo • Licencia ${driver.licenseNumber}'
                : 'Inicia sesión para sincronizar tus datos reales.',
          ),
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
          const SizedBox(height: 24),
          Text(
            'Flujo del conductor',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          DriverFlowShowcase(
            steps: flowSteps,
            onStepSelected: (step) {
              switch (step.title) {
                case 'Dashboard':
                  break;
                case 'Check-In':
                  onOpenCheckIn();
                  break;
                case 'Check-Out':
                  onOpenCheckOut();
                  break;
                case 'Mis rutas':
                  onOpenRoutes();
                  break;
                case 'Detalle de ruta':
                  onOpenRoutes();
                  break;
                case 'Subir evidencias':
                  onOpenEvidence();
                  break;
                case 'Historial':
                  onOpenHistory();
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
