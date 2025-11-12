import 'package:easy_travel/features/conductores/data/driver_repository.dart';
import 'package:easy_travel/features/conductores/domain/entities/check_item.dart';
import 'package:flutter/material.dart';

class CheckOutPage extends StatefulWidget {
  final VoidCallback onCompleted;

  const CheckOutPage({super.key, required this.onCompleted});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final repository = DriverRepository.instance;
  late Future<List<CheckItem>> _checklistFuture;
  final Map<String, bool> selections = {};
  final TextEditingController incidentsController = TextEditingController();
  List<CheckItem> _checklist = const [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _checklistFuture = repository.getCheckOutChecklist();
  }

  @override
  void dispose() {
    incidentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<CheckItem>>(
      future: _checklistFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          final message = snapshot.error is ApiException
              ? (snapshot.error as ApiException).message
              : 'No pudimos cargar el checklist de cierre.';
          return Scaffold(
            appBar: AppBar(
              title: const Text('Check-Out de ruta'),
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
                    onPressed: () {
                      setState(() {
                        _initialized = false;
                        _checklistFuture = repository.getCheckOutChecklist(forceRefresh: true);
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final items = snapshot.data ?? const <CheckItem>[];
        _initializeChecklist(items);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Check-Out de ruta'),
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
                          color: const Color(0xFFEB5757).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.logout_rounded, color: Color(0xFFEB5757)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cierre y reporte',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              'Confirma el estado del vehículo y adjunta novedades.',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: _checklist.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index == _checklist.length) {
                        return _IncidentCard(controller: incidentsController);
                      }
                      final item = _checklist[index];
                      return _ChecklistTile(
                        item: item,
                        value: selections[item.id] ?? false,
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
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Enviar reporte'),
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _initializeChecklist(List<CheckItem> items) {
    if (_initialized) {
      return;
    }
    _checklist = items;
    selections
      ..clear()
      ..addEntries(items.map((item) => MapEntry(item.id, selections[item.id] ?? false)));
    _initialized = true;
  }

  bool get _canSubmit =>
      _checklist.isNotEmpty && selections.values.every((value) => value);
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
                        Icons.priority_high,
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

class _IncidentCard extends StatelessWidget {
  final TextEditingController controller;

  const _IncidentCard({required this.controller});

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
            'Novedades e incidentes',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe daños, retrasos o incidentes relevantes...',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
          ),
        ],
      ),
    );
  }
}
