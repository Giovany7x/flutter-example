import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/domain/entities/evidence_requirement.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/evidence_reminder_card.dart';
import 'package:flutter/material.dart';

class EvidenceCenterPage extends StatefulWidget {
  final DriverRepository repository;
  final VoidCallback onUploadRequested;

  const EvidenceCenterPage({
    super.key,
    required this.repository,
    required this.onUploadRequested,
  });

  @override
  State<EvidenceCenterPage> createState() => _EvidenceCenterPageState();
}

class _EvidenceCenterPageState extends State<EvidenceCenterPage> {
  late Future<List<EvidenceRequirement>> _evidencesFuture;

  @override
  void initState() {
    super.initState();
    _evidencesFuture = widget.repository.getEvidenceRequirements();
  }

  void _retry() {
    setState(() {
      _evidencesFuture = widget.repository.getEvidenceRequirements(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EvidenceRequirement>>(
      future: _evidencesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          final message = snapshot.error is ApiException
              ? (snapshot.error as ApiException).message
              : 'No fue posible cargar las evidencias solicitadas.';
          return Scaffold(
            appBar: AppBar(
              title: const Text('Centro de evidencias'),
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
                    onPressed: _retry,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final evidences = snapshot.data ?? const <EvidenceRequirement>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Centro de evidencias'),
            centerTitle: false,
          ),
          body: evidences.isEmpty
              ? const Center(
                  child: Text('No tienes evidencias pendientes.'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                  itemCount: evidences.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => EvidenceReminderCard(
                    evidence: evidences[index],
                    onUpload: () => _showUploadDialog(context, evidences[index]),
                  ),
                ),
          floatingActionButton: evidences.isEmpty
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _showUploadDialog(context, evidences.first),
                  icon: const Icon(Icons.add_a_photo_rounded),
                  label: const Text('Cargar evidencia'),
                ),
        );
      },
    );
  }

  void _showUploadDialog(BuildContext context, EvidenceRequirement evidence) {
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
              Text(
                evidence.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(evidence.description),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onUploadRequested();
                },
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Abrir cámara'),
              ),
            ],
          ),
        );
      },
    );
  }
}
