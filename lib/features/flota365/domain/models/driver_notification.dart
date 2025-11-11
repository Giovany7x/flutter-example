/// Representa una notificación enviada al conductor.
///
/// Incluye la información básica para renderizar un listado con título,
/// descripción y momento en el que se generó.
class DriverNotification {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final bool isCritical;

  const DriverNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    this.isCritical = false,
  });
}
