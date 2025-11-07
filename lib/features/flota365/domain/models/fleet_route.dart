import 'package:flutter/foundation.dart';

/// Entidad que describe una ruta asignada a un conductor.
/// 
/// Incluye toda la información que se muestra en las pantallas de "Mis rutas",
/// detalle de ruta y tarjetas de progreso.
@immutable
class FleetRoute {
  /// Identificador único de la ruta.
  final String id;

  /// Nombre comercial de la ruta (por ejemplo "Ruta 27 - A05").
  final String name;

  /// Punto de origen donde comienza el recorrido.
  final String origin;

  /// Punto de destino donde finaliza el recorrido.
  final String destination;

  /// Lista de puntos intermedios relevantes para el conductor.
  final List<String> stops;

  /// Horario sugerido para completar la ruta.
  final String schedule;

  /// Estado actual de la ruta (ejemplo: "En curso", "Pendiente").
  final String status;

  /// Porcentaje de progreso expresado como valor de 0.0 a 1.0.
  final double completion;

  /// Información corta que se puede mostrar como subtítulo o notas.
  final String notes;

  const FleetRoute({
    required this.id,
    required this.name,
    required this.origin,
    required this.destination,
    required this.stops,
    required this.schedule,
    required this.status,
    required this.completion,
    required this.notes,
  });
}
