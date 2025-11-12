import 'package:easy_travel/features/conductores/domain/entities/evidence_requirement.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/evidence_reminder_card.dart';
import 'package:flutter/material.dart';

class EvidenceCenterPage extends StatelessWidget {
  final List<EvidenceRequirement> evidences;
  final VoidCallback onUploadRequested;

  const EvidenceCenterPage({
    super.key,
    required this.evidences,
    required this.onUploadRequested,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de evidencias'),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        itemCount: evidences.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) => EvidenceReminderCard(
          evidence: evidences[index],
          onUpload: () => _showUploadDialog(context, evidences[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDialog(context, evidences.first),
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('Cargar evidencia'),
      ),
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
                  onUploadRequested();
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
