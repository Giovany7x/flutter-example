import 'package:easy_travel/features/flota365/domain/models/summary_metric.dart';
import 'package:flutter/material.dart';

/// Tarjeta con animación ligera que muestra un KPI del módulo de gestores.
class SummaryMetricCard extends StatelessWidget {
  final SummaryMetric metric;
  final VoidCallback? onTap;

  const SummaryMetricCard({super.key, required this.metric, this.onTap});

  Color _trendColor(BuildContext context) {
    switch (metric.trend) {
      case MetricTrend.up:
        return Theme.of(context).colorScheme.primary;
      case MetricTrend.down:
        return Theme.of(context).colorScheme.error;
      case MetricTrend.stable:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  IconData _trendIcon() {
    switch (metric.trend) {
      case MetricTrend.up:
        return Icons.arrow_upward_rounded;
      case MetricTrend.down:
        return Icons.arrow_downward_rounded;
      case MetricTrend.stable:
        return Icons.horizontal_rule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _trendColor(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              metric.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                child: child,
              ),
              child: Text(
                metric.value,
                key: ValueKey(metric.value),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(_trendIcon(), color: color, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${metric.variation.toStringAsFixed(1)}%',
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              metric.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
