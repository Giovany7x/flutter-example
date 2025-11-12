import 'package:easy_travel/features/conductores/domain/entities/driver_route.dart';
import 'package:flutter/material.dart';

class RouteDetailPage extends StatelessWidget {
  final DriverRoute route;

  const RouteDetailPage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(route.name),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        children: [
          _HeaderCard(route: route),
          const SizedBox(height: 24),
          const Text(
            'Puntos de control',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...route.checkpoints.map(
            (checkpoint) => Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: ListTile(
                leading: const Icon(Icons.place_rounded, color: Color(0xFF0E86FE)),
                title: Text(checkpoint),
                subtitle: Text('Tiempo estimado: ${(route.progress * 100).round()}% completado'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRoutePreview(context, route),
        icon: const Icon(Icons.navigation_rounded),
        label: const Text('Iniciar navegación'),
      ),
    );
  }

  void _showRoutePreview(BuildContext context, DriverRoute route) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              route.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.flag_circle_rounded, color: Color(0xFF27AE60)),
                const SizedBox(width: 8),
                Text('Destino: ${route.destination}'),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Paradas sugeridas'),
            const SizedBox(height: 8),
            ...route.checkpoints.map((checkpoint) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Color(0xFF0E86FE)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(checkpoint)),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Confirmar ruta'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final DriverRoute route;

  const _HeaderCard({required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E86FE).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.local_shipping_rounded, color: Color(0xFF0E86FE)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(route.origin, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.arrow_downward, color: Color(0xFF0E86FE)),
                        SizedBox(width: 4),
                        Text('Recorrido'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(route.destination, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.watch_later_outlined, color: Color(0xFF6C757D)),
              const SizedBox(width: 6),
              Text(route.schedule),
              const Spacer(),
              Text('${(route.progress * 100).round()}% completado',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
