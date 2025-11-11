import 'package:flutter/foundation.dart';

/// Modelo con el estado operativo de un conductor dentro de la flota.
///
/// Este modelo se usa principalmente en las pantallas para gestores, donde se
/// necesita mostrar el progreso de cada ruta y detectar posibles incidentes.
@immutable
class DriverStatus {
  /// Identificador del conductor (coincide con el backend real).
  final String id;

  /// Nombre del conductor tal y como se muestra en la interfaz.
  final String name;

  /// Ruta asignada actualmente.
  final String currentRoute;

  /// Porcentaje de avance de la ruta entre 0 y 1.
  final double progress;

  /// Mensaje corto que describe el estado ("En curso", "Retrasado", etc.).
  final String statusLabel;

  /// Último punto o checkpoint reportado por el conductor.
  final String lastCheckpoint;

  /// Hora estimada de llegada; puede ser `null` si no aplica.
  final String? eta;

  /// Bandera para resaltar si el conductor requiere atención inmediata.
  final bool requiresAssistance;

  const DriverStatus({
    required this.id,
    required this.name,
    required this.currentRoute,
    required this.progress,
    required this.statusLabel,
    required this.lastCheckpoint,
    this.eta,
    this.requiresAssistance = false,
  });
}
