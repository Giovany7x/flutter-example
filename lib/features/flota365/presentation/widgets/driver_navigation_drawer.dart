import 'package:flutter/material.dart';

/// Menú lateral con accesos rápidos para el flujo del conductor.
///
/// Este drawer replica el diseño solicitado y conecta cada entrada con
/// las acciones disponibles dentro del dashboard del conductor.
class DriverNavigationDrawer extends StatelessWidget {
  final String driverName;
  final String driverLicense;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenDashboard;
  final VoidCallback onOpenCheckIn;
  final VoidCallback onOpenCheckOut;
  final VoidCallback onOpenRoutes;
  final VoidCallback onOpenEvidence;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenSupport;
  final VoidCallback onSignOut;

  const DriverNavigationDrawer({
    super.key,
    required this.driverName,
    required this.driverLicense,
    required this.onOpenProfile,
    required this.onOpenDashboard,
    required this.onOpenCheckIn,
    required this.onOpenCheckOut,
    required this.onOpenRoutes,
    required this.onOpenEvidence,
    required this.onOpenHistory,
    required this.onOpenSupport,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerTile(
                    icon: Icons.person_outline,
                    label: 'Usuario',
                    onTap: onOpenProfile,
                  ),
                  _buildSectionTitle(context, 'Principal'),
                  _DrawerTile(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    onTap: onOpenDashboard,
                  ),
                  _DrawerTile(
                    icon: Icons.directions_bus,
                    label: 'Conductores',
                    onTap: onOpenRoutes,
                  ),
                  _DrawerTile(
                    icon: Icons.playlist_add_check_circle,
                    label: 'Check-In',
                    onTap: onOpenCheckIn,
                  ),
                  _DrawerTile(
                    icon: Icons.assignment_turned_in_outlined,
                    label: 'Check-Out',
                    onTap: onOpenCheckOut,
                  ),
                  _DrawerTile(
                    icon: Icons.alt_route,
                    label: 'Gestión de flota',
                    onTap: onOpenRoutes,
                  ),
                  _buildSectionTitle(context, 'Seguimiento'),
                  _DrawerTile(
                    icon: Icons.map_outlined,
                    label: 'Monitoreo',
                    onTap: () => _showComingSoon(context, 'Monitoreo'),
                  ),
                  _DrawerTile(
                    icon: Icons.notifications_none,
                    label: 'Notificaciones',
                    onTap: () => _showComingSoon(context, 'Notificaciones'),
                  ),
                  _DrawerTile(
                    icon: Icons.receipt_long,
                    label: 'Reportes',
                    onTap: onOpenHistory,
                  ),
                  _DrawerTile(
                    icon: Icons.cloud_upload_outlined,
                    label: 'Subir evidencias',
                    onTap: onOpenEvidence,
                  ),
                  _buildSectionTitle(context, 'Soporte'),
                  _DrawerTile(
                    icon: Icons.support_agent,
                    label: 'Servicio al cliente',
                    onTap: onOpenSupport,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ElevatedButton.icon(
                onPressed: onSignOut,
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Encabezado con los datos básicos del conductor.
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
            child: Icon(
              Icons.person,
              size: 36,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            driverName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Licencia $driverLicense',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  /// Cabecera secundaria para agrupar enlaces relacionados.
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text('$feature estará disponible próximamente.'),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    );
  }
}
