import 'package:easy_travel/features/conductores/domain/entities/check_item.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_notification.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_profile.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_route.dart';
import 'package:easy_travel/features/conductores/domain/entities/evidence_requirement.dart';
import 'package:easy_travel/features/conductores/domain/entities/trip_record.dart';

/// Fuente de datos en memoria que simula la respuesta del backend.
class DriverRepository {
  DriverRepository._();

  /// Instancia única reutilizable para mantener consistencia en los datos.
  static final DriverRepository instance = DriverRepository._();

  /// Perfil del conductor autenticado en la demostración.
  final DriverProfile demoDriver = const DriverProfile(
    id: 'driver-001',
    fullName: 'María Fernanda Pérez',
    licenseNumber: 'L-472910',
    email: 'maria.perez@flota365.com',
    avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200',
  );

  final List<DriverRoute> _routes = const [
    DriverRoute(
      id: 'route-001',
      name: 'Ruta 27 - A05',
      origin: 'Centro de distribución',
      destination: 'Parque Industrial Norte',
      schedule: '05:30 - 09:45',
      status: 'En curso',
      progress: 0.68,
      nextStop: 'Caseta de seguridad',
      eta: '09:40',
      checkpoints: [
        'Control vehicular',
        'Planta de empaquetado',
        'Caseta de seguridad',
        'Entrega final',
      ],
    ),
    DriverRoute(
      id: 'route-002',
      name: 'Ruta Express - B12',
      origin: 'Terminal de carga',
      destination: 'Zona portuaria',
      schedule: '11:00 - 14:30',
      status: 'Pendiente',
      progress: 0.0,
      nextStop: 'Control vehicular',
      eta: '11:05',
      checkpoints: [
        'Control vehicular',
        'Bodega 4',
        'Punto de inspección',
        'Zona portuaria',
      ],
    ),
  ];

  final List<CheckItem> _checkInItems = const [
    CheckItem(
      id: 'ci-01',
      title: 'Revisión visual del vehículo',
      description: 'Confirma llantas, luces y carrocería en buen estado.',
      isCritical: true,
    ),
    CheckItem(
      id: 'ci-02',
      title: 'Niveles de fluidos',
      description: 'Combustible, aceite y refrigerante dentro de rango.',
    ),
    CheckItem(
      id: 'ci-03',
      title: 'Documentación del vehículo',
      description: 'Tarjeta de propiedad y SOAT vigentes.',
    ),
    CheckItem(
      id: 'ci-04',
      title: 'Dispositivos de seguridad',
      description: 'Botiquín, extintor y triángulos de seguridad disponibles.',
    ),
  ];

  final List<CheckItem> _checkOutItems = const [
    CheckItem(
      id: 'co-01',
      title: 'Reporte de novedades',
      description: 'Incluye incidentes o daños detectados durante la ruta.',
      isCritical: true,
    ),
    CheckItem(
      id: 'co-02',
      title: 'Estado del combustible',
      description: 'Registra nivel actual y adjunta soporte si aplica.',
    ),
    CheckItem(
      id: 'co-03',
      title: 'Kilometraje final',
      description: 'Captura fotografía del odómetro al finalizar.',
    ),
    CheckItem(
      id: 'co-04',
      title: 'Entrega de llaves y equipos',
      description: 'Confirma devolución al supervisor.',
    ),
  ];

  final List<EvidenceRequirement> _evidences = const [
    EvidenceRequirement(
      id: 'evi-01',
      title: 'Foto del odómetro',
      description: 'Captura el odómetro antes de iniciar y al terminar la ruta.',
    ),
    EvidenceRequirement(
      id: 'evi-02',
      title: 'Checklist firmado',
      description: 'Adjunta el documento firmado por el supervisor.',
    ),
    EvidenceRequirement(
      id: 'evi-03',
      title: 'Comprobante de combustible',
      description: 'Sube la factura o recibo de carga de combustible.',
    ),
  ];

  final List<TripRecord> _history = const [
    TripRecord(
      id: 'trip-001',
      routeName: 'Ruta 27 - A05',
      date: '01 Jun 2024',
      distanceKm: 48.5,
      rating: 4.8,
      feedback: 'Excelente puntualidad y comunicación con el cliente.',
    ),
    TripRecord(
      id: 'trip-002',
      routeName: 'Ruta Express - B12',
      date: '29 May 2024',
      distanceKm: 36.0,
      rating: 4.5,
      feedback: 'Entrega completada sin contratiempos.',
    ),
    TripRecord(
      id: 'trip-003',
      routeName: 'Ruta 14 - Centro',
      date: '27 May 2024',
      distanceKm: 52.7,
      rating: 4.9,
      feedback: 'Cliente satisfecho y ruta completada antes de lo programado.',
    ),
  ];

  final List<DriverNotification> _notifications = const [
    DriverNotification(
      id: 'notif-001',
      title: 'Nueva ruta asignada',
      description: 'Tienes una ruta prioritaria para el turno de la tarde.',
      timeAgo: 'Hace 5 min',
      isCritical: true,
    ),
    DriverNotification(
      id: 'notif-002',
      title: 'Checklist pendiente',
      description: 'Recuerda completar el check-in antes de las 06:00 hrs.',
      timeAgo: 'Hace 20 min',
    ),
    DriverNotification(
      id: 'notif-003',
      title: 'Evidencia aprobada',
      description: 'Tu comprobante de combustible fue validado.',
      timeAgo: 'Hace 1 h',
    ),
  ];

  List<DriverRoute> getRoutesForDriver(String driverId) => _routes;

  DriverRoute getHighlightedRoute(String driverId) => _routes.first;

  List<CheckItem> getCheckInChecklist() => _checkInItems;

  List<CheckItem> getCheckOutChecklist() => _checkOutItems;

  List<EvidenceRequirement> getEvidenceRequirements() => _evidences;

  List<TripRecord> getTripHistory() => _history;

  List<DriverNotification> getNotifications() => _notifications;
}
