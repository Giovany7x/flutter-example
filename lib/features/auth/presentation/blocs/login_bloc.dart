import 'dart:async';
import 'package:easy_travel/core/enums/status.dart';
import 'package:easy_travel/features/auth/data/auth_service.dart';
import 'package:easy_travel/features/auth/presentation/blocs/login_event.dart';
import 'package:easy_travel/features/auth/presentation/blocs/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService service;
  LoginBloc({required this.service}) : super(LoginState()) {
    on<Login>(_login);
    on<OnEmailChanged>(_onEmailChanged);
    on<OnPasswordChanged>(_onPasswordChanged);
    on<OnTogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  FutureOr<void> _onEmailChanged(OnEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  FutureOr<void> _onPasswordChanged(OnPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  FutureOr<void> _onTogglePasswordVisibility(OnTogglePasswordVisibility event, Emitter<LoginState> emit) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  FutureOr<void> _login(Login event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await service.login(state.email, state.password);
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}
