import 'package:flutter/foundation.dart';

/// Modelo de datos que representa a un conductor autenticado en Flota365.
/// 
/// Este objeto está pensado para mapear la respuesta del backend cuando
/// implementes tus servicios reales. Por ahora solamente contiene los
/// campos necesarios para mostrar el contenido de las pantallas.
@immutable
class DriverProfile {
  /// Identificador único del conductor en el backend.
  final String id;

  /// Nombre completo del conductor para mostrar en encabezados y tarjetas.
  final String fullName;

  /// Número de licencia o código interno del conductor.
  final String licenseNumber;

  /// Correo electrónico asociado a la cuenta del conductor.
  final String email;

  const DriverProfile({
    required this.id,
    required this.fullName,
    required this.licenseNumber,
    required this.email,
  });
}
