import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../model/task.dart';
import '../model/enum/priority_type.dart';
import '../model/enum/urgency_type.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  PriorityType _prioridade = PriorityType.low;
  UrgencyType _nivelUrgencia = UrgencyType.veryLow;

  final DbHelper _db = DbHelper.instance;

  @override
  void initState() {
    super.initState();

    if (widget.task == null) return;

    _tituloController.text = widget.task!.titulo;
    _descricaoController.text = widget.task!.descricao;
    _prioridade = widget.task!.prioridade;
    _nivelUrgencia = widget.task!.nivelUrgencia;
  }

  @override
  void dispose() {
    _tituloController.dispose();

    _descricaoController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();

    if (widget.task == null) {
      final newTask = Task(
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        prioridade: _prioridade,
        nivelUrgencia: _nivelUrgencia,
        criadoEm: now,
      );

      await _db.insertTask(newTask);
    }

    if (widget.task != null) {
      final updated = Task(
        id: widget.task!.id,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        prioridade: _prioridade,
        nivelUrgencia: _nivelUrgencia,
        criadoEm: widget.task!.criadoEm,
      );

      await _db.updateTask(updated);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o título' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a descrição'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PriorityType>(
                initialValue: _prioridade,
                decoration: const InputDecoration(
                  labelText: 'Prioridade (1–3)',
                ),
                items: PriorityType.values.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(priorityMap[p]!),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _prioridade = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<UrgencyType>(
                initialValue: _nivelUrgencia,
                decoration: const InputDecoration(
                  labelText: 'Nível de Urgência',
                ),
                items: UrgencyType.values.map((u) {
                  return DropdownMenuItem(
                    value: u,
                    child: Text(urgencyMap[u]!),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _nivelUrgencia = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
