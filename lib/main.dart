import 'package:flutter/material.dart';

void main() {
  runApp(const GymTrackerApp());
}

class GymTrackerApp extends StatelessWidget {
  const GymTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ExerciseTrackerPage(),
    );
  }
}

class ExerciseEntry {
  ExerciseEntry({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weightKg,
    required this.date,
    this.completed = false,
  });

  final String name;
  final int sets;
  final int reps;
  final double weightKg;
  final DateTime date;
  bool completed;
}

class ExerciseTrackerPage extends StatefulWidget {
  const ExerciseTrackerPage({super.key});

  @override
  State<ExerciseTrackerPage> createState() => _ExerciseTrackerPageState();
}

class _ExerciseTrackerPageState extends State<ExerciseTrackerPage> {
  final List<ExerciseEntry> _entries = [
    ExerciseEntry(
      name: 'Press banca',
      sets: 4,
      reps: 8,
      weightKg: 60,
      date: DateTime.now(),
    ),
    ExerciseEntry(
      name: 'Sentadilla',
      sets: 4,
      reps: 10,
      weightKg: 80,
      date: DateTime.now(),
    ),
  ];

  void _openCreateDialog() {
    final nameController = TextEditingController();
    final setsController = TextEditingController();
    final repsController = TextEditingController();
    final weightController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo ejercicio'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Ejercicio'),
                ),
                TextField(
                  controller: setsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Series'),
                ),
                TextField(
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Repeticiones'),
                ),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final sets = int.tryParse(setsController.text.trim());
                final reps = int.tryParse(repsController.text.trim());
                final weight = double.tryParse(weightController.text.trim());

                if (name.isEmpty || sets == null || reps == null || weight == null) {
                  return;
                }

                setState(() {
                  _entries.add(
                    ExerciseEntry(
                      name: name,
                      sets: sets,
                      reps: reps,
                      weightKg: weight,
                      date: DateTime.now(),
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final completed = _entries.where((entry) => entry.completed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker de Gym'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text('Ejercicios: ${_entries.length}'),
                subtitle: Text('Completados hoy: $completed'),
              ),
            ),
          ),
          Expanded(
            child: _entries.isEmpty
                ? const Center(child: Text('Todavía no agregaste ejercicios.'))
                : ListView.builder(
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return CheckboxListTile(
                        value: entry.completed,
                        onChanged: (value) {
                          setState(() {
                            entry.completed = value ?? false;
                          });
                        },
                        title: Text(entry.name),
                        subtitle: Text(
                          '${entry.sets} series • ${entry.reps} reps • ${entry.weightKg.toStringAsFixed(1)} kg',
                        ),
                        secondary: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              _entries.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }
}
