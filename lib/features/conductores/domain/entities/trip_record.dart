import 'package:equatable/equatable.dart';

/// Viaje completado por el conductor.
class TripRecord extends Equatable {
  final String id;
  final String routeName;
  final String date;
  final double distanceKm;
  final double rating;
  final String feedback;

  const TripRecord({
    required this.id,
    required this.routeName,
    required this.date,
    required this.distanceKm,
    required this.rating,
    required this.feedback,
  });

  @override
  List<Object?> get props => [id, routeName, date, distanceKm, rating, feedback];
}
