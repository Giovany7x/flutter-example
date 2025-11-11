import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Modelo que describe cada paso del flujo del conductor mostrado en el carrusel.
class DriverFlowStep {
  /// Título del paso mostrado en la tarjeta.
  final String title;

  /// Descripción breve que acompaña el título.
  final String description;

  /// Icono representativo del paso.
  final IconData icon;

  /// Color principal utilizado para el degradado de fondo.
  final Color accentColor;

  /// Crea un paso del flujo del conductor.
  const DriverFlowStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}

/// Carrusel interactivo que resume cada pantalla del flujo del conductor.
///
/// Replica la secuencia mostrada en la maqueta compartida: dashboard, check-in,
/// check-out, rutas, detalle, evidencias e historial. Cada tarjeta incluye un
/// pequeño "mock" ilustrado para que los conductores entiendan qué esperar de
/// cada paso antes de navegar.
class DriverFlowShowcase extends StatefulWidget {
  /// Pasos que se mostrarán en el carrusel.
  final List<DriverFlowStep> steps;

  /// Callback opcional cuando el usuario pulsa una tarjeta del carrusel.
  final ValueChanged<DriverFlowStep>? onStepSelected;

  const DriverFlowShowcase({
    super.key,
    required this.steps,
    this.onStepSelected,
  });

  @override
  State<DriverFlowShowcase> createState() => _DriverFlowShowcaseState();
}

class _DriverFlowShowcaseState extends State<DriverFlowShowcase> {
  late final PageController _controller;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.78);
    _controller.addListener(_handlePageChange);
  }

  void _handlePageChange() {
    final page = _controller.page;
    if (page == null) return;
    setState(() => _currentPage = page);
  }

  @override
  void dispose() {
    _controller.removeListener(_handlePageChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.steps.length,
            itemBuilder: (context, index) {
              final step = widget.steps[index];
              final distance = (_currentPage - index).abs();
              final clamped = math.min(distance, 1.0);
              final scale = 1 - (clamped * 0.12);
              final opacity = 1 - (clamped * 0.35);

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: GestureDetector(
                    onTap: () => widget.onStepSelected?.call(step),
                    child: _DriverFlowCard(step: step),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.steps.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _isActive(i) ? 24 : 8,
                decoration: BoxDecoration(
                  color: _isActive(i)
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(999)),
                ),
              ),
          ],
        ),
      ],
    );
  }

  bool _isActive(int index) {
    return (_currentPage - index).abs() < 0.5;
  }
}

class _DriverFlowCard extends StatelessWidget {
  final DriverFlowStep step;

  const _DriverFlowCard({required this.step});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            step.accentColor.withOpacity(0.95),
            step.accentColor.withOpacity(0.65),
            theme.colorScheme.surfaceVariant.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: step.accentColor.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.18),
                  child: Icon(step.icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              step.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            _MockupPreview(accentColor: step.accentColor),
          ],
        ),
      ),
    );
  }
}

class _MockupPreview extends StatelessWidget {
  final Color accentColor;

  const _MockupPreview({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.white.withOpacity(0.95);

    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: baseColor,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 6,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: accentColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 10,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: accentColor.withOpacity(0.45),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 10,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: accentColor.withOpacity(0.25),
              ),
            ),
            const Spacer(),
            Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [accentColor, accentColor.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
