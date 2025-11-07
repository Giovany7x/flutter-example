import 'package:easy_travel/features/flota365/domain/models/driver_profile.dart';
import 'package:easy_travel/features/flota365/domain/models/evidence_item.dart';
import 'package:easy_travel/features/flota365/domain/models/fleet_route.dart';
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

  /// Devuelve la lista de rutas de un conductor.
  List<FleetRoute> getRoutesForDriver(String driverId) => _routes;

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
}
