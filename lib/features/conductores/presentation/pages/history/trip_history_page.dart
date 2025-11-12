import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/domain/entities/trip_record.dart';
import 'package:easy_travel/features/conductores/presentation/widgets/trip_history_tile.dart';
import 'package:flutter/material.dart';

class TripHistoryPage extends StatefulWidget {
  final DriverRepository repository;

  const TripHistoryPage({super.key, required this.repository});

  @override
  State<TripHistoryPage> createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
  late Future<List<TripRecord>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = widget.repository.getTripHistory();
  }

  void _retry() {
    setState(() {
      _historyFuture = widget.repository.getTripHistory(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TripRecord>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          final message = snapshot.error is ApiException
              ? (snapshot.error as ApiException).message
              : 'No pudimos cargar el historial.';
          return Scaffold(
            appBar: AppBar(
              title: const Text('Historial de viajes'),
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _retry,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final records = snapshot.data ?? const <TripRecord>[];
        final averageRating = records.isEmpty
            ? 0.0
            : records
                    .map((record) => record.rating.toDouble())
                    .reduce((value, element) => value + element) /
                records.length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Historial de viajes'),
            centerTitle: false,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              _retry();
              await _historyFuture;
            },
            child: records.isEmpty
                ? ListView(
                    padding: const EdgeInsets.all(24),
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('Sin viajes registrados aún.')),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                    children: [
                      _SummaryHeader(
                        totalTrips: records.length,
                        averageRating: averageRating,
                      ),
                      const SizedBox(height: 24),
                      ...records.map(
                        (record) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TripHistoryTile(record: record),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
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
