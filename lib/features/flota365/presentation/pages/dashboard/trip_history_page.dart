import 'package:easy_travel/features/flota365/data/fleet_repository.dart';
import 'package:easy_travel/features/flota365/presentation/widgets/trip_record_tile.dart';
import 'package:flutter/material.dart';

/// Historial de viajes completados.
class TripHistoryPage extends StatelessWidget {
  final FleetRepository repository;

  const TripHistoryPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final trips = repository.getTripHistory(repository.demoDriver.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de viajes')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemBuilder: (context, index) => TripRecordTile(record: trips[index]),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: trips.length,
      ),
    );
  }
}
