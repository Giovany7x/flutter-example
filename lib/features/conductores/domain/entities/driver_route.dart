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
