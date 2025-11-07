import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/domain/models/driver_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Estado que describe la sesión actual del conductor dentro de Flota365.
///
/// Contiene la información básica del conductor autenticado y banderas
/// para controlar el flujo de navegación entre pantallas.
class DriverSessionState {
  /// Perfil del conductor activo. `null` cuando no hay sesión iniciada.
  final DriverProfile? driver;

  /// Indica si se está mostrando un cargador mientras se valida la sesión.
  final bool isLoading;

  const DriverSessionState({
    this.driver,
    this.isLoading = false,
  });

  /// Constructor de conveniencia para el estado inicial sin sesión.
  const DriverSessionState.initial() : this(driver: null, isLoading: false);

  /// Copia el estado actual cambiando solo las propiedades provistas.
  DriverSessionState copyWith({
    DriverProfile? driver,
    bool? isLoading,
  }) {
    return DriverSessionState(
      driver: driver ?? this.driver,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Atajo para saber si existe un conductor autenticado.
  bool get isLoggedIn => driver != null;
}

/// Cubit que centraliza la autenticación mínima para el demo de Flota365.
///
/// En una integración real, aquí llamarías a tu backend para verificar
/// credenciales y mantener el estado global del módulo.
class DriverSessionCubit extends Cubit<DriverSessionState> {
  /// Repositorio que provee los datos de ejemplo.
  final FleetRepository repository;

  DriverSessionCubit({required this.repository})
      : super(const DriverSessionState.initial());

  /// Realiza un "inicio de sesión" con datos de demostración.
  ///
  /// Se utiliza un pequeño retardo para simular una llamada a red.
  Future<void> signInDemoDriver() async {
    emit(state.copyWith(isLoading: true));
    await Future<void>.delayed(const Duration(milliseconds: 600));
    emit(
      state.copyWith(
        isLoading: false,
        driver: repository.demoDriver,
      ),
    );
  }

  /// Cierra la sesión y regresa al flujo inicial del módulo.
  void signOut() {
    emit(const DriverSessionState.initial());
  }
}
