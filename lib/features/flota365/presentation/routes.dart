/// Lista centralizada de rutas internas del módulo Flota365.
///
/// Tener las rutas en un solo lugar evita errores tipográficos y facilita la
/// navegación desde otras pantallas o módulos de la aplicación.
class Flota365Routes {
  Flota365Routes._();

  static const String welcome = '/';
  static const String loginSelection = '/login-selection';
  static const String loginDriver = '/login-driver';
  static const String loginManager = '/login-manager';
  static const String registerDriver = '/register-driver';
  static const String registerManager = '/register-manager';
  static const String dashboard = '/dashboard';
  static const String managerDashboard = '/manager-dashboard';
  static const String managerTeam = '/manager-team';
  static const String managerEvidence = '/manager-evidence';
  static const String managerReports = '/manager-reports';
  static const String checkIn = '/check-in';
  static const String checkOut = '/check-out';
  static const String routes = '/routes';
  static const String routeDetail = '/route-detail';
  static const String uploadEvidence = '/upload-evidence';
  static const String tripHistory = '/trip-history';
  static const String notifications = '/notifications';
}
