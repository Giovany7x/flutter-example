import 'package:easy_travel/features/flota365/domain/models/driver_status.dart';
import 'package:flutter/material.dart';

/// Elemento de lista que muestra el estado actual de un conductor.
class DriverStatusTile extends StatelessWidget {
  final DriverStatus status;

  const DriverStatusTile({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surfaceVariant.withOpacity(0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: status.requiresAssistance
                    ? colorScheme.errorContainer
                    : colorScheme.primaryContainer,
                child: Icon(
                  status.requiresAssistance ? Icons.warning_amber : Icons.directions_bus,
                  color: status.requiresAssistance ? colorScheme.error : colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(status.currentRoute),
                  ],
                ),
              ),
              if (status.eta != null)
                Chip(
                  label: Text('ETA ${status.eta}'),
                  backgroundColor: colorScheme.primaryContainer,
                ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: status.progress),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.flag_circle_outlined, size: 18, color: colorScheme.primary),
              const SizedBox(width: 4),
              Expanded(child: Text(status.lastCheckpoint)),
              const SizedBox(width: 8),
              Text(
                status.statusLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: status.requiresAssistance ? colorScheme.error : colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
