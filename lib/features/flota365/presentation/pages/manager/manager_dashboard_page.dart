import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/domain/models/driver_status.dart';
import 'package:easy_travel/features/flota365/domain/models/evidence_submission.dart';
import 'package:easy_travel/features/flota365/domain/models/summary_metric.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/driver_status_tile.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/evidence_submission_card.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/summary_metric_card.dart';
import 'package:flutter/material.dart';

/// Panel principal diseñado para gestores de Flota365.
///
/// Muestra indicadores clave, alertas rápidas y accesos para gestionar el
/// equipo, revisar evidencias o consultar reportes.
class ManagerDashboardPage extends StatelessWidget {
  final FleetRepository repository;
  final VoidCallback onOpenTeam;
  final VoidCallback onOpenEvidence;
  final VoidCallback onOpenReports;
  final VoidCallback onSignOut;

  const ManagerDashboardPage({
    super.key,
    required this.repository,
    required this.onOpenTeam,
    required this.onOpenEvidence,
    required this.onOpenReports,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = repository.getManagerMetrics();
    final teamStatus = repository.getTeamStatus();
    final pending = repository.getPendingEvidenceSubmissions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de gestor'),
        actions: [
          IconButton(
            tooltip: 'Ver reportes',
            onPressed: onOpenReports,
            icon: const Icon(Icons.insights_outlined),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: onSignOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido, gestor',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text('Revisa el estado operativo de la flota en tiempo real.'),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final metric in metrics)
                        SizedBox(
                          width: MediaQuery.of(context).size.width > 720 ? 220 : double.infinity,
                          child: SummaryMetricCard(
                            metric: metric,
                            onTap: onOpenReports,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _ManagerSectionHeader(
                    title: 'Estado del equipo',
                    actionLabel: 'Ver todo',
                    onAction: onOpenTeam,
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: teamStatus.isEmpty
                        ? const Text('No hay conductores registrados por ahora.')
                        : Column(
                            children: [
                              for (final DriverStatus status in teamStatus)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: DriverStatusTile(status: status),
                                ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 32),
                  _ManagerSectionHeader(
                    title: 'Evidencias por aprobar',
                    actionLabel: 'Gestionar',
                    onAction: onOpenEvidence,
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: pending.isEmpty
                        ? const Text('Todas las evidencias están aprobadas.')
                        : Column(
                            children: [
                              for (final EvidenceSubmission submission in pending)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: EvidenceSubmissionCard(
                                    submission: submission,
                                    onApprove: onOpenEvidence,
                                    onReject: onOpenEvidence,
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onOpenTeam,
        icon: const Icon(Icons.people_alt_outlined),
        label: const Text('Gestionar equipo'),
      ),
    );
  }
}

/// Encabezado reutilizable para secciones dentro del dashboard de gestor.
class _ManagerSectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _ManagerSectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}
