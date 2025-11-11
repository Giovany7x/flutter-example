import 'package:easy_travel/features/flota365/domain/models/driver_profile.dart';
import 'package:easy_travel/features/flota365/domain/models/driver_notification.dart';
import 'package:easy_travel/features/flota365/domain/models/driver_status.dart';
import 'package:easy_travel/features/flota365/domain/models/evidence_item.dart';
import 'package:easy_travel/features/flota365/domain/models/evidence_submission.dart';
import 'package:easy_travel/features/flota365/domain/models/fleet_route.dart';
import 'package:easy_travel/features/flota365/domain/models/performance_snapshot.dart';
import 'package:easy_travel/features/flota365/domain/models/summary_metric.dart';
import 'package:easy_travel/features/flota365/domain/models/trip_record.dart';

/// Repositorio en memoria que imita la respuesta del backend.
///
/// Implementa métodos simples que retornan listas con datos estáticos para
/// alimentar las interfaces mientras conectas el módulo con tus API reales.
class FleetRepository {
  FleetRepository._internal();

  /// Instancia única del repositorio para reutilizar los mismos datos.
  static final FleetRepository instance = FleetRepository._internal();

  /// Datos de ejemplo de un conductor autenticado.
  final DriverProfile demoDriver = const DriverProfile(
    id: 'driver-001',
    fullName: 'María Fernanda Pérez',
    licenseNumber: 'L-472910',
    email: 'maria.perez@flota365.com',
  );

  /// Colección de rutas asignadas al conductor.
  final List<FleetRoute> _routes = const [
    FleetRoute(
      id: 'route-001',
      name: 'Ruta 27 - A05',
      origin: 'Centro de distribución',
      destination: 'Parque Industrial Norte',
      stops: [
        'Control vehicular',
        'Planta de empaquetado',
        'Caseta de seguridad',
      ],
      schedule: '05:30 - 09:45',
      status: 'En curso',
      completion: 0.65,
      notes: 'Verificar nivel de combustible antes de salir.',
    ),
    FleetRoute(
      id: 'route-002',
      name: 'Ruta Express - B12',
      origin: 'Terminal de carga',
      destination: 'Zona portuaria',
      stops: [
        'Caseta principal',
        'Bodega 4',
        'Punto de inspección',
      ],
      schedule: '11:00 - 14:30',
      status: 'Pendiente',
      completion: 0.0,
      notes: 'Ruta prioritaria para entregas urgentes.',
    ),
  ];

  /// Colección estática de evidencias requeridas.
  final List<EvidenceItem> _evidences = [
    const EvidenceItem(
      id: 'evidence-odometer',
      title: 'Foto del odómetro',
      description: 'Captura el odómetro antes de iniciar la ruta.',
    ),
    const EvidenceItem(
      id: 'evidence-checklist',
      title: 'Checklist firmado',
      description: 'Adjunta el documento firmado por el supervisor.',
    ),
    const EvidenceItem(
      id: 'evidence-fuel',
      title: 'Comprobante de combustible',
      description: 'Sube la factura de carga de combustible.',
    ),
  ];

  /// Historial de viajes completados por el conductor.
  final List<TripRecord> _history = const [
    TripRecord(
      id: 'trip-001',
      routeName: 'Ruta 27 - A05',
      date: '01 Jun 2024',
      distanceKm: 48.5,
      rating: 4.8,
      feedback: 'Excelente puntualidad y comunicación.',
    ),
    TripRecord(
      id: 'trip-002',
      routeName: 'Ruta Express - B12',
      date: '29 May 2024',
      distanceKm: 36.0,
      rating: 4.5,
      feedback: 'Entregas completadas sin contratiempos.',
    ),
  ];

  /// Notificaciones que el backend entregaría al conductor.
  final List<DriverNotification> _notifications = const [
    DriverNotification(
      id: 'notification-001',
      title: 'Nueva ruta asignada',
      description: 'Tienes una ruta prioritaria para el turno de la tarde.',
      timeAgo: 'Hace 5 min',
      isCritical: true,
    ),
    DriverNotification(
      id: 'notification-002',
      title: 'Checklist pendiente',
      description: 'Recuerda completar el check-in antes de las 06:00 hrs.',
      timeAgo: 'Hace 20 min',
    ),
    DriverNotification(
      id: 'notification-003',
      title: 'Evidencia revisada',
      description: 'Tu comprobante de combustible fue aprobado.',
      timeAgo: 'Hace 1 h',
    ),
  ];

  /// Devuelve la lista de rutas de un conductor.
  List<FleetRoute> getRoutesForDriver(String driverId) => _routes;

  /// Devuelve las notificaciones más recientes del conductor.
  List<DriverNotification> getNotificationsForDriver(String driverId) =>
      _notifications;

  /// Estado en tiempo real de los conductores (vista del gestor).
  final List<DriverStatus> _teamStatus = const [
    DriverStatus(
      id: 'driver-001',
      name: 'María F. Pérez',
      currentRoute: 'Ruta 27 - A05',
      progress: 0.72,
      statusLabel: 'En curso',
      lastCheckpoint: 'Caseta de seguridad',
      eta: '09:40',
    ),
    DriverStatus(
      id: 'driver-002',
      name: 'Luis Hernández',
      currentRoute: 'Ruta Express - B12',
      progress: 0.18,
      statusLabel: 'Retraso leve',
      lastCheckpoint: 'Terminal de carga',
      eta: '12:05',
      requiresAssistance: true,
    ),
    DriverStatus(
      id: 'driver-003',
      name: 'Andrea Gómez',
      currentRoute: 'Ruta 14 - Centro',
      progress: 1.0,
      statusLabel: 'Completada',
      lastCheckpoint: 'Entrega final registrada',
    ),
  ];

  /// Indicadores resumidos para el dashboard de gestores.
  final List<SummaryMetric> _managerMetrics = const [
    SummaryMetric(
      id: 'kpi-compliance',
      title: 'Cumplimiento',
      value: '92%',
      variation: 4.2,
      trend: MetricTrend.up,
      description: 'Rutas completadas sin incidentes en la última semana.',
    ),
    SummaryMetric(
      id: 'kpi-incidents',
      title: 'Incidencias',
      value: '3',
      variation: -1.0,
      trend: MetricTrend.down,
      description: 'Reportes críticos recibidos durante la operación.',
    ),
    SummaryMetric(
      id: 'kpi-satisfaction',
      title: 'Satisfacción',
      value: '4.7/5',
      variation: 0.3,
      trend: MetricTrend.up,
      description: 'Promedio de evaluación de clientes y destinatarios.',
    ),
  ];

  /// Rendimiento semanal para mostrar en gráficas simples.
  final List<PerformanceSnapshot> _performanceHistory = const [
    PerformanceSnapshot(
      period: 'Semana 21',
      compliance: 0.87,
      incidentsRate: 0.06,
      averageRating: 4.5,
    ),
    PerformanceSnapshot(
      period: 'Semana 22',
      compliance: 0.9,
      incidentsRate: 0.05,
      averageRating: 4.6,
    ),
    PerformanceSnapshot(
      period: 'Semana 23',
      compliance: 0.92,
      incidentsRate: 0.04,
      averageRating: 4.7,
    ),
  ];

  /// Evidencias enviadas que aún esperan revisión por parte de un gestor.
  final List<EvidenceSubmission> _pendingSubmissions = [
    EvidenceSubmission(
      template: const EvidenceItem(
        id: 'evidence-odometer',
        title: 'Foto del odómetro',
        description: 'Lectura previa a la salida.',
      ),
      driverName: 'María F. Pérez',
      routeName: 'Ruta 27 - A05',
      submittedAt: 'Hoy • 05:20',
    ),
    EvidenceSubmission(
      template: const EvidenceItem(
        id: 'evidence-delivery',
        title: 'Entrega firmada',
        description: 'Documento con firma digital del cliente.',
      ),
      driverName: 'Luis Hernández',
      routeName: 'Ruta Express - B12',
      submittedAt: 'Ayer • 18:40',
    ),
  ];

  /// Busca una ruta específica por su identificador.
  FleetRoute? findRouteById(String id) =>
      _routes.firstWhere((route) => route.id == id, orElse: () => const FleetRoute(
            id: 'route-not-found',
            name: 'Ruta no encontrada',
            origin: 'Desconocido',
            destination: 'Desconocido',
            stops: const [],
            schedule: '---',
            status: 'Sin datos',
            completion: 0,
            notes: 'Revisa la sincronización con el backend.',
          ));

  /// Retorna las evidencias pendientes de subir.
  List<EvidenceItem> getPendingEvidences(String driverId) =>
      List<EvidenceItem>.unmodifiable(_evidences);

  /// Registra una nueva evidencia en memoria.
  void uploadEvidence(String driverId, EvidenceItem evidence) {
    // En el backend real aquí harías la llamada HTTP o gRPC.
    _evidences.add(evidence);
  }

  /// Lista los viajes finalizados para mostrar en el historial.
  List<TripRecord> getTripHistory(String driverId) => _history;

  /// Devuelve el estado del equipo para la vista del gestor.
  List<DriverStatus> getTeamStatus() => List<DriverStatus>.unmodifiable(_teamStatus);

  /// Devuelve los indicadores resumidos del gestor.
  List<SummaryMetric> getManagerMetrics() =>
      List<SummaryMetric>.unmodifiable(_managerMetrics);

  /// Histórico de rendimiento para alimentar gráficas sencillas.
  List<PerformanceSnapshot> getPerformanceHistory() =>
      List<PerformanceSnapshot>.unmodifiable(_performanceHistory);

  /// Evidencias subidas que aún no han sido aprobadas.
  List<EvidenceSubmission> getPendingEvidenceSubmissions() =>
      List<EvidenceSubmission>.unmodifiable(_pendingSubmissions);
}
