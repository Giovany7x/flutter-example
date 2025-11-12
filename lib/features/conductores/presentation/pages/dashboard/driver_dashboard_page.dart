import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/data/models/driver_dashboard_data.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_notification.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_profile.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_route.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/dashboard_map_card.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/driver_navigation_drawer.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/driver_notification_tile.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/evidence_reminder_card.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/metric_tile.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/quick_action_button.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/route_compact_card.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/trip_history_tile.dart';
import 'package:flutter/material.dart';

class DriverDashboardPage extends StatefulWidget {
  final DriverRepository repository;
  final DriverProfile driver;
  final VoidCallback onOpenCheckIn;
  final VoidCallback onOpenCheckOut;
  final VoidCallback onOpenRoutes;
  final VoidCallback onOpenEvidence;
  final VoidCallback onOpenHistory;
  final ValueChanged<List<DriverNotification>> onOpenNotifications;
  final VoidCallback onSignOut;

  const DriverDashboardPage({
    super.key,
    required this.repository,
    required this.driver,
    required this.onOpenCheckIn,
    required this.onOpenCheckOut,
    required this.onOpenRoutes,
    required this.onOpenEvidence,
    required this.onOpenHistory,
    required this.onOpenNotifications,
    required this.onSignOut,
  });

  @override
  State<DriverDashboardPage> createState() => _DriverDashboardPageState();
}

class _DriverDashboardPageState extends State<DriverDashboardPage> {
  late Future<DriverDashboardData> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _loadDashboard();
  }

  Future<DriverDashboardData> _loadDashboard({bool forceRefresh = false}) {
    return widget.repository.fetchDashboard(
      driverId: widget.driver.id,
      forceRefresh: forceRefresh,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _dashboardFuture = _loadDashboard(forceRefresh: true);
    });
    await _dashboardFuture;
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.driver;

    return FutureBuilder<DriverDashboardData>(
      future: _dashboardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          final message = snapshot.error is ApiException
              ? (snapshot.error as ApiException).message
              : 'No pudimos cargar la información del tablero.';
          return Scaffold(
            appBar: AppBar(
              title: const Text('Panel del conductor'),
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _refresh,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data ??
            const DriverDashboardData(
              routes: [],
              checkInChecklist: [],
              checkOutChecklist: [],
              evidences: [],
              tripHistory: [],
              notifications: [],
            );

        final routes = data.routes;
        final evidences = data.evidences;
        final history = data.tripHistory;
        final notifications = data.notifications;
        final highlightedRoute = data.highlightedRoute;

        final completedRoutes = history.length;
        final todaysPending = routes
            .where((route) => !route.status.toLowerCase().contains('complet'))
            .length;
        final avgRating = history.isEmpty
            ? 0.0
            : history
                    .map((record) => record.rating)
                    .fold<double>(0, (value, rating) => value + rating) /
                history.length;

        return Scaffold(
          drawer: DriverNavigationDrawer(
            driverName: driver.fullName,
            license: driver.licenseNumber,
            onDashboard: () => Navigator.of(context).pop(),
            onCheckIn: () {
              Navigator.of(context).pop();
              widget.onOpenCheckIn();
            },
            onCheckOut: () {
              Navigator.of(context).pop();
              widget.onOpenCheckOut();
            },
            onRoutes: () {
              Navigator.of(context).pop();
              widget.onOpenRoutes();
            },
            onEvidence: () {
              Navigator.of(context).pop();
              widget.onOpenEvidence();
            },
            onHistory: () {
              Navigator.of(context).pop();
              widget.onOpenHistory();
            },
            onSupport: () => _showSupportSheet(context),
            onSignOut: () {
              Navigator.of(context).pop();
              widget.onSignOut();
            },
          ),
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, ${driver.fullName.split(' ').first}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Licencia ${driver.licenseNumber}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => widget.onOpenNotifications(notifications),
                icon: const Icon(Icons.notifications_active_rounded),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundImage: NetworkImage(driver.avatarUrl),
              ),
              const SizedBox(width: 16),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: widget.onOpenCheckIn,
            icon: const Icon(Icons.fact_check_rounded),
            label: const Text('Iniciar Check-In'),
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (highlightedRoute != null)
                    DashboardMapCard(route: highlightedRoute)
                  else
                    const _EmptyRouteCard(),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    title: 'Resumen del día',
                    subtitle: 'Seguimiento visual de tu operación',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MetricTile(
                          title: 'Viajes completados',
                          value: completedRoutes.toString(),
                          caption: 'Últimas 2 semanas',
                          icon: Icons.flag_rounded,
                          color: const Color(0xFF0E86FE),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MetricTile(
                          title: 'Rutas activas',
                          value: todaysPending.toString(),
                          caption: 'Asignadas para hoy',
                          icon: Icons.alt_route_rounded,
                          color: const Color(0xFF9B51E0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MetricTile(
                          title: 'Evidencias pendientes',
                          value: evidences.length.toString(),
                          caption: 'Por enviar',
                          icon: Icons.cloud_upload_rounded,
                          color: const Color(0xFFF2994A),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MetricTile(
                          title: 'Calificación promedio',
                          value: avgRating.toStringAsFixed(1),
                          caption: '${history.length} viajes evaluados',
                          icon: Icons.star_rate_rounded,
                          color: const Color(0xFFF2C94C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Accesos rápidos'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          width: 140,
                          child: QuickActionButton(
                            icon: Icons.fact_check_rounded,
                            label: 'Check-In',
                            color: const Color(0xFF27AE60),
                            onPressed: widget.onOpenCheckIn,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 140,
                          child: QuickActionButton(
                            icon: Icons.assignment_turned_in_rounded,
                            label: 'Check-Out',
                            color: const Color(0xFFEB5757),
                            onPressed: widget.onOpenCheckOut,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 140,
                          child: QuickActionButton(
                            icon: Icons.alt_route_rounded,
                            label: 'Mis rutas',
                            color: const Color(0xFF0E86FE),
                            onPressed: widget.onOpenRoutes,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 140,
                          child: QuickActionButton(
                            icon: Icons.cloud_upload_rounded,
                            label: 'Evidencias',
                            color: const Color(0xFFF2994A),
                            onPressed: widget.onOpenEvidence,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 140,
                          child: QuickActionButton(
                            icon: Icons.history_rounded,
                            label: 'Historial',
                            color: const Color(0xFF4F4F4F),
                            onPressed: widget.onOpenHistory,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Mis rutas'),
                  const SizedBox(height: 12),
                  if (routes.isEmpty)
                    const Text('No tienes rutas asignadas por ahora.')
                  else
                    Column(
                      children: routes
                          .map(
                            (route) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: RouteCompactCard(
                                route: route,
                                onTap: widget.onOpenRoutes,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: widget.onOpenRoutes,
                      icon: const Icon(Icons.map_rounded),
                      label: const Text('Ver listado completo'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Alertas y novedades'),
                  const SizedBox(height: 12),
                  if (notifications.isEmpty)
                    const Text('Sin notificaciones recientes.')
                  else
                    ...notifications
                        .map(
                          (notification) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: DriverNotificationTile(notification: notification),
                          ),
                        )
                        .toList(),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Evidencias pendientes'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 190,
                    child: evidences.isEmpty
                        ? const Center(child: Text('No hay evidencias para enviar.'))
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: evidences.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) => SizedBox(
                              width: 220,
                              child: EvidenceReminderCard(
                                evidence: evidences[index],
                                onUpload: widget.onOpenEvidence,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Historial reciente'),
                  const SizedBox(height: 12),
                  if (history.isEmpty)
                    const Text('Aún no hay viajes registrados.')
                  else
                    ...history.take(3).map(
                      (record) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TripHistoryTile(record: record),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: widget.onOpenHistory,
                      icon: const Icon(Icons.list_alt_rounded),
                      label: const Text('Ver historial completo'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _ChecklistPreview(
                    route: highlightedRoute,
                    onOpenCheckIn: widget.onOpenCheckIn,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSupportSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Canales de soporte',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Línea 24/7'),
                subtitle: Text('+57 1 8000 123 456'),
              ),
              ListTile(
                leading: Icon(Icons.chat_bubble_outline),
                title: Text('Chat operativo'),
                subtitle: Text('Disponible en horario laboral'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionTitle({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        if (subtitle != null)
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
      ],
    );
  }
}

class _ChecklistPreview extends StatelessWidget {
  final DriverRoute? route;
  final VoidCallback onOpenCheckIn;

  const _ChecklistPreview({required this.route, required this.onOpenCheckIn});

  @override
  Widget build(BuildContext context) {
    if (route == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF27AE60).withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.verified_rounded, color: Color(0xFF27AE60)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Checklist del vehículo listo',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ruta asignada ${route!.name}. No olvides reportar novedades al terminar.',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: onOpenCheckIn,
            child: const Text('Ver checklist'),
          ),
        ],
      ),
    );
  }
}

class _EmptyRouteCard extends StatelessWidget {
  const _EmptyRouteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Sin ruta destacada',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Cuando recibas una nueva asignación aparecerá aquí.'),
        ],
      ),
    );
  }
}
