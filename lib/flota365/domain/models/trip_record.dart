import 'package:flutter/foundation.dart';

/// Registro histórico de un viaje completado por el conductor.
/// 
/// Se usa para poblar la pantalla de historial con datos como fecha, distancia
/// recorrida y calificaciones recibidas.
@immutable
class TripRecord {
  /// Identificador único del viaje.
  final String id;

  /// Nombre de la ruta asociada a este viaje.
  final String routeName;

  /// Fecha en la que se realizó el viaje (guardada como texto para simplificar).
  final String date;

  /// Distancia total recorrida en kilómetros.
  final double distanceKm;

  /// Calificación del servicio, expresada de 0 a 5.
  final double rating;

  /// Comentarios recibidos por parte del gestor o del cliente final.
  final String feedback;

  const TripRecord({
    required this.id,
    required this.routeName,
    required this.date,
    required this.distanceKm,
    required this.rating,
    required this.feedback,
  });
}
