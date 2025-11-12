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

  factory DriverNotification.fromJson(Map<String, dynamic> json) => DriverNotification(
        id: json['id']?.toString() ?? json['notificationId']?.toString() ?? '',
        title: json['title'] as String? ?? json['subject'] as String? ?? 'Notificación',
        description: json['description'] as String? ?? json['message'] as String? ?? '',
        timeAgo: json['timeAgo'] as String? ?? json['timestamp'] as String? ?? '',
        isCritical: json['isCritical'] as bool? ?? json['critical'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'timeAgo': timeAgo,
        'isCritical': isCritical,
      };

  @override
  List<Object?> get props => [id, title, description, timeAgo, isCritical];
}
