import 'package:easy_travel/flota365/domain/models/evidence_item.dart';
import 'package:flutter/material.dart';

/// Tarjeta que lista las evidencias requeridas.
class EvidenceCard extends StatelessWidget {
  final EvidenceItem evidence;

  const EvidenceCard({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evidence.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(evidence.description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: evidence.attachments
                  .map((file) => Chip(label: Text(file)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
