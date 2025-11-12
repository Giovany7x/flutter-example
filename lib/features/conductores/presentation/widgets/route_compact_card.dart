import 'package:easy_travel/features/conductores/domain/entities/driver_route.dart';
import 'package:flutter/material.dart';

class RouteCompactCard extends StatelessWidget {
  final DriverRoute route;
  final VoidCallback onTap;

  const RouteCompactCard({super.key, required this.route, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E86FE).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.alt_route_rounded, color: Color(0xFF0E86FE)),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: route.status == 'En curso'
                          ? const Color(0xFF27AE60).withOpacity(0.15)
                          : const Color(0xFFF2C94C).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      route.status,
                      style: TextStyle(
                        color: route.status == 'En curso'
                            ? const Color(0xFF219653)
                            : const Color(0xFFF2994A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                route.name,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${route.origin} → ${route.destination}',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.watch_later_outlined, size: 18, color: Color(0xFF6C757D)),
                  const SizedBox(width: 4),
                  Text(route.schedule, style: theme.textTheme.bodySmall),
                  const Spacer(),
                  Text('${(route.progress * 100).round()}% completado',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: route.progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(12),
                backgroundColor: const Color(0xFFE9F2FF),
                valueColor: AlwaysStoppedAnimation(route.status == 'En curso'
                    ? const Color(0xFF2D9CDB)
                    : const Color(0xFFBDBDBD)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
