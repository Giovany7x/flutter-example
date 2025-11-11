import 'package:easy_travel/features/flota365/domain/models/evidence_submission.dart';
import 'package:flutter/material.dart';

/// Tarjeta que muestra el detalle de una evidencia pendiente de aprobación.
class EvidenceSubmissionCard extends StatelessWidget {
  final EvidenceSubmission submission;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const EvidenceSubmissionCard({
    super.key,
    required this.submission,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: colorScheme.surfaceVariant.withOpacity(0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: const Icon(Icons.description_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      submission.template.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text('${submission.driverName} • ${submission.routeName}'),
                  ],
                ),
              ),
              Text(submission.submittedAt),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            submission.template.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close),
                  label: const Text('Rechazar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Aprobar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
