import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/domain/entities/driver_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum DriverSessionStatus { initial, authenticated }

class DriverSessionState {
  final DriverSessionStatus status;
  final DriverProfile? driver;

  const DriverSessionState._({
    required this.status,
    this.driver,
  });

  const DriverSessionState.initial() : this._(status: DriverSessionStatus.initial);

  const DriverSessionState.authenticated(DriverProfile driver)
      : this._(status: DriverSessionStatus.authenticated, driver: driver);
}

/// Gestiona el estado de autenticación del conductor dentro del módulo.
class DriverSessionCubit extends Cubit<DriverSessionState> {
  DriverSessionCubit({DriverRepository? repository})
      : _repository = repository ?? DriverRepository.instance,
        super(const DriverSessionState.initial());

  final DriverRepository _repository;

  Future<void> signInDemoDriver() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    emit(DriverSessionState.authenticated(_repository.demoDriver));
  }

  void signOut() {
    emit(const DriverSessionState.initial());
  }

  DriverProfile get demoDriver => _repository.demoDriver;
}
