import 'dart:async';

import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/domain/models/fleet_route.dart';
import 'package:easy_travel/features/flota365/domain/models/trip_record.dart';
import 'package:easy_travel/features/flota365/presentation/bloc/driver_session_cubit.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/driver_flow_showcase.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/driver_navigation_drawer.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/route_progress_card.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/trip_record_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dashboard principal para los conductores de Flota365.
///
/// El diseño prioriza componentes móviles: carruseles, chips accionables y
/// secciones compactas que ayudan a navegar rápidamente entre los flujos clave
/// (check-in, rutas, evidencias e historial).
class DriverDashboardPage extends StatelessWidget {
  final FleetRepository repository;
  final VoidCallback onOpenRoutes;
  final VoidCallback onOpenCheckIn;
  final VoidCallback onOpenCheckOut;
  final VoidCallback onOpenEvidence;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenNotifications;
  final VoidCallback onSignOut;

  const DriverDashboardPage({
    super.key,
    required this.repository,
    required this.onOpenRoutes,
    required this.onOpenCheckIn,
    required this.onOpenCheckOut,
    required this.onOpenEvidence,
    required this.onOpenHistory,
    required this.onOpenNotifications,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<DriverSessionCubit>().state;
    final driver = sessionState.driver ?? repository.demoDriver;

    // -- Datos que alimentan las diferentes tarjetas del tablero.
    final routes = repository.getRoutesForDriver(driver.id);
    final pendingEvidences = repository.getPendingEvidences(driver.id);
    final tripHistory = repository.getTripHistory(driver.id);
    final averageRating = tripHistory.isEmpty
        ? 0
        : tripHistory
                .map((record) => record.rating)
                .reduce((value, rating) => value + rating) /
            tripHistory.length;

    // -- Acciones principales mostradas como chips deslazables.
    final quickActions = [
      _QuickActionData(
        label: 'Check-In',
        icon: Icons.login_rounded,
        color: const Color(0xFF27AE60),
        onTap: onOpenCheckIn,
      ),
      _QuickActionData(
        label: 'Check-Out',
        icon: Icons.logout_rounded,
        color: const Color(0xFFEB5757),
        onTap: onOpenCheckOut,
      ),
      _QuickActionData(
        label: 'Mis rutas',
        icon: Icons.alt_route_rounded,
        color: const Color(0xFF0C7EE8),
        onTap: onOpenRoutes,
      ),
      _QuickActionData(
        label: 'Subir evidencia',
        icon: Icons.cloud_upload_rounded,
        color: const Color(0xFFF2994A),
        onTap: onOpenEvidence,
      ),
      _QuickActionData(
        label: 'Notificaciones',
        icon: Icons.notifications_active_rounded,
        color: const Color(0xFF2D9CDB),
        onTap: onOpenNotifications,
      ),
      _QuickActionData(
        label: 'Historial',
        icon: Icons.history_rounded,
        color: const Color(0xFF4F4F4F),
        onTap: onOpenHistory,
      ),
    ];

    // -- Indicadores rápidos que resumen el desempeño del conductor.
    final pulseMetrics = [
      _DriverPulseMetric(
        title: 'Viajes completados',
        value: tripHistory.length.toString(),
        caption: 'Últimos 14 días',
        icon: Icons.flag_circle,
        color: const Color(0xFF0C7EE8),
      ),
      _DriverPulseMetric(
        title: 'Rutas activas',
        value: routes.where((route) => route.status != 'Completada').length.toString(),
        caption: 'Pendientes hoy',
        icon: Icons.directions_bus,
        color: const Color(0xFF9B51E0),
      ),
      _DriverPulseMetric(
        title: 'Promedio de calificación',
        value: averageRating.toStringAsFixed(1),
        caption: '${tripHistory.length} viajes evaluados',
        icon: Icons.star_rate_rounded,
        color: const Color(0xFFF2C94C),
      ),
      _DriverPulseMetric(
        title: 'Evidencias pendientes',
        value: pendingEvidences.length.toString(),
        caption: 'Listas para enviar',
        icon: Icons.verified_outlined,
        color: const Color(0xFF27AE60),
      ),
    ];

    return Scaffold(
      drawer: DriverNavigationDrawer(
        driverName: driver.fullName,
        driverLicense: driver.licenseNumber,
        onOpenProfile: () {
          Navigator.of(context).pop();
          Future.microtask(() {
            _showProfileSheet(context, driver.fullName, driver.id, driver.licenseNumber, driver.email);
          });
        },
        onOpenDashboard: () => Navigator.of(context).pop(),
        onOpenCheckIn: () {
          Navigator.of(context).pop();
          onOpenCheckIn();
        },
        onOpenCheckOut: () {
          Navigator.of(context).pop();
          onOpenCheckOut();
        },
        onOpenRoutes: () {
          Navigator.of(context).pop();
          onOpenRoutes();
        },
        onOpenNotifications: () {
          Navigator.of(context).pop();
          onOpenNotifications();
        },
        onOpenEvidence: () {
          Navigator.of(context).pop();
          onOpenEvidence();
        },
        onOpenHistory: () {
          Navigator.of(context).pop();
          onOpenHistory();
        },
        onOpenSupport: () {
          Navigator.of(context).pop();
          Future.microtask(() {
            _showSupportSheet(context);
          });
        },
        onSignOut: () {
          Navigator.of(context).pop();
          onSignOut();
        },
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded),
              tooltip: 'Menú de navegación',
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: const Text('Dashboard de conductor'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: onSignOut,
            icon: const Icon(Icons.logout_rounded),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Icon(Icons.person)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onOpenCheckIn,
        icon: const Icon(Icons.checklist_rtl_rounded),
        label: const Text('Iniciar Check-In'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simula la recarga de datos en la demo.
          await Future<void>.delayed(const Duration(milliseconds: 700));
        },
        edgeOffset: 120,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: _DashboardHeader(
                  driverName: driver.fullName,
                  license: driver.licenseNumber,
                  isLoggedIn: sessionState.isLoggedIn,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 96,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final action = quickActions[index];
                    return _QuickActionChip(action: action);
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: quickActions.length,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Ruta en curso',
                  onViewMore: routes.isEmpty ? null : onOpenRoutes,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: routes.isEmpty
                    ? const _EmptyStateMessage(
                        icon: Icons.sentiment_satisfied_alt,
                        message: 'No tienes rutas asignadas por el momento.',
                      )
                    : _RouteCarousel(
                        routes: routes,
                        onOpenRoutes: onOpenRoutes,
                        onOpenCheckIn: onOpenCheckIn,
                      ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Pulso de la jornada',
                  subtitle: 'Monitorea tus indicadores personales',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.05,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final metric = pulseMetrics[index];
                    return _DriverPulseCard(metric: metric);
                  },
                  childCount: pulseMetrics.length,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Evidencias pendientes',
                  onViewMore: pendingEvidences.isEmpty ? null : onOpenEvidence,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: pendingEvidences.isEmpty
                    ? const _EmptyStateMessage(
                        icon: Icons.cloud_done_outlined,
                        message: '¡Todo listo! No tienes evidencias pendientes.',
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          final evidence = pendingEvidences[index];
                          return _EvidenceReminderCard(
                            evidenceTitle: evidence.title,
                            description: evidence.description,
                            onTap: onOpenEvidence,
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemCount: pendingEvidences.length,
                      ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Historial reciente',
                  onViewMore: tripHistory.isEmpty ? null : onOpenHistory,
                ),
              ),
            ),
            if (tripHistory.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _EmptyStateMessage(
                    icon: Icons.route_outlined,
                    message: 'Cuando completes rutas las verás listadas aquí.',
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: tripHistory
                        .take(3)
                        .map(
                          (record) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TripRecordTile(record: record),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Descubre el flujo completo',
                  subtitle: 'Explora cada pantalla antes de navegar',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                child: DriverFlowShowcase(
                  steps: _buildFlowSteps(),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Crea los pasos del carrusel explicativo del flujo del conductor.
  List<DriverFlowStep> _buildFlowSteps() {
    return const [
      DriverFlowStep(
        title: 'Dashboard',
        description: 'Resumen del día, rutas activas y accesos rápidos.',
        icon: Icons.dashboard_outlined,
        accentColor: Color(0xFF0C7EE8),
      ),
      DriverFlowStep(
        title: 'Check-In',
        description: 'Completa la lista de verificación al iniciar tu turno.',
        icon: Icons.login,
        accentColor: Color(0xFF27AE60),
      ),
      DriverFlowStep(
        title: 'Check-Out',
        description: 'Registra el cierre y estado del vehículo al terminar.',
        icon: Icons.logout,
        accentColor: Color(0xFFEB5757),
      ),
      DriverFlowStep(
        title: 'Mis rutas',
        description: 'Consulta tus rutas asignadas y monitoréalas.',
        icon: Icons.alt_route,
        accentColor: Color(0xFF9B51E0),
      ),
      DriverFlowStep(
        title: 'Detalle de ruta',
        description: 'Visualiza paradas, horarios y puntos críticos.',
        icon: Icons.map_outlined,
        accentColor: Color(0xFF2D9CDB),
      ),
      DriverFlowStep(
        title: 'Subir evidencias',
        description: 'Envía fotografías y documentos requeridos.',
        icon: Icons.cloud_upload_outlined,
        accentColor: Color(0xFFF2994A),
      ),
      DriverFlowStep(
        title: 'Historial',
        description: 'Revisa viajes completados y calificaciones.',
        icon: Icons.history,
        accentColor: Color(0xFF4F4F4F),
      ),
    ];
  }

  /// Despliega la hoja inferior con los datos del perfil del conductor.
  void _showProfileSheet(
    BuildContext context,
    String fullName,
    String driverId,
    String license,
    String email,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text('ID del conductor: $driverId'),
              Text('Licencia: $license'),
              const SizedBox(height: 12),
              Text('Correo de contacto: $email'),
              const Text('Teléfono: No disponible en la demo'),
            ],
          ),
        );
      },
    );
  }

  /// Despliega la hoja inferior con los datos de soporte.
  void _showSupportSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contacto de soporte',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.phone),
                title: Text('+57 1 8000 123 456'),
                subtitle: Text('Línea de atención 24/7'),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.mail_outline),
                title: Text('soporte@flota365.com'),
                subtitle: Text('Escríbenos para ayuda especializada'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Cabecera con el saludo personalizado y el número de licencia.
class _DashboardHeader extends StatelessWidget {
  final String driverName;
  final String license;
  final bool isLoggedIn;

  const _DashboardHeader({
    required this.driverName,
    required this.license,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.25),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLoggedIn ? '¡Bienvenido, $driverName!' : 'Modo demo activo',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isLoggedIn
                ? 'Licencia • $license'
                : 'Inicia sesión para sincronizar tus datos reales.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Listo para tu próxima ruta',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sincronización rápida completada.'),
                    ),
                  );
                },
                icon: const Icon(Icons.sync_rounded, color: Colors.white),
                tooltip: 'Sincronizar datos',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Encabezado reutilizable para cada sección del dashboard.
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onViewMore;

  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (onViewMore != null)
          TextButton(
            onPressed: onViewMore,
            child: const Text('Ver más'),
          ),
      ],
    );
  }
}

/// Datos mínimos necesarios para renderizar un chip de acción rápida.
class _QuickActionData {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionData({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

/// Chip decorativo que dispara una acción principal del flujo.
class _QuickActionChip extends StatelessWidget {
  final _QuickActionData action;

  const _QuickActionChip({required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: action.color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: action.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: action.color,
                child: Icon(action.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                action.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Carrusel que muestra la ruta activa y las siguientes asignaciones.
class _RouteCarousel extends StatefulWidget {
  final List<FleetRoute> routes;
  final VoidCallback onOpenRoutes;
  final VoidCallback onOpenCheckIn;

  const _RouteCarousel({
    required this.routes,
    required this.onOpenRoutes,
    required this.onOpenCheckIn,
  });

  @override
  State<_RouteCarousel> createState() => _RouteCarouselState();
}

class _RouteCarouselState extends State<_RouteCarousel> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.routes.length,
        itemBuilder: (context, index) {
          final route = widget.routes[index];
          final currentPage = _controller.hasClients && _controller.page != null
              ? _controller.page!
              : _controller.initialPage.toDouble();
          final isFocused = index == currentPage.round();

          return AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(
              horizontal: isFocused ? 4 : 12,
              vertical: isFocused ? 0 : 12,
            ),
            child: RouteProgressCard(
              route: route,
              onTap: () => _showRouteQuickLook(context, route),
            ),
          );
        },
      ),
    );
  }

  /// Hoja inferior con acciones rápidas relacionadas a la ruta.
  void _showRouteQuickLook(BuildContext context, FleetRoute route) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                route.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text('Horario: ${route.schedule}'),
              Text('Origen: ${route.origin}'),
              Text('Destino: ${route.destination}'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: route.stops
                    .map((stop) => Chip(
                          label: Text(stop),
                          avatar: const Icon(Icons.location_on, size: 16),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        widget.onOpenRoutes();
                      },
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Ver detalle'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        widget.onOpenCheckIn();
                      },
                      icon: const Icon(Icons.login_rounded),
                      label: const Text('Iniciar check-in'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Define la información de un indicador del tablero.
class _DriverPulseMetric {
  final String title;
  final String value;
  final String caption;
  final IconData icon;
  final Color color;

  const _DriverPulseMetric({
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.color,
  });
}

/// Tarjeta que muestra un indicador con una pequeña animación.
class _DriverPulseCard extends StatelessWidget {
  final _DriverPulseMetric metric;

  const _DriverPulseCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: metric.color.withOpacity(0.12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: metric.color,
            child: Icon(metric.icon, color: Colors.white),
          ),
          const Spacer(),
          Text(
            metric.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              child: child,
            ),
            child: Text(
              metric.value,
              key: ValueKey(metric.value),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.caption,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Tarjeta horizontal que recuerda enviar evidencias.
class _EvidenceReminderCard extends StatelessWidget {
  final String evidenceTitle;
  final String description;
  final VoidCallback onTap;

  const _EvidenceReminderCard({
    required this.evidenceTitle,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 260,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: const Icon(Icons.fact_check_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        evidenceTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Text(
                    description,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FilledButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                    label: const Text('Subir ahora'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Mensaje reutilizable para estados vacíos.
class _EmptyStateMessage extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyStateMessage({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
