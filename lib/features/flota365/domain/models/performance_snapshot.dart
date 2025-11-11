import 'package:flutter/foundation.dart';

/// Resumen semanal o mensual con indicadores clave para los gestores.
@immutable
class PerformanceSnapshot {
  /// Periodo evaluado ("Semana 22", "Mayo 2024", etc.).
  final String period;

  /// Porcentaje de cumplimiento de rutas en el periodo.
  final double compliance;

  /// Porcentaje de incidencias reportadas.
  final double incidentsRate;

  /// Calificación promedio otorgada por los clientes.
  final double averageRating;

  const PerformanceSnapshot({
    required this.period,
    required this.compliance,
    required this.incidentsRate,
    required this.averageRating,
  });
}
