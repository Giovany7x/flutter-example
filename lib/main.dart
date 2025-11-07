import 'package:easy_travel/features/flota365/flota365_module.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

/// Punto de entrada de la aplicación que monta únicamente el módulo Flota365.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Flota365Module();
  }
}
