import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/domain/models/driver_notification.dart';
import 'package:flutter/material.dart';

/// Lista de notificaciones para el conductor.
///
/// Utiliza el repositorio in-memory para mostrar cómo lucirá la pantalla una
/// vez que se conecte al backend real.
class DriverNotificationsPage extends StatelessWidget {
  final FleetRepository repository;

  const DriverNotificationsPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final notifications =
        repository.getNotificationsForDriver(repository.demoDriver.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: notifications.isEmpty
          ? const _EmptyNotifications()
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationTile(notification: notification);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: notifications.length,
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final DriverNotification notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = notification.isCritical
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: accentColor.withOpacity(0.12),
          child: Icon(
            notification.isCritical
                ? Icons.warning_amber_rounded
                : Icons.notifications_rounded,
            color: accentColor,
          ),
        ),
        title: Text(
          notification.title,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              notification.timeAgo,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 72,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Estás al día',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando recibas nuevas notificaciones las verás aquí.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
