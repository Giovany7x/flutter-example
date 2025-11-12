import 'package:equatable/equatable.dart';

/// Aviso o alerta dirigida al conductor.
class DriverNotification extends Equatable {
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

  @override
  List<Object?> get props => [id, title, description, timeAgo, isCritical];
}
