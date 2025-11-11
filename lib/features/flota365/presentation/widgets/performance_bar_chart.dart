import 'package:easy_travel/features/flota365/domain/models/performance_snapshot.dart';
import 'package:flutter/material.dart';

/// Grafica básica basada en barras usando contenedores animados.
class PerformanceBarChart extends StatelessWidget {
  final List<PerformanceSnapshot> data;

  const PerformanceBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = (constraints.maxWidth - 32) / data.length;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final snapshot in data)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 450),
                        curve: Curves.easeOutCubic,
                        height: constraints.maxHeight * snapshot.compliance,
                        width: barWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.8),
                              colorScheme.primary,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${(snapshot.compliance * 100).round()}%',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(snapshot.period, style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
