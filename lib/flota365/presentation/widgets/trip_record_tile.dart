import 'package:easy_travel/flota365/domain/models/trip_record.dart';
import 'package:flutter/material.dart';

/// Elemento de lista para mostrar un viaje del historial.
class TripRecordTile extends StatelessWidget {
  final TripRecord record;

  const TripRecordTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(record.routeName),
        subtitle: Text('${record.date} • ${record.distanceKm.toStringAsFixed(1)} km'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            Text(record.rating.toStringAsFixed(1)),
          ],
        ),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(record.routeName),
              content: Text(record.feedback),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
