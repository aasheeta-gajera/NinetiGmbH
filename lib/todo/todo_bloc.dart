
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'todo_event.dart';
import 'todo_state.dart';
import '../../models/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<FetchTodos>(_onFetchTodos);
  }

  Future<void> _onFetchTodos(FetchTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final url = 'https://dummyjson.com/todos/user/${event.userId}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> todosJson = data['todos'];
        final todos = todosJson.map((e) => Todo.fromJson(e)).toList();
        emit(TodoLoaded(todos));
      } else {
        emit(TodoError('Failed to fetch todos'));
      }
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
