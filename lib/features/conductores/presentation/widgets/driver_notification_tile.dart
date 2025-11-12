import 'package:easy_travel/features/conductores/domain/entities/driver_notification.dart';
import 'package:flutter/material.dart';

class DriverNotificationTile extends StatelessWidget {
  final DriverNotification notification;

  const DriverNotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: notification.isCritical
                  ? const Color(0xFFFFEAEA)
                  : const Color(0xFFE8F4FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              notification.isCritical ? Icons.warning_rounded : Icons.notifications_active_rounded,
              color: notification.isCritical ? const Color(0xFFE74C3C) : const Color(0xFF1D75D3),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.timeAgo,
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
