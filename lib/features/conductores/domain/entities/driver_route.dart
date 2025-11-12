import 'package:equatable/equatable.dart';

/// Ruta asignada al conductor para el día.
class DriverRoute extends Equatable {
  final String id;
  final String name;
  final String origin;
  final String destination;
  final String schedule;
  final String status;
  final double progress;
  final String nextStop;
  final String eta;
  final List<String> checkpoints;

  const DriverRoute({
    required this.id,
    required this.name,
    required this.origin,
    required this.destination,
    required this.schedule,
    required this.status,
    required this.progress,
    required this.nextStop,
    required this.eta,
    required this.checkpoints,
  });

  factory DriverRoute.fromJson(Map<String, dynamic> json) {
    final progressValue = json['progress'];
    final checkpointsJson = json['checkpoints'] ?? json['stops'] ?? [];

    return DriverRoute(
      id: json['id']?.toString() ?? json['routeId']?.toString() ?? '',
      name: json['name'] as String? ?? json['routeName'] as String? ?? 'Ruta',
      origin: json['origin'] as String? ?? json['startPoint'] as String? ?? 'Origen no disponible',
      destination:
          json['destination'] as String? ?? json['endPoint'] as String? ?? 'Destino no disponible',
      schedule: json['schedule'] as String? ?? json['timeWindow'] as String? ?? '',
      status: json['status'] as String? ?? 'Pendiente',
      progress: progressValue is int
          ? progressValue.toDouble()
          : (progressValue as num?)?.toDouble() ?? 0.0,
      nextStop: json['nextStop'] as String? ?? json['upcomingCheckpoint'] as String? ?? 'Por confirmar',
      eta: json['eta'] as String? ?? json['estimatedArrival'] as String? ?? '--:--',
      checkpoints: checkpointsJson is List
          ? checkpointsJson.map((item) => item.toString()).toList()
          : const <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'origin': origin,
        'destination': destination,
        'schedule': schedule,
        'status': status,
        'progress': progress,
        'nextStop': nextStop,
        'eta': eta,
        'checkpoints': checkpoints,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        origin,
        destination,
        schedule,
        status,
        progress,
        nextStop,
        eta,
        checkpoints,
      ];
}
