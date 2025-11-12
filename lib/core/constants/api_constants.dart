class ApiConstants {
  static const String baseUrl =
      'https://underground-tuesday-renworkplace-1e2821cb.koyeb.app';

  static const String loginEndpoint = '/api/Auth/login';
  static const String registerEndpoint = '/api/Auth/register';
  static const String driverProfileEndpoint = '/api/Drivers/{driverId}';
  static const String driverDashboardEndpoint =
      '/api/Drivers/{driverId}/dashboard';
}
