import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/domain/models/driver_status.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/driver_status_tile.dart';
import 'package:flutter/material.dart';

/// Listado completo de conductores con filtros rápidos para gestores.
class ManagerTeamPage extends StatefulWidget {
  final FleetRepository repository;

  const ManagerTeamPage({super.key, required this.repository});

  @override
  State<ManagerTeamPage> createState() => _ManagerTeamPageState();
}

class _ManagerTeamPageState extends State<ManagerTeamPage> {
  bool _showOnlyAlerts = false;

  @override
  Widget build(BuildContext context) {
    final statuses = widget.repository.getTeamStatus();
    final filtered = _showOnlyAlerts
        ? statuses.where((status) => status.requiresAssistance).toList()
        : statuses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipo operativo'),
        actions: [
          IconButton(
            tooltip: 'Alternar alertas',
            onPressed: () => setState(() => _showOnlyAlerts = !_showOnlyAlerts),
            icon: Icon(
              _showOnlyAlerts ? Icons.warning_amber : Icons.visibility_outlined,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Todos')),
                ButtonSegment(value: true, label: Text('Solo alertas')),
              ],
              selected: {_showOnlyAlerts},
              onSelectionChanged: (value) => setState(() => _showOnlyAlerts = value.first),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          _showOnlyAlerts
                              ? 'No hay alertas activas en este momento.'
                              : 'Registra conductores para comenzar.',
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) => DriverStatusTile(
                          status: filtered[index],
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: filtered.length,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
