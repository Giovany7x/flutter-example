import 'package:easy_travel/features/conductores/domain/entities/trip_record.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/trip_history_tile.dart';
import 'package:flutter/material.dart';

class TripHistoryPage extends StatelessWidget {
  final List<TripRecord> records;

  const TripHistoryPage({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    final averageRating = records.isEmpty
        ? 0
        : records.map((record) => record.rating).reduce((value, element) => value + element) /
            records.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de viajes'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        children: [
          _SummaryHeader(totalTrips: records.length, averageRating: averageRating),
          const SizedBox(height: 24),
          ...records.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TripHistoryTile(record: record),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final int totalTrips;
  final double averageRating;

  const _SummaryHeader({required this.totalTrips, required this.averageRating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D9CDB).withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF2D9CDB)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$totalTrips viajes completados',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Calificación promedio ${averageRating.toStringAsFixed(1)}',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const Icon(Icons.star_rate_rounded, color: Color(0xFFF2C94C)),
        ],
      ),
    );
  }
}
