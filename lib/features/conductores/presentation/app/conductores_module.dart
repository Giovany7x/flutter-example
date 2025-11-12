import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_notification.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_route.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_profile.dart';
import 'package:easy_travel/features/conductores/presentation/blocs/driver_session_cubit.dart';
import 'package:easy_travel/features/conductores/presentation/pages/dashboard/driver_dashboard_page.dart';
import 'package:easy_travel/features/conductores/presentation/pages/forms/check_in_page.dart';
import 'package:easy_travel/features/conductores/presentation/pages/forms/check_out_page.dart';
import 'package:easy_travel/features/conductores/presentation/pages/general/welcome_page.dart';
import 'package:easy_travel/features/conductores/presentation/pages/history/trip_history_page.dart';
import 'package:easy_travel/features/conductores/presentation/pages/routes/my_routes_page.dart';
import 'package:easy_travel/features/conductores/presentation/pages/routes/route_detail_page.dart';
import 'package:easy_travel/features/conductores/presentation/pages/evidence/evidence_center_page.dart';
import 'package:easy_travel/features/conductores/presentation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget raíz del módulo de conductores.
class ConductoresModule extends StatelessWidget {
  final DriverRepository repository;

  ConductoresModule({super.key, DriverRepository? repository})
      : repository = repository ?? DriverRepository.instance;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (_) => DriverSessionCubit(repository: repository)..signInDemoDriver(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flota365 - Conductores',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00AEEF)),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF4F7FB),
            appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
          ),
          initialRoute: ConductoresRoutes.welcome,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case ConductoresRoutes.welcome:
                return MaterialPageRoute(
                  builder: (_) => WelcomePage(
                    onAuthenticated: () => Navigator.of(context).pushReplacementNamed(
                      ConductoresRoutes.dashboard,
                    ),
                  ),
                );
              case ConductoresRoutes.dashboard:
                return MaterialPageRoute(
                  builder: (context) => BlocBuilder<DriverSessionCubit, DriverSessionState>(
                    builder: (context, state) {
                      if (state.status == DriverSessionStatus.authenticated &&
                          state.driver != null) {
                        final driver = state.driver!;
                        return DriverDashboardPage(
                          repository: repository,
                          driver: driver,
                          onOpenCheckIn: () => Navigator.of(context).pushNamed(
                            ConductoresRoutes.checkIn,
                          ),
                          onOpenCheckOut: () => Navigator.of(context).pushNamed(
                            ConductoresRoutes.checkOut,
                          ),
                          onOpenRoutes: () => Navigator.of(context).pushNamed(
                            ConductoresRoutes.myRoutes,
                          ),
                          onOpenEvidence: () => Navigator.of(context).pushNamed(
                            ConductoresRoutes.evidence,
                          ),
                          onOpenHistory: () => Navigator.of(context).pushNamed(
                            ConductoresRoutes.history,
                          ),
                          onOpenNotifications: (notifications) => _showNotifications(context, notifications),
                          onSignOut: () {
                            context.read<DriverSessionCubit>().signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              ConductoresRoutes.welcome,
                              (route) => false,
                            );
                          },
                        );
                      }

                      if (state.status == DriverSessionStatus.loading) {
                        return const _FullScreenLoader(message: 'Validando credenciales...');
                      }

                      return const _SessionRequiredPlaceholder();
                    },
                  ),
                );
              case ConductoresRoutes.checkIn:
                return MaterialPageRoute(
                  builder: (_) => CheckInPage(
                    onCompleted: () => Navigator.of(context).pop(),
                  ),
                );
              case ConductoresRoutes.checkOut:
                return MaterialPageRoute(
                  builder: (_) => CheckOutPage(
                    onCompleted: () => Navigator.of(context).pop(),
                  ),
                );
              case ConductoresRoutes.myRoutes:
                return MaterialPageRoute(
                  builder: (_) => BlocBuilder<DriverSessionCubit, DriverSessionState>(
                    builder: (context, state) {
                      final driver = state.driver ?? repository.currentDriver;
                      return MyRoutesPage(
                        repository: repository,
                        driverId: driver?.id,
                        onRouteSelected: (route) => Navigator.of(context).pushNamed(
                          ConductoresRoutes.routeDetail,
                          arguments: route,
                        ),
                      );
                    },
                  ),
                );
              case ConductoresRoutes.routeDetail:
                final route = settings.arguments as DriverRoute? ??
                    null;
                return MaterialPageRoute(
                  builder: (_) => FutureBuilder<DriverRoute?>(
                    future: route != null
                        ? Future.value(route)
                        : repository.getHighlightedRoute(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const _FullScreenLoader(message: 'Cargando ruta...');
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return const _SessionRequiredPlaceholder();
                      }
                      return RouteDetailPage(route: snapshot.data!);
                    },
                  ),
                );
              case ConductoresRoutes.evidence:
                return MaterialPageRoute(
                  builder: (_) => EvidenceCenterPage(
                    repository: repository,
                    onUploadRequested: () => Navigator.of(context).pop(),
                  ),
                );
              case ConductoresRoutes.history:
                return MaterialPageRoute(
                  builder: (_) => TripHistoryPage(repository: repository),
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(
                      child: Text('Ruta no encontrada: \\${settings.name}'),
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

void _showNotifications(BuildContext context, List<DriverNotification> notifications) {
  if (notifications.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No tienes notificaciones nuevas.')),
    );
    return;
  }

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
              'Notificaciones recientes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...notifications.map(
              (notification) => ListTile(
                leading: Icon(
                  notification.isCritical ? Icons.priority_high : Icons.notifications,
                  color: notification.isCritical ? const Color(0xFFE74C3C) : null,
                ),
                title: Text(notification.title),
                subtitle: Text(notification.description),
                trailing: Text(notification.timeAgo),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _FullScreenLoader extends StatelessWidget {
  final String message;

  const _FullScreenLoader({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}

class _SessionRequiredPlaceholder extends StatelessWidget {
  const _SessionRequiredPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48),
            const SizedBox(height: 16),
            const Text('Inicia sesión para ver tu tablero'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                ConductoresRoutes.welcome,
                (route) => false,
              ),
              child: const Text('Ir al inicio de sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
