import 'package:flutter/material.dart';
import 'package:prova_partica/pages/task_list_page.dart';

void main() {
  runApp(const MyApp());
}

final ThemeData temaLava = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.red,
    primary: Colors.red,
    secondary: Colors.deepOrangeAccent,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: temaLava,
      home: const TaskListPage(),
    );
  }
}