import 'package:easy_travel/features/conductores/presentation/app/conductores_module.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

/// Punto de entrada de la aplicación que monta únicamente el módulo de conductores.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ConductoresModule();
  }
}
