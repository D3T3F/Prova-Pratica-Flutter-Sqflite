class Task {
  int? id;
  String titulo;
  String descricao;
  int prioridade;
  DateTime criadoEm;
  int nivelUrgencia;

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
      'prioridade': prioridade,
      'criadoEm': criadoEm.toIso8601String(),
      'nivelUrgencia': nivelUrgencia,
    };

    if (id != null) map['id'] = id;

    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      prioridade: map['prioridade'] as int,
      criadoEm: DateTime.parse(map['criadoEm'] as String),
      nivelUrgencia: map['nivelUrgencia'] as int,
    );
  }
}
