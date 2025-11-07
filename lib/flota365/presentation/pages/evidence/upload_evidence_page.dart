import 'package:easy_travel/flota365/data/fleet_repository.dart';
import 'package:easy_travel/flota365/presentation/widgets/evidence_card.dart';
import 'package:flutter/material.dart';

/// Pantalla para subir evidencias fotográficas o documentos.
class UploadEvidencePage extends StatelessWidget {
  final FleetRepository repository;

  const UploadEvidencePage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final evidences = repository.getPendingEvidences(repository.demoDriver.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Subir evidencias')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemBuilder: (context, index) => EvidenceCard(evidence: evidences[index]),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: evidences.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Abrir selector de archivos e integrar con backend.'),
            ),
          );
        },
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Agregar evidencia'),
      ),
    );
  }
}
