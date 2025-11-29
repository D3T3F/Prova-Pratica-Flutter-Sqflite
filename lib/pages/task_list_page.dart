import 'package:flutter/material.dart';
import 'package:prova_partica/model/enum/priority_type.dart';
import 'package:prova_partica/model/enum/urgency_type.dart';
import '../data/db_helper.dart';
import '../model/task.dart';
import 'task_form_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final DbHelper _db = DbHelper.instance;
  List<Task> _tasks = [];
  bool _loading = true;

  final priorityIcons = {
    PriorityType.low: Icons.arrow_downward,
    PriorityType.medium: Icons.drag_handle,
    PriorityType.high: Icons.warning,
  };

  @override
  void initState() {
    super.initState();

    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _loading = true);

    final tasks = await _db.getAllTasks();

    setState(() {
      _tasks = tasks;
      _loading = false;
    });
  }

  Future<void> _openForm({Task? task}) async {
    final saved =
        (await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => TaskFormPage(task: task)),
        )) ??
        false;

    if (!saved) return;

    _loadTasks();
  }

  Future<void> _deleteTask(Task task) async {
    await _db.deleteTask(task.id!);

    _loadTasks();
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  Color _priorityColor(PriorityType prioridade, BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final priorityColorMap = {
      PriorityType.low: scheme.primary,
      PriorityType.medium: scheme.secondary,
      PriorityType.high: scheme.error,
    };

    return priorityColorMap[prioridade] ?? scheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas Profissionais'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
          ? const Center(child: Text('Nenhuma tarefa cadastrada.'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: ValueKey(task.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: scheme.error,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteTask(task),
                  child: ListTile(
                    title: Text(task.titulo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.descricao),
                        Text('Criado em: ${_formatDate(task.criadoEm)}'),
                        Text(
                          'Nível urgência: ${urgencyMap[task.nivelUrgencia]}',
                        ),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundColor: _priorityColor(task.prioridade, context),
                      child: Icon(
                        priorityIcons[task.prioridade],
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => _openForm(task: task),
                  ),
                );
              },
            ),
    );
  }
}
