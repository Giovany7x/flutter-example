import 'package:flutter/foundation.dart';

/// Elemento que representa una evidencia o comprobante subido por el conductor.
/// 
/// Los elementos se muestran dentro de la pantalla de "Subir evidencias" y
/// sirven como estructura base para conectar con tu backend de almacenamiento.
@immutable
class EvidenceItem {
  /// Identificador único de la evidencia.
  final String id;

  /// Descripción corta de lo que se está subiendo (ejemplo: "Odómetro").
  final String title;

  /// Instrucciones o detalles adicionales para el conductor.
  final String description;

  /// Lista de archivos adjuntos (puede contener URLs cuando se integre el backend).
  final List<String> attachments;

  const EvidenceItem({
    required this.id,
    required this.title,
    required this.description,
    this.attachments = const [],
  });
}
