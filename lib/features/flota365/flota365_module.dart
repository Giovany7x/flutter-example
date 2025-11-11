import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/domain/models/fleet_route.dart';
import 'package:easy_travel/features/flota365/presentation/bloc/driver_session_cubit.dart';
import 'package:easy_travel/features/flota365/presentation/pages/dashboard/check_in_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/dashboard/check_out_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/dashboard/driver_dashboard_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/dashboard/routes_overview_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/dashboard/trip_history_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/evidence/upload_evidence_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/login/driver_login_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/login/login_selection_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/login/manager_login_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/login/register_driver_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/login/register_manager_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/login/welcome_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/routes/route_detail_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/manager/manager_dashboard_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/manager/manager_evidence_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/manager/manager_reports_page.dart';
import 'package:easy_travel/features/flota365/presentation/pages/manager/manager_team_page.dart';
import 'package:easy_travel/features/flota365/presentation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget raíz del módulo Flota365.
///
/// Este widget envuelve todas las pantallas nuevas y expone un `Navigator`
/// independiente que puedes montar desde `main.dart` o cualquier otra parte
/// de tu aplicación principal.
class Flota365Module extends StatelessWidget {
  /// Repositorio que provee la información mostrada en las pantallas.
  final FleetRepository repository;

  Flota365Module({super.key, FleetRepository? repository})
      : repository = repository ?? FleetRepository.instance;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (_) => DriverSessionCubit(repository: repository),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flota365',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0C7EE8)),
            useMaterial3: true,
          ),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case Flota365Routes.welcome:
                return MaterialPageRoute(
                  builder: (_) => WelcomePage(onStart: () {
                    Navigator.of(context).pushNamed(Flota365Routes.loginSelection);
                  }),
                );
              case Flota365Routes.loginSelection:
                return MaterialPageRoute(
                  builder: (_) => LoginSelectionPage(onNavigate: (route) {
                    Navigator.of(context).pushNamed(route);
                  }),
                );
              case Flota365Routes.loginDriver:
                return MaterialPageRoute(
                  builder: (_) => DriverLoginPage(
                    onLoginSuccess: () async {
                      await context.read<DriverSessionCubit>().signInDemoDriver();
                      if (!context.mounted) return;
                      Navigator.of(context)
                          .pushReplacementNamed(Flota365Routes.dashboard);
                    },
                  ),
                );
              case Flota365Routes.loginManager:
                return MaterialPageRoute(
                  builder: (_) => ManagerLoginPage(
                    onBackToSelection: () {
                      Navigator.of(context).pop();
                    },
                    onLoginSuccess: () async {
                      await Future<void>.delayed(const Duration(milliseconds: 450));
                      if (!context.mounted) return;
                      Navigator.of(context).pushReplacementNamed(
                        Flota365Routes.managerDashboard,
                      );
                    },
                  ),
                );
              case Flota365Routes.registerDriver:
                return MaterialPageRoute(
                  builder: (_) => RegisterDriverPage(
                    onRegister: () async {
                      await context.read<DriverSessionCubit>().signInDemoDriver();
                      if (!context.mounted) return;
                      Navigator.of(context)
                          .pushReplacementNamed(Flota365Routes.dashboard);
                    },
                  ),
                );
              case Flota365Routes.registerManager:
                return MaterialPageRoute(
                  builder: (_) => RegisterManagerPage(
                    onRegister: () => Navigator.of(context).popUntil(
                      (route) => route.settings.name ==
                          Flota365Routes.loginSelection,
                    ),
                  ),
                );
              case Flota365Routes.dashboard:
                return MaterialPageRoute(
                  builder: (_) => DriverDashboardPage(
                    repository: repository,
                    onOpenRoutes: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.routes),
                    onOpenCheckIn: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.checkIn),
                    onOpenCheckOut: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.checkOut),
                    onOpenEvidence: () => Navigator.of(context)
                        .pushNamed(Flota365Routes.uploadEvidence),
                    onOpenHistory: () => Navigator.of(context)
                        .pushNamed(Flota365Routes.tripHistory),
                    onSignOut: () {
                      context.read<DriverSessionCubit>().signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Flota365Routes.welcome,
                        (route) => false,
                      );
                    },
                  ),
                );
              case Flota365Routes.checkIn:
                return MaterialPageRoute(
                  builder: (_) =>
                      CheckInPage(onCompleted: () => Navigator.of(context).pop()),
                );
              case Flota365Routes.managerDashboard:
                return MaterialPageRoute(
                  builder: (_) => ManagerDashboardPage(
                    repository: repository,
                    onOpenTeam: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.managerTeam),
                    onOpenEvidence: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.managerEvidence),
                    onOpenReports: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.managerReports),
                    onSignOut: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Flota365Routes.welcome,
                        (route) => false,
                      );
                    },
                  ),
                );
              case Flota365Routes.managerTeam:
                return MaterialPageRoute(
                  builder: (_) => ManagerTeamPage(repository: repository),
                );
              case Flota365Routes.managerEvidence:
                return MaterialPageRoute(
                  builder: (_) => ManagerEvidencePage(repository: repository),
                );
              case Flota365Routes.managerReports:
                return MaterialPageRoute(
                  builder: (_) => ManagerReportsPage(repository: repository),
                );
              case Flota365Routes.managerDashboard:
                return MaterialPageRoute(
                  builder: (_) => ManagerDashboardPage(
                    repository: repository,
                    onOpenTeam: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.managerTeam),
                    onOpenEvidence: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.managerEvidence),
                    onOpenReports: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.managerReports),
                    onSignOut: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Flota365Routes.welcome,
                        (route) => false,
                      );
                    },
                  ),
                );
              case Flota365Routes.managerTeam:
                return MaterialPageRoute(
                  builder: (_) => ManagerTeamPage(repository: repository),
                );
              case Flota365Routes.managerEvidence:
                return MaterialPageRoute(
                  builder: (_) => ManagerEvidencePage(repository: repository),
                );
              case Flota365Routes.managerReports:
                return MaterialPageRoute(
                  builder: (_) => ManagerReportsPage(repository: repository),
                );
              case Flota365Routes.managerDashboard:
                return MaterialPageRoute(
                  builder: (_) => ManagerDashboardPage(
                    repository: repository,
                    onOpenTeam: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.managerTeam),
                    onOpenEvidence: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.managerEvidence),
                    onOpenReports: () =>
                        Navigator.of(context).pushNamed(Flota365Routes.managerReports),
                    onSignOut: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Flota365Routes.welcome,
                        (route) => false,
                      );
                    },
                  ),
                );
              case Flota365Routes.managerTeam:
                return MaterialPageRoute(
                  builder: (_) => ManagerTeamPage(repository: repository),
                );
              case Flota365Routes.managerEvidence:
                return MaterialPageRoute(
                  builder: (_) => ManagerEvidencePage(repository: repository),
                );
              case Flota365Routes.managerReports:
                return MaterialPageRoute(
                  builder: (_) => ManagerReportsPage(repository: repository),
                );
              case Flota365Routes.checkOut:
                return MaterialPageRoute(
                  builder: (_) =>
                      CheckOutPage(onCompleted: () => Navigator.of(context).pop()),
                );
              case Flota365Routes.routes:
                return MaterialPageRoute(
                  builder: (_) => RoutesOverviewPage(
                    repository: repository,
                    onRouteSelected: (route) => Navigator.of(context).pushNamed(
                      Flota365Routes.routeDetail,
                      arguments: route,
                    ),
                  ),
                );
              case Flota365Routes.routeDetail:
                final route = settings.arguments as FleetRoute? ??
                    repository.getRoutesForDriver(repository.demoDriver.id).first;
                return MaterialPageRoute(
                  builder: (_) => RouteDetailPage(route: route),
                );
              case Flota365Routes.uploadEvidence:
                return MaterialPageRoute(
                  builder: (_) => UploadEvidencePage(repository: repository),
                );
              case Flota365Routes.tripHistory:
                return MaterialPageRoute(
                  builder: (_) => TripHistoryPage(repository: repository),
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(
                      child: Text('Ruta desconocida: ${settings.name}'),
                    ),
                  ),
                );
            }
          },
          initialRoute: Flota365Routes.welcome,
        ),
      ),
    );
  }
}
