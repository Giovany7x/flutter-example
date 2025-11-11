import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/domain/models/performance_snapshot.dart';
import 'package:easy_travel/features/flota365/domain/models/summary_metric.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/performance_bar_chart.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/summary_metric_card.dart';
import 'package:flutter/material.dart';

/// Vista de reportes y métricas históricas para gestores.
class ManagerReportsPage extends StatefulWidget {
  final FleetRepository repository;

  const ManagerReportsPage({super.key, required this.repository});

  @override
  State<ManagerReportsPage> createState() => _ManagerReportsPageState();
}

class _ManagerReportsPageState extends State<ManagerReportsPage> {
  bool _showTable = false;

  @override
  Widget build(BuildContext context) {
    final metrics = widget.repository.getManagerMetrics();
    final performance = widget.repository.getPerformanceHistory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes y métricas'),
        actions: [
          IconButton(
            tooltip: 'Alternar vista',
            onPressed: () => setState(() => _showTable = !_showTable),
            icon: Icon(_showTable ? Icons.bar_chart : Icons.table_chart),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Resumen ejecutivo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final SummaryMetric metric in metrics)
                SizedBox(
                  width: MediaQuery.of(context).size.width > 700 ? 220 : double.infinity,
                  child: SummaryMetricCard(metric: metric),
                ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Cumplimiento semanal',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PerformanceBarChart(data: performance),
          ),
          const SizedBox(height: 32),
          Text(
            'Detalle de indicadores',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showTable ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: _PerformanceChips(performance: performance),
            secondChild: _PerformanceDataTable(performance: performance),
          ),
        ],
      ),
    );
  }
}

/// Representación compacta de cada snapshot utilizando chips e iconos.
class _PerformanceChips extends StatelessWidget {
  final List<PerformanceSnapshot> performance;

  const _PerformanceChips({required this.performance});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final snapshot in performance)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.surfaceVariant.withOpacity(0.6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.period,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.verified_outlined),
                    const SizedBox(width: 4),
                    Text('${(snapshot.compliance * 100).round()}% cumplimiento'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded),
                    const SizedBox(width: 4),
                    Text('${(snapshot.incidentsRate * 100).round()}% incidencias'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.thumb_up_alt_outlined),
                    const SizedBox(width: 4),
                    Text('${snapshot.averageRating.toStringAsFixed(1)} calificación'),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Tabla detallada pensada para exportes o revisión minuciosa.
class _PerformanceDataTable extends StatelessWidget {
  final List<PerformanceSnapshot> performance;

  const _PerformanceDataTable({required this.performance});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Periodo')),
        DataColumn(label: Text('Cumplimiento')),
        DataColumn(label: Text('Incidencias')),
        DataColumn(label: Text('Calificación')),
      ],
      rows: [
        for (final snapshot in performance)
          DataRow(
            cells: [
              DataCell(Text(snapshot.period)),
              DataCell(Text('${(snapshot.compliance * 100).toStringAsFixed(1)}%')),
              DataCell(Text('${(snapshot.incidentsRate * 100).toStringAsFixed(1)}%')),
              DataCell(Text(snapshot.averageRating.toStringAsFixed(1))),
            ],
          ),
      ],
    );
  }
}
