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

enum SortMode { date, priority, urgency }

class _TaskListPageState extends State<TaskListPage> {
  final DbHelper _db = DbHelper.instance;
  List<Task> _tasks = [];
  bool _loading = true;

  bool _isSortReverse = false;
  SortMode _sortMode = SortMode.date;

  final priorityIcons = {
    PriorityType.low: Icons.info_outline,
    PriorityType.medium: Icons.error,
    PriorityType.high: Icons.warning_rounded,
  };

  @override
  void initState() {
    super.initState();

    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _loading = true);

    final tasks = await _db.getAllTasks();

    _applySort(tasks, _sortMode);

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
      PriorityType.low: scheme.secondary,
      PriorityType.medium: scheme.primary,
      PriorityType.high: scheme.error,
    };

    return priorityColorMap[prioridade] ?? scheme.primary;
  }

  void _applySort(List<Task> list, SortMode mode) {
    _isSortReverse = (mode == _sortMode) ? !_isSortReverse : false;
    _sortMode = mode;

    list.sort((a, b) {
      var result = 0;

      switch (mode) {
        case SortMode.date:
          result = b.criadoEm.compareTo(a.criadoEm);
          break;

        case SortMode.priority:
          result = b.prioridade.index.compareTo(a.prioridade.index);
          break;

        case SortMode.urgency:
          result = b.nivelUrgencia.index.compareTo(a.nivelUrgencia.index);
          break;
      }

      return _isSortReverse ? -result : result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas Profissionais'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        actions: [
          PopupMenuButton<SortMode>(
            icon: const Icon(Icons.sort),
            onSelected: (mode) {
              setState(() {
                _applySort(_tasks, mode);
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: SortMode.date,
                child: Text('Ordenar por data'),
              ),
              PopupMenuItem(
                value: SortMode.priority,
                child: Text('Ordenar por prioridade'),
              ),
              PopupMenuItem(
                value: SortMode.urgency,
                child: Text('Ordenar por urgência'),
              ),
            ],
          ),
        ],
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
                  child: Column(
                    children: [
                      ListTile(
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
                          backgroundColor: _priorityColor(
                            task.prioridade,
                            context,
                          ),
                          child: Icon(
                            priorityIcons[task.prioridade],
                            color: Colors.white,
                          ),
                        ),
                        onTap: () => _openForm(task: task),
                      ),
                      if (index != _tasks.length - 1) const Divider(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
