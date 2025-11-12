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

  factory TripRecord.fromJson(Map<String, dynamic> json) {
    final distance = json['distanceKm'] ?? json['distance'] ?? 0;
    final rating = json['rating'] ?? json['score'] ?? 0;

    return TripRecord(
      id: json['id']?.toString() ?? json['tripId']?.toString() ?? '',
      routeName: json['routeName'] as String? ?? json['route'] as String? ?? 'Ruta',
      date: json['date'] as String? ?? json['completedAt'] as String? ?? '',
      distanceKm: distance is int ? distance.toDouble() : (distance as num?)?.toDouble() ?? 0,
      rating: rating is int ? rating.toDouble() : (rating as num?)?.toDouble() ?? 0,
      feedback: json['feedback'] as String? ?? json['comments'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'routeName': routeName,
        'date': date,
        'distanceKm': distanceKm,
        'rating': rating,
        'feedback': feedback,
      };

  @override
  List<Object?> get props => [id, routeName, date, distanceKm, rating, feedback];
}
