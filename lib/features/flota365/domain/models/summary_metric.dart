import 'package:flutter/foundation.dart';

/// Tendencia que describe si un indicador va al alza, baja o se mantiene.
enum MetricTrend { up, down, stable }

/// Métrica resumida que se muestra en el dashboard del gestor.
@immutable
class SummaryMetric {
  /// Identificador interno de la métrica.
  final String id;

  /// Título legible que aparece en la tarjeta.
  final String title;

  /// Valor principal que queremos destacar (porcentaje, cantidad, etc.).
  final String value;

  /// Variación porcentual respecto al periodo anterior.
  final double variation;

  /// Tendencia para elegir iconografía y color en la UI.
  final MetricTrend trend;

  /// Mensaje complementario para dar contexto al indicador.
  final String description;

  const SummaryMetric({
    required this.id,
    required this.title,
    required this.value,
    required this.variation,
    required this.trend,
    required this.description,
  });
}
