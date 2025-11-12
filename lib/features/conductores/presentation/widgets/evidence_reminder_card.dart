import 'package:easy_travel/features/conductores/domain/entities/evidence_requirement.dart';
import 'package:flutter/material.dart';

class EvidenceReminderCard extends StatelessWidget {
  final EvidenceRequirement evidence;
  final VoidCallback onUpload;

  const EvidenceReminderCard({super.key, required this.evidence, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onUpload,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2994A).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Color(0xFFF2994A)),
                  ),
                  const Spacer(),
                  if (evidence.isMandatory)
                    const Icon(Icons.error_outline, color: Color(0xFFE74C3C)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                evidence.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                evidence.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: FilledButton.tonalIcon(
                  onPressed: onUpload,
                  icon: const Icon(Icons.cloud_upload_rounded),
                  label: const Text('Subir'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
