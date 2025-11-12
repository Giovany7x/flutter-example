import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum DriverSessionStatus { initial, loading, authenticated, failure }

class DriverSessionState {
  final DriverSessionStatus status;
  final DriverProfile? driver;
  final String? errorMessage;

  const DriverSessionState({
    required this.status,
    this.driver,
    this.errorMessage,
  });

  const DriverSessionState.initial() : this(status: DriverSessionStatus.initial);

  DriverSessionState copyWith({
    DriverSessionStatus? status,
    DriverProfile? driver,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DriverSessionState(
      status: status ?? this.status,
      driver: driver ?? this.driver,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Gestiona el estado de autenticación del conductor dentro del módulo.
class DriverSessionCubit extends Cubit<DriverSessionState> {
  DriverSessionCubit({DriverRepository? repository})
      : _repository = repository ?? DriverRepository.instance,
        super(const DriverSessionState.initial());

  final DriverRepository _repository;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: DriverSessionStatus.loading, clearError: true));
    try {
      final driver = await _repository.signIn(email: email, password: password);
      emit(state.copyWith(status: DriverSessionStatus.authenticated, driver: driver));
    } on ApiException catch (error) {
      emit(state.copyWith(
        status: DriverSessionStatus.failure,
        errorMessage: error.message,
        driver: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DriverSessionStatus.failure,
        errorMessage: 'No se pudo iniciar sesión. Intenta nuevamente.',
        driver: null,
      ));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String licenseNumber,
  }) async {
    emit(state.copyWith(status: DriverSessionStatus.loading, clearError: true));
    try {
      final driver = await _repository.register(
        fullName: fullName,
        email: email,
        password: password,
        licenseNumber: licenseNumber,
      );
      emit(state.copyWith(status: DriverSessionStatus.authenticated, driver: driver));
    } on ApiException catch (error) {
      emit(state.copyWith(
        status: DriverSessionStatus.failure,
        errorMessage: error.message,
        driver: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DriverSessionStatus.failure,
        errorMessage: 'No se pudo registrar la cuenta. Intenta nuevamente.',
        driver: null,
      ));
    }
  }

  Future<void> restoreSession() async {
    final driver = _repository.currentDriver;
    if (driver != null) {
      emit(state.copyWith(status: DriverSessionStatus.authenticated, driver: driver));
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    emit(const DriverSessionState.initial());
  }
}
