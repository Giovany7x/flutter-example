import 'dart:convert';

import 'package:easy_travel/core/constants/api_constants.dart';
import 'package:easy_travel/features/conductores/data/models/driver_dashboard_data.dart';
import 'package:easy_travel/features/conductores/domain/entities/check_item.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_notification.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_profile.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_route.dart';
import 'package:easy_travel/features/conductores/domain/entities/evidence_requirement.dart';
import 'package:easy_travel/features/conductores/domain/entities/trip_record.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'ApiException(statusCode: ${statusCode ?? 'unknown'}, message: $message)';
}

class DriverRepository {
  DriverRepository._({http.Client? client}) : _client = client ?? http.Client();

  static final DriverRepository instance = DriverRepository._();

  final http.Client _client;
  String? _authToken;
  DriverProfile? _driver;
  DriverDashboardData? _dashboardCache;

  DriverProfile? get currentDriver => _driver;

  String? get authToken => _authToken;

  Future<DriverProfile> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      _buildUri(ApiConstants.loginEndpoint),
      headers: _defaultHeaders(includeAuth: false),
      body: jsonEncode({'email': email, 'password': password}),
    );

    final payload = _processResponse(response);
    final driver = _extractDriver(payload);

    _driver = driver;
    _authToken = _extractToken(payload, fallback: _authToken);
    _dashboardCache = null;

    return driver;
  }

  Future<DriverProfile> register({
    required String fullName,
    required String email,
    required String password,
    required String licenseNumber,
  }) async {
    final response = await _client.post(
      _buildUri(ApiConstants.registerEndpoint),
      headers: _defaultHeaders(includeAuth: false),
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'licenseNumber': licenseNumber,
      }),
    );

    final payload = _processResponse(response);
    final driver = _extractDriver(payload);

    _driver = driver;
    _authToken = _extractToken(payload, fallback: _authToken);
    _dashboardCache = null;

    return driver;
  }

  Future<DriverProfile> refreshProfile({String? driverId}) async {
    final id = driverId ?? _driver?.id;
    if (id == null) {
      throw const ApiException('No hay conductor autenticado para consultar.');
    }

    final response = await _client.get(
      _buildUri(ApiConstants.driverProfileEndpoint, pathParameters: {'driverId': id}),
      headers: _defaultHeaders(),
    );

    final payload = _processResponse(response);
    final driver = _extractDriver(payload);

    _driver = driver;
    return driver;
  }

  Future<void> signOut() async {
    _authToken = null;
    _driver = null;
    _dashboardCache = null;
  }

  Future<DriverDashboardData> fetchDashboard({
    String? driverId,
    bool forceRefresh = false,
  }) async {
    final id = driverId ?? _driver?.id;
    if (id == null) {
      throw const ApiException('No se encontró un identificador de conductor.');
    }

    if (!forceRefresh && _dashboardCache != null) {
      return _dashboardCache!;
    }

    final response = await _client.get(
      _buildUri(ApiConstants.driverDashboardEndpoint, pathParameters: {'driverId': id}),
      headers: _defaultHeaders(),
    );

    final payload = _processResponse(response);
    final dashboardJson = _unwrapDashboard(payload);

    final data = DriverDashboardData.fromJson(dashboardJson);
    _dashboardCache = data;
    return data;
  }

  Future<List<DriverRoute>> getRoutesForDriver({
    String? driverId,
    bool forceRefresh = false,
  }) async {
    final dashboard = await fetchDashboard(
      driverId: driverId,
      forceRefresh: forceRefresh,
    );
    return dashboard.routes;
  }

  Future<DriverRoute?> getHighlightedRoute({
    String? driverId,
    bool forceRefresh = false,
  }) async {
    final dashboard = await fetchDashboard(
      driverId: driverId,
      forceRefresh: forceRefresh,
    );
    return dashboard.highlightedRoute;
  }

  Future<List<CheckItem>> getCheckInChecklist({bool forceRefresh = false}) async {
    final dashboard = await fetchDashboard(forceRefresh: forceRefresh);
    return dashboard.checkInChecklist;
  }

  Future<List<CheckItem>> getCheckOutChecklist({bool forceRefresh = false}) async {
    final dashboard = await fetchDashboard(forceRefresh: forceRefresh);
    return dashboard.checkOutChecklist;
  }

  Future<List<EvidenceRequirement>> getEvidenceRequirements({
    bool forceRefresh = false,
  }) async {
    final dashboard = await fetchDashboard(forceRefresh: forceRefresh);
    return dashboard.evidences;
  }

  Future<List<TripRecord>> getTripHistory({bool forceRefresh = false}) async {
    final dashboard = await fetchDashboard(forceRefresh: forceRefresh);
    return dashboard.tripHistory;
  }

  Future<List<DriverNotification>> getNotifications({
    bool forceRefresh = false,
  }) async {
    final dashboard = await fetchDashboard(forceRefresh: forceRefresh);
    return dashboard.notifications;
  }

  Uri _buildUri(
    String endpoint, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    var sanitized = endpoint.trim();
    if (!sanitized.startsWith('/')) {
      sanitized = '/$sanitized';
    }

    pathParameters?.forEach((key, value) {
      sanitized = sanitized.replaceAll('{${key}}', value);
    });

    final base = ApiConstants.baseUrl.endsWith('/')
        ? ApiConstants.baseUrl.substring(0, ApiConstants.baseUrl.length - 1)
        : ApiConstants.baseUrl;

    final uri = Uri.parse('$base$sanitized');

    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }

    final qp = queryParameters.map((key, value) => MapEntry(key, value.toString()));
    return uri.replace(queryParameters: qp);
  }

  Map<String, String> _defaultHeaders({bool includeAuth = true}) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (includeAuth && _authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = _extractErrorMessage(response.body) ??
          'Error de red (${response.statusCode}).';
      throw ApiException(message, statusCode: response.statusCode);
    }

    if (response.body.isEmpty) {
      return const {};
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is List) {
      return {'items': decoded};
    }

    return const {};
  }

  Map<String, dynamic> _unwrapDashboard(Map<String, dynamic> payload) {
    final data = _unwrapEnvelope(payload);
    if (data['dashboard'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data['dashboard'] as Map<String, dynamic>);
    }
    if (data['items'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data['items'] as Map<String, dynamic>);
    }
    if (data['data'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data['data'] as Map<String, dynamic>);
    }

    return data;
  }

  Map<String, dynamic> _unwrapEnvelope(Map<String, dynamic> payload) {
    if (payload['data'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(payload['data'] as Map<String, dynamic>);
    }
    if (payload['result'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(payload['result'] as Map<String, dynamic>);
    }
    return payload;
  }

  DriverProfile _extractDriver(Map<String, dynamic> payload) {
    final data = _unwrapEnvelope(payload);
    final driverJson = <String, dynamic>{}
      ..addAll(data['driver'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(data['driver'] as Map<String, dynamic>)
          : {})
      ..addAll(data['user'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(data['user'] as Map<String, dynamic>)
          : {})
      ..addAll(data['profile'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(data['profile'] as Map<String, dynamic>)
          : {});

    if (driverJson.isEmpty) {
      driverJson.addAll(data);
    }

    return DriverProfile.fromJson(driverJson);
  }

  String? _extractToken(Map<String, dynamic> payload, {String? fallback}) {
    final data = _unwrapEnvelope(payload);
    return data['token'] as String? ??
        data['accessToken'] as String? ??
        data['jwt'] as String? ??
        fallback;
  }

  String? _extractErrorMessage(String body) {
    if (body.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded['message'] as String? ??
            decoded['error'] as String? ??
            decoded['detail'] as String?;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
