import 'package:easy_travel/features/flota365/domain/models/evidence_item.dart';
import 'package:flutter/foundation.dart';

/// Representa una evidencia enviada por un conductor que está pendiente de revisión.
@immutable
class EvidenceSubmission {
  /// Plantilla de evidencia asociada (odómetro, checklist, etc.).
  final EvidenceItem template;

  /// Nombre del conductor que subió la evidencia.
  final String driverName;

  /// Ruta a la que pertenece la evidencia.
  final String routeName;

  /// Fecha u hora en formato legible para mostrar en la lista.
  final String submittedAt;

  /// Indica si la evidencia ya fue validada por un gestor.
  final bool isApproved;

  const EvidenceSubmission({
    required this.template,
    required this.driverName,
    required this.routeName,
    required this.submittedAt,
    this.isApproved = false,
  });

  /// Devuelve una copia marcando la evidencia como aprobada.
  EvidenceSubmission markApproved() {
    return EvidenceSubmission(
      template: template,
      driverName: driverName,
      routeName: routeName,
      submittedAt: submittedAt,
      isApproved: true,
    );
  }
}
