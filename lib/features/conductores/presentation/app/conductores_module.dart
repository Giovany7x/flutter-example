import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_route.dart';
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
          initialRoute: ConductoresRoutes.dashboard,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case ConductoresRoutes.welcome:
                return MaterialPageRoute(
                  builder: (_) => WelcomePage(
                    onContinue: () => Navigator.of(context).pushReplacementNamed(
                      ConductoresRoutes.dashboard,
                    ),
                  ),
                );
              case ConductoresRoutes.dashboard:
                return MaterialPageRoute(
                  builder: (context) => DriverDashboardPage(
                    repository: repository,
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
                    onOpenNotifications: () {
                      final snackBar = SnackBar(
                        content: const Text('Centro de notificaciones en construcción.'),
                        action: SnackBarAction(
                          label: 'Ver',
                          onPressed: () => Navigator.of(context).pushNamed(
                            ConductoresRoutes.history,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    onSignOut: () {
                      context.read<DriverSessionCubit>().signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        ConductoresRoutes.welcome,
                        (route) => false,
                      );
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
                  builder: (_) => MyRoutesPage(
                    repository: repository,
                    onRouteSelected: (route) => Navigator.of(context).pushNamed(
                      ConductoresRoutes.routeDetail,
                      arguments: route,
                    ),
                  ),
                );
              case ConductoresRoutes.routeDetail:
                final route = settings.arguments as DriverRoute? ??
                    repository.getHighlightedRoute(repository.demoDriver.id);
                return MaterialPageRoute(
                  builder: (_) => RouteDetailPage(route: route),
                );
              case ConductoresRoutes.evidence:
                return MaterialPageRoute(
                  builder: (_) => EvidenceCenterPage(
                    evidences: repository.getEvidenceRequirements(),
                    onUploadRequested: () => Navigator.of(context).pop(),
                  ),
                );
              case ConductoresRoutes.history:
                return MaterialPageRoute(
                  builder: (_) => TripHistoryPage(
                    records: repository.getTripHistory(),
                  ),
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
