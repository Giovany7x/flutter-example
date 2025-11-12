import 'package:easy_travel/features/conductores/domain/entities/trip_record.dart';
import 'package:flutter/material.dart';

class TripHistoryTile extends StatelessWidget {
  final TripRecord record;

  const TripHistoryTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF56CCF2).withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.map_rounded, color: Color(0xFF2D9CDB)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.routeName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${record.distanceKm} km • ${record.date}',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                const SizedBox(height: 6),
                Text(record.feedback, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFF2C94C)),
              Text(record.rating.toStringAsFixed(1),
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
