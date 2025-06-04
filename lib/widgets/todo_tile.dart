import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({required this.todo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(todo.completed ? Icons.check_circle : Icons.circle_outlined,
          color: todo.completed ? Colors.green : Colors.grey),
      title: Text(todo.todo),
    );
  }
}
