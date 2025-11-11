import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/domain/models/evidence_submission.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/evidence_submission_card.dart';
import 'package:flutter/material.dart';

/// Pantalla para revisar y aprobar evidencias enviadas por los conductores.
class ManagerEvidencePage extends StatefulWidget {
  final FleetRepository repository;

  const ManagerEvidencePage({super.key, required this.repository});

  @override
  State<ManagerEvidencePage> createState() => _ManagerEvidencePageState();
}

class _ManagerEvidencePageState extends State<ManagerEvidencePage> {
  late List<EvidenceSubmission> _pending;

  @override
  void initState() {
    super.initState();
    _pending = widget.repository.getPendingEvidenceSubmissions();
  }

  void _approve(EvidenceSubmission submission) {
    setState(() {
      _pending = _pending
          .map((item) => item == submission ? item.markApproved() : item)
          .toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Evidencia "${submission.template.title}" aprobada.')),
    );
  }

  void _reject(EvidenceSubmission submission) {
    setState(() {
      _pending = _pending.where((item) => item != submission).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Evidencia de ${submission.driverName} rechazada.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemsToShow = _pending.where((item) => !item.isApproved).toList();
    final approved = _pending.where((item) => item.isApproved).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Revisión de evidencias')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pendientes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: itemsToShow.isEmpty
                    ? const Center(child: Text('No hay evidencias pendientes.'))
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final submission = itemsToShow[index];
                          return EvidenceSubmissionCard(
                            submission: submission,
                            onApprove: () => _approve(submission),
                            onReject: () => _reject(submission),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: itemsToShow.length,
                      ),
              ),
            ),
            const SizedBox(height: 24),
            ExpansionTile(
              title: const Text('Evidencias aprobadas recientemente'),
              children: approved.isEmpty
                  ? [
                      const ListTile(
                        title: Text('Aún no apruebas ninguna evidencia.'),
                      ),
                    ]
                  : approved
                      .map(
                        (submission) => ListTile(
                          leading: const Icon(Icons.check_circle_outline),
                          title: Text(submission.template.title),
                          subtitle: Text('${submission.driverName} • ${submission.routeName}'),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
