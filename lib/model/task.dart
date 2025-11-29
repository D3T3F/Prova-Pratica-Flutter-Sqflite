import 'enum/priority_type.dart';
import 'enum/urgency_type.dart';

class Task {
  int? id;
  String titulo;
  String descricao;
  PriorityType prioridade;
  DateTime criadoEm;
  UrgencyType nivelUrgencia;

  Task({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.prioridade,
    required this.criadoEm,
    required this.nivelUrgencia,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': prioridade.index,
      'criadoEm': criadoEm.toIso8601String(),
      'nivelUrgencia': nivelUrgencia.index,
    };

    if (id != null) map['id'] = id;

    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      prioridade: PriorityType.values[map['prioridade']],
      criadoEm: DateTime.parse(map['criadoEm'] as String),
      nivelUrgencia: UrgencyType.values[map['nivelUrgencia']],
    );
  }
}
