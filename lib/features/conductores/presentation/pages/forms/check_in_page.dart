import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/domain/entities/check_item.dart';
import 'package:flutter/material.dart';

class CheckInPage extends StatefulWidget {
  final VoidCallback onCompleted;

  const CheckInPage({super.key, required this.onCompleted});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final repository = DriverRepository.instance;
  late final List<CheckItem> checklist;
  final Map<String, bool> selections = {};
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checklist = repository.getCheckInChecklist();
    for (final item in checklist) {
      selections[item.id] = false;
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In vehicular'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          children: [
            Container(
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
                      color: const Color(0xFF27AE60).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.directions_car_filled_rounded, color: Color(0xFF27AE60)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Checklist del turno', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Confirma los puntos críticos antes de iniciar la ruta.',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: checklist.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == checklist.length) {
                    return _NotesCard(controller: notesController);
                  }
                  final item = checklist[index];
                  return _ChecklistTile(
                    item: item,
                    value: selections[item.id]!,
                    onChanged: (value) {
                      setState(() {
                        selections[item.id] = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SafeArea(
              top: false,
              child: FilledButton.icon(
                onPressed: _canSubmit ? widget.onCompleted : null,
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('Completar Check-In'),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  bool get _canSubmit => selections.values.every((value) => value);
}

class _ChecklistTile extends StatelessWidget {
  final CheckItem item;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _ChecklistTile({required this.item, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: value, onChanged: onChanged, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (item.isCritical)
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFE74C3C),
                      ),
                  ],
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  final TextEditingController controller;

  const _NotesCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Observaciones',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe cualquier novedad relevante antes de salir...',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
          ),
        ],
      ),
    );
  }
}
