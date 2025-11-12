import 'package:flutter/material.dart';

class DriverNavigationDrawer extends StatelessWidget {
  final String driverName;
  final String license;
  final VoidCallback onDashboard;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;
  final VoidCallback onRoutes;
  final VoidCallback onEvidence;
  final VoidCallback onHistory;
  final VoidCallback onSupport;
  final VoidCallback onSignOut;

  const DriverNavigationDrawer({
    super.key,
    required this.driverName,
    required this.license,
    required this.onDashboard,
    required this.onCheckIn,
    required this.onCheckOut,
    required this.onRoutes,
    required this.onEvidence,
    required this.onHistory,
    required this.onSupport,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Text(
                      driverName.substring(0, 2).toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Licencia $license',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimary.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _DrawerItem(icon: Icons.dashboard_customize_rounded, label: 'Dashboard', onTap: onDashboard),
                  _DrawerItem(icon: Icons.fact_check_rounded, label: 'Check-In', onTap: onCheckIn),
                  _DrawerItem(icon: Icons.assignment_turned_in_rounded, label: 'Check-Out', onTap: onCheckOut),
                  _DrawerItem(icon: Icons.alt_route_rounded, label: 'Mis rutas', onTap: onRoutes),
                  _DrawerItem(icon: Icons.cloud_upload_rounded, label: 'Evidencias', onTap: onEvidence),
                  _DrawerItem(icon: Icons.history_rounded, label: 'Historial', onTap: onHistory),
                  _DrawerItem(icon: Icons.support_agent_rounded, label: 'Soporte', onTap: onSupport),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                  foregroundColor: theme.colorScheme.onErrorContainer,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: onSignOut,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}
