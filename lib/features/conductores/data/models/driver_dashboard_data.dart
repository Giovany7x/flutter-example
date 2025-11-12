import 'package:easy_travel/features/conductores/domain/entities/check_item.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_notification.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_route.dart';
import 'package:easy_travel/features/conductores/domain/entities/evidence_requirement.dart';
import 'package:easy_travel/features/conductores/domain/entities/trip_record.dart';

class DriverDashboardData {
  final List<DriverRoute> routes;
  final List<CheckItem> checkInChecklist;
  final List<CheckItem> checkOutChecklist;
  final List<EvidenceRequirement> evidences;
  final List<TripRecord> tripHistory;
  final List<DriverNotification> notifications;

  const DriverDashboardData({
    required this.routes,
    required this.checkInChecklist,
    required this.checkOutChecklist,
    required this.evidences,
    required this.tripHistory,
    required this.notifications,
  });

  factory DriverDashboardData.fromJson(Map<String, dynamic> json) {
    List<T> _mapList<T>(dynamic value, T Function(Map<String, dynamic>) parser) {
      if (value is List) {
        return value
            .whereType<Map<String, dynamic>>()
            .map(parser)
            .toList(growable: false);
      }
      return const [];
    }

    return DriverDashboardData(
      routes: _mapList(json['routes'] ?? json['assignedRoutes'],
          (data) => DriverRoute.fromJson(data)),
      checkInChecklist: _mapList(json['checkInChecklist'] ?? json['checkIn'],
          (data) => CheckItem.fromJson(data)),
      checkOutChecklist: _mapList(json['checkOutChecklist'] ?? json['checkOut'],
          (data) => CheckItem.fromJson(data)),
      evidences: _mapList(json['evidences'] ?? json['evidenceRequirements'],
          (data) => EvidenceRequirement.fromJson(data)),
      tripHistory: _mapList(json['tripHistory'] ?? json['history'],
          (data) => TripRecord.fromJson(data)),
      notifications: _mapList(json['notifications'] ?? json['alerts'],
          (data) => DriverNotification.fromJson(data)),
    );
  }

  DriverRoute? get highlightedRoute {
    if (routes.isEmpty) {
      return null;
    }
    return routes.firstWhere(
      (route) => route.status.toLowerCase().contains('curso') ||
          route.status.toLowerCase().contains('activo'),
      orElse: () => routes.first,
    );
  }
}
